using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(DynamicGridController))]
[RequireComponent(typeof(MeshFilter))]
public class PlaneVisualizationController : MonoBehaviour
{
	public ITrackedPlane plane;

	public float pulseSpeed = 4f;

	public Vector3 focalPoint = Vector3.zero;

	public bool isActive;

	private PlaneFocusController m_PlaneFocusController;

	private SelectionCoordinator m_SelectionCoordinator;

	private DynamicGridController m_DynamicGridController;

	private void Awake()
	{
		m_DynamicGridController = GetComponent<DynamicGridController>();
		m_DynamicGridController.Hide(0f);
		if (ElementsSystem.instance == null)
		{
			Debug.LogWarning("ElementSystem is not available. Visual state of DynamicGrid must be controlled directly.");
		}
		m_PlaneFocusController = ElementsSystem.instance.planeFocusController;
		if (m_PlaneFocusController != null)
		{
			PlaneFocusController planeFocusController = m_PlaneFocusController;
			planeFocusController.onFocusChanged = (Action<List<PlaneFocusPoint>>)Delegate.Combine(planeFocusController.onFocusChanged, new Action<List<PlaneFocusPoint>>(OnChangeFocalPoint));
			PlaneFocusController planeFocusController2 = m_PlaneFocusController;
			planeFocusController2.onFocusStarted = (Action<List<PlaneFocusPoint>>)Delegate.Combine(planeFocusController2.onFocusStarted, new Action<List<PlaneFocusPoint>>(OnFocusStarted));
			PlaneFocusController planeFocusController3 = m_PlaneFocusController;
			planeFocusController3.onFocusEnded = (Action<List<PlaneFocusPoint>>)Delegate.Combine(planeFocusController3.onFocusEnded, new Action<List<PlaneFocusPoint>>(OnFocusEnded));
		}
		m_SelectionCoordinator = ElementsSystem.instance.selectionCoordinator;
		if (m_SelectionCoordinator != null)
		{
			SelectionCoordinator selectionCoordinator = m_SelectionCoordinator;
			selectionCoordinator.onSelect = (SelectionCoordinator.SelectionEvent)Delegate.Combine(selectionCoordinator.onSelect, new SelectionCoordinator.SelectionEvent(OnSelectItem));
			SelectionCoordinator selectionCoordinator2 = m_SelectionCoordinator;
			selectionCoordinator2.onDeselect = (SelectionCoordinator.SelectionEvent)Delegate.Combine(selectionCoordinator2.onDeselect, new SelectionCoordinator.SelectionEvent(OnDeselectItem));
		}
	}

	private void OnDestroy()
	{
		if (m_PlaneFocusController != null)
		{
			PlaneFocusController planeFocusController = m_PlaneFocusController;
			planeFocusController.onFocusChanged = (Action<List<PlaneFocusPoint>>)Delegate.Remove(planeFocusController.onFocusChanged, new Action<List<PlaneFocusPoint>>(OnChangeFocalPoint));
			PlaneFocusController planeFocusController2 = m_PlaneFocusController;
			planeFocusController2.onFocusStarted = (Action<List<PlaneFocusPoint>>)Delegate.Remove(planeFocusController2.onFocusStarted, new Action<List<PlaneFocusPoint>>(OnFocusStarted));
			PlaneFocusController planeFocusController3 = m_PlaneFocusController;
			planeFocusController3.onFocusEnded = (Action<List<PlaneFocusPoint>>)Delegate.Remove(planeFocusController3.onFocusEnded, new Action<List<PlaneFocusPoint>>(OnFocusEnded));
		}
		if (m_SelectionCoordinator != null)
		{
			SelectionCoordinator selectionCoordinator = m_SelectionCoordinator;
			selectionCoordinator.onSelect = (SelectionCoordinator.SelectionEvent)Delegate.Remove(selectionCoordinator.onSelect, new SelectionCoordinator.SelectionEvent(OnSelectItem));
			SelectionCoordinator selectionCoordinator2 = m_SelectionCoordinator;
			selectionCoordinator2.onDeselect = (SelectionCoordinator.SelectionEvent)Delegate.Remove(selectionCoordinator2.onDeselect, new SelectionCoordinator.SelectionEvent(OnSelectItem));
		}
	}

	public void OnChangeFocalPoint(List<PlaneFocusPoint> focusPoints)
	{
		plane = GetComponent<DynamicGridPlaneLayer>().plane;
		foreach (PlaneFocusPoint focusPoint in focusPoints)
		{
			if (plane == focusPoint.plane)
			{
				if (!isActive)
				{
					m_DynamicGridController.Show();
					m_DynamicGridController.ShowFocalPoint();
					isActive = true;
				}
				m_DynamicGridController.SetFocalPoint(focusPoint.worldPoint);
			}
			else if (isActive)
			{
				m_DynamicGridController.Hide();
				isActive = false;
			}
		}
	}

	public void OnFocusStarted(List<PlaneFocusPoint> focusPoints)
	{
		plane = GetComponent<DynamicGridPlaneLayer>().plane;
		if (IsFocusedOnPlane(focusPoints, plane))
		{
			m_DynamicGridController.ShowFocalPoint();
		}
	}

	public void OnFocusEnded(List<PlaneFocusPoint> focusPoints)
	{
		plane = GetComponent<DynamicGridPlaneLayer>().plane;
		if (!isActive)
		{
			return;
		}
		TranslationController[] array = UnityEngine.Object.FindObjectsOfType<TranslationController>();
		foreach (TranslationController translationController in array)
		{
			if (translationController.isTransformationFinishing)
			{
				if (!translationController.placedOnNewPlane)
				{
					return;
				}
				break;
			}
		}
		float num = Mathf.Min(plane.size.x, plane.size.y);
		float fadeDuration = num / pulseSpeed;
		m_DynamicGridController.Pulse(num * 0.5f, fadeDuration);
		isActive = false;
	}

	public void OnSelectItem(SelectableItem item)
	{
		plane = GetComponent<DynamicGridPlaneLayer>().plane;
		ITrackedPlane itemPlane = GetItemPlane(item);
		if (itemPlane == plane)
		{
			m_DynamicGridController.SetFocalPoint(item.transform.position);
			m_DynamicGridController.Show();
			m_DynamicGridController.ShowFocalPoint();
			isActive = true;
		}
	}

	public void OnDeselectItem(SelectableItem item)
	{
		if ((bool)this)
		{
			plane = GetComponent<DynamicGridPlaneLayer>().plane;
			ITrackedPlane itemPlane = GetItemPlane(item);
			if (itemPlane == plane)
			{
				m_DynamicGridController.HideFocalPoint();
				m_DynamicGridController.Hide();
				isActive = false;
			}
		}
	}

	private ITrackedPlane GetItemPlane(SelectableItem item)
	{
		Ray ray = new Ray(item.transform.position + Vector3.up * 0.01f, Vector3.down);
		if (ElementsSystem.instance.planeManager.Raycast(ray, out var hit))
		{
			return hit.plane;
		}
		return null;
	}

	public static bool IsFocusedOnPlane(List<PlaneFocusPoint> focusPoints, ITrackedPlane plane)
	{
		if (focusPoints.Count > 0 && focusPoints[0].plane == plane)
		{
			return true;
		}
		return false;
	}
}
}
