using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(DynamicGridPlaneLayer))]
[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(PerimeterEvaluation))]
public class DynamicGridController : MonoBehaviour
{
	public delegate void DynamicGridEvent();

	public const float k_DefaultTransitionDuration = 0.25f;

	public ITrackedPlane plane;

	public float trackingSpeed;

	public float trackingSpeedFade = 0.95f;

	public float trackingSpeedScaler = 12f;

	public float maxPulseSize = 0.75f;

	private Vector3 m_FocalPoint = Vector3.zero;

	private Quaternion m_TrackingRotation;

	private PlaneFocusController m_PlaneFocusController;

	private SelectionCoordinator m_SelectionCoordinator;

	private float m_TransitionDuration;

	private float m_TransitionStartTime;

	private bool m_IsBursting;

	private bool m_IsTransitioning;

	private MeshRenderer m_MeshRenderer;

	private Material m_Material;

	private Material m_StartMaterial;

	private Material m_DestinationMaterial;

	public DynamicGridEvent onTransitionComplete;

	public DynamicGridEvent onSleep;

	private void Awake()
	{
		m_MeshRenderer = GetComponent<MeshRenderer>();
		m_Material = m_MeshRenderer.material;
		m_StartMaterial = new Material(m_Material);
		m_DestinationMaterial = new Material(m_Material);
	}

	private void Start()
	{
		plane = GetComponent<DynamicGridPlaneLayer>().plane;
		m_Material.renderQueue = Mathf.FloorToInt(2900f - plane.position.y);
	}

	private void Update()
	{
		if (m_IsTransitioning)
		{
			float num = (Time.time - m_TransitionStartTime) / m_TransitionDuration;
			m_DestinationMaterial.SetVector("_FocalPointPosition", m_Material.GetVector("_FocalPointPosition"));
			m_Material.Lerp(m_StartMaterial, m_DestinationMaterial, num);
			if (num >= 1f)
			{
				OnTransitionComplete();
			}
		}
		if ((double)trackingSpeed < 0.001)
		{
			Sleep();
		}
		else
		{
			trackingSpeed *= trackingSpeedFade;
		}
	}

	public void Show(float fadeDuration = 0.25f)
	{
		copyMaterialState(m_Material, m_StartMaterial);
		copyMaterialState(m_Material, m_DestinationMaterial);
		m_DestinationMaterial.SetFloat("_Visibility", 1f);
		m_IsTransitioning = true;
		TweenToState(m_DestinationMaterial, fadeDuration);
	}

	public void Hide(float fadeDuration = 0.25f)
	{
		copyMaterialState(m_Material, m_StartMaterial);
		copyMaterialState(m_Material, m_DestinationMaterial);
		m_DestinationMaterial.SetFloat("_Visibility", 0f);
		m_IsTransitioning = true;
		TweenToState(m_DestinationMaterial, fadeDuration);
	}

	public void ShowFocalPoint(float fadeDuration = 0.25f)
	{
		copyMaterialState(m_Material, m_StartMaterial);
		m_StartMaterial.SetFloat("_FocalPointRadius", 0.1f);
		copyMaterialState(m_Material, m_DestinationMaterial);
		m_DestinationMaterial.SetFloat("_Visibility", 1f);
		m_DestinationMaterial.SetFloat("_FocalPointRadius", 0f);
		m_DestinationMaterial.SetFloat("_ScaleFocalPointMix", 1f);
		m_DestinationMaterial.SetFloat("_ColorMixFocalPoint", 1f);
		m_DestinationMaterial.SetFloat("_CellFillMixFocalPoint", 1f);
		m_DestinationMaterial.SetFloat("_CellCornerOccludeMixFocalPoint", 1f);
		m_DestinationMaterial.SetFloat("_CellEdgeOccludeMixFocalPoint", 1f);
		m_IsTransitioning = true;
		TweenToState(m_DestinationMaterial, fadeDuration);
	}

	public void HideFocalPoint(float fadeDuration = 0.25f)
	{
		copyMaterialState(m_Material, m_StartMaterial);
		copyMaterialState(m_Material, m_DestinationMaterial);
		m_DestinationMaterial.SetFloat("_FocalPointRadius", 0f);
		m_DestinationMaterial.SetFloat("_ScaleFocalPointMix", 0f);
		m_DestinationMaterial.SetFloat("_ColorMixFocalPoint", 0f);
		m_DestinationMaterial.SetFloat("_CellFillMixFocalPoint", 0f);
		m_DestinationMaterial.SetFloat("_CellCornerOccludeMixFocalPoint", 0f);
		m_DestinationMaterial.SetFloat("_CellEdgeOccludeMixFocalPoint", 0f);
		m_IsTransitioning = true;
		TweenToState(m_DestinationMaterial, fadeDuration);
	}

	public void Pulse(float maxRadius, float fadeDuration = 0.25f)
	{
		maxRadius = Mathf.Min(maxPulseSize, maxRadius);
		copyMaterialState(m_Material, m_StartMaterial);
		copyMaterialState(m_Material, m_DestinationMaterial);
		m_DestinationMaterial.SetFloat("_FocalPointRadius", maxRadius);
		m_IsTransitioning = true;
		onTransitionComplete = (DynamicGridEvent)Delegate.Combine(onTransitionComplete, new DynamicGridEvent(OnPulseComplete));
		TweenToState(m_DestinationMaterial, fadeDuration);
	}

	public void SetFocalPoint(Vector3 point)
	{
		trackingSpeed += Vector3.Distance(point, m_FocalPoint) * trackingSpeedScaler;
		m_Material.SetVector("_FocalPointPosition", point);
		m_FocalPoint = point;
	}

	public void TweenToState(Material DestinationMaterial, float duration = 0.25f)
	{
		m_TransitionStartTime = Time.time;
		m_DestinationMaterial = DestinationMaterial;
		m_TransitionDuration = duration;
		m_IsTransitioning = true;
	}

	private void OnTransitionComplete()
	{
		m_IsTransitioning = false;
		if (onTransitionComplete != null)
		{
			onTransitionComplete();
		}
		onTransitionComplete = null;
	}

	private void OnPulseComplete()
	{
		onTransitionComplete = (DynamicGridEvent)Delegate.Remove(onTransitionComplete, new DynamicGridEvent(OnPulseComplete));
		ShowFocalPoint(0f);
	}

	private void Sleep()
	{
		trackingSpeed = 0f;
		if (onSleep != null)
		{
			onSleep();
		}
	}

	private bool isFocusedOnPlane(List<PlaneFocusPoint> focusPoints, ITrackedPlane plane)
	{
		if (focusPoints.Count > 0 && focusPoints[0].plane == plane)
		{
			return true;
		}
		return false;
	}

	private void copyMaterialState(Material src, Material dest)
	{
		dest.CopyPropertiesFromMaterial(src);
	}
}
}
