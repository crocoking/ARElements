using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class PlaneFocusController : MonoBehaviour
{
	public Vector2 gazeFocusViewportPosition = new Vector2(0.5f, 0.5f);

	public FocusMode focusMode = FocusMode.Gaze;

	public FocusMode deselectFocusMode = FocusMode.Gaze;

	[HideInInspector]
	public List<PlaneFocusPoint> focusPoints = new List<PlaneFocusPoint>();

	public Action<List<PlaneFocusPoint>> onFocusChanged;

	public Action<List<PlaneFocusPoint>> onFocusStarted;

	public Action<List<PlaneFocusPoint>> onFocusEnded;

	private FocusMode m_LastFocusMode;

	private SelectionCoordinator m_selectionCoordinator;

	private void Start()
	{
		m_selectionCoordinator = ElementsSystem.instance.selectionCoordinator;
		SelectionCoordinator selectionCoordinator = m_selectionCoordinator;
		selectionCoordinator.onSelect = (SelectionCoordinator.SelectionEvent)Delegate.Combine(selectionCoordinator.onSelect, new SelectionCoordinator.SelectionEvent(OnSelect));
		SelectionCoordinator selectionCoordinator2 = m_selectionCoordinator;
		selectionCoordinator2.onDeselect = (SelectionCoordinator.SelectionEvent)Delegate.Combine(selectionCoordinator2.onDeselect, new SelectionCoordinator.SelectionEvent(OnDeselect));
		m_LastFocusMode = focusMode;
	}

	private void OnSelect(SelectableItem selectableItem)
	{
		focusMode = FocusMode.Selection;
	}

	private void OnDeselect(SelectableItem selectableItem)
	{
		focusMode = deselectFocusMode;
	}

	private void Update()
	{
		if (focusMode == FocusMode.Gaze)
		{
			ClearFocusPoints();
			Ray ray = Camera.main.ViewportPointToRay(gazeFocusViewportPosition);
			if (ElementsSystem.instance.planeManager.Raycast(ray, out var hit))
			{
				PlaneFocusPoint focusPoint = new PlaneFocusPoint(hit.plane, hit.point);
				AddFocusPoint(focusPoint);
			}
		}
		if (focusMode == FocusMode.Selection && m_LastFocusMode != FocusMode.Selection && focusPoints.Count > 1)
		{
			ClearFocusPoints();
		}
		m_LastFocusMode = focusMode;
	}

	public void AddFocusPoint(PlaneFocusPoint focusPoint)
	{
		if (focusPoint == null)
		{
			Debug.LogError("Can't add null focus point");
			return;
		}
		focusPoints.Add(focusPoint);
		TriggerFocusChanged();
	}

	public void RemoveFocusPoint(PlaneFocusPoint focusPoint)
	{
		if (focusPoint == null)
		{
			Debug.LogError("Can't remove null focus point");
		}
		else if (focusPoints.Contains(focusPoint))
		{
			focusPoints.Remove(focusPoint);
			TriggerFocusChanged();
		}
	}

	public void ClearFocusPoints()
	{
		focusPoints.Clear();
		TriggerFocusChanged();
	}

	public void TriggerFocusChanged()
	{
		if (onFocusChanged != null)
		{
			onFocusChanged(focusPoints);
		}
	}

	public void TriggerFocusStart()
	{
		ClearFocusPoints();
		if (onFocusStarted != null)
		{
			onFocusStarted(focusPoints);
		}
	}

	public void TriggerFocusEnd()
	{
		if (onFocusEnded != null)
		{
			onFocusEnded(focusPoints);
		}
	}
}
}
