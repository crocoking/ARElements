using UnityEngine;
using UnityEngine.Events;

namespace ARElements{

public class TranslationController : BaseTransformationController<DragGesture>
{
	public enum State
	{
		Idle,
		Transforming,
		HoverEnding
	}

	[Tooltip("Controls how quickly the item moves from it's current position to the new position.")]
	[Range(1f, 50f)]
	public float positionSpeed = 12f;

	[Header("Hover Settings")]
	[Range(0f, 1f)]
	[Tooltip("Controls how much the item hovers while being translated (meters).")]
	public float hoverOffset = 0.15f;

	[Tooltip("Easing function to use when item moves from hovering position to placement position.")]
	public EasingFunction placementEaseFunction = EasingFunction.EaseOutSmallBounce;

	[Range(1f, 50f)]
	[Header("Wobble Settings")]
	[Tooltip("Controls how quickly the item moves from it's current wobble rotation to the new wobble rotation.")]
	public float wobbleSpeed = 5f;

	[Tooltip("Controls how much translation velocity makes the item wobble.")]
	[Range(0f, 20f)]
	public float wobbleSensitivity = 3f;

	[Range(0f, 90f)]
	[Tooltip("The maximum amount that the item can rotate due to the wobble animation.")]
	public float maxWobbleDegrees = 10f;

	public bool placedOnNewPlane = true;

	public ITrackedPlane m_StartPlane;

	public IntersectionAvoider intersectionAvoider;

	public UnityEvent onStartTransformation = new UnityEvent();

	public UnityEvent onEndTransformation = new UnityEvent();

	private float m_GroundingPlaneHeight;

	private Vector3 m_DesiredLocalPosition;

	private TransformationUtilities.Placement? m_LastPlacement;

	private TransformationUtilities.Placement? m_LastValidPlacement;

	private EasedFloat m_HoverEndingEase = new EasedFloat(0f, EasingFunction.EaseOutSmallBounce);

	private const float k_HoverEndingEaseSecondsMin = 0.75f;

	private const float k_HoverEndingEaseSecondsMax = 1.1f;

	private bool m_IsOverlapping;

	private PlaneFocusController m_PlaneFocusController;

	private PlaneFocusPoint m_ActivePlaneFocus;

	private State currentState { get; set; }

	public override bool isTransforming => currentState == State.Transforming;

	public override bool isTransformationFinishing => currentState == State.HoverEnding;

	public override bool isTransformationValid
	{
		get
		{
			if (!isTransforming || !m_LastPlacement.HasValue)
			{
				return true;
			}
			return !m_IsOverlapping && m_LastPlacement.Value.placementPosition.HasValue;
		}
	}

	public bool hasValidPosition => m_LastValidPlacement.HasValue && m_LastValidPlacement.Value.placementPosition.HasValue;

	public Vector3 FootprintPosition
	{
		get
		{
			Vector3 position = base.transform.position;
			if (hasValidPosition && currentState != 0)
			{
				position.y = m_LastValidPlacement.Value.placementPosition.Value.y;
			}
			return position;
		}
	}

	public void StartTranslation(float groundingPlaneHeight)
	{
		m_GroundingPlaneHeight = groundingPlaneHeight;
		m_DesiredLocalPosition = base.transform.localPosition;
		currentState = State.Transforming;
		m_IsOverlapping = false;
		if (m_LastValidPlacement.HasValue && m_LastValidPlacement.Value.placementPlane != null)
		{
			m_StartPlane = m_LastValidPlacement.Value.placementPlane;
		}
		if (ElementsSystem.instance != null)
		{
			m_PlaneFocusController = ElementsSystem.instance.planeFocusController;
		}
		m_PlaneFocusController.TriggerFocusStart();
		if (onStartTransformation != null)
		{
			onStartTransformation.Invoke();
		}
	}

	public void ContinueTranslation(Vector2 screenPosition)
	{
		TransformationUtilities.Placement bestPlacementPosition = TransformationUtilities.GetBestPlacementPosition(base.transform.position, screenPosition, m_GroundingPlaneHeight, hoverOffset);
		if (bestPlacementPosition.hoveringPosition.HasValue)
		{
			m_DesiredLocalPosition = bestPlacementPosition.hoveringPosition.Value;
			if (base.transform.parent != null)
			{
				m_DesiredLocalPosition = base.transform.parent.InverseTransformPoint(m_DesiredLocalPosition);
			}
		}
		if (bestPlacementPosition.placementPosition.HasValue)
		{
			if ((bool)intersectionAvoider && intersectionAvoider.TestOverlap(bestPlacementPosition.placementPosition.Value))
			{
				bestPlacementPosition.placementPosition = null;
				m_IsOverlapping = true;
			}
			else
			{
				m_LastValidPlacement = bestPlacementPosition;
				m_IsOverlapping = false;
			}
		}
		m_GroundingPlaneHeight = bestPlacementPosition.updatedGroundingPlaneHeight;
		m_LastPlacement = bestPlacementPosition;
		if (!(m_PlaneFocusController != null))
		{
			return;
		}
		TransformationUtilities.Placement? lastPlacement = m_LastPlacement;
		if (lastPlacement.HasValue)
		{
			if (m_ActivePlaneFocus != null)
			{
				m_PlaneFocusController.RemoveFocusPoint(m_ActivePlaneFocus);
			}
			ITrackedPlane placementPlane = bestPlacementPosition.placementPlane;
			m_ActivePlaneFocus = new PlaneFocusPoint(placementPlane, base.transform.position);
			m_PlaneFocusController.AddFocusPoint(m_ActivePlaneFocus);
			m_PlaneFocusController.focusMode = FocusMode.Selection;
		}
	}

	public void ContinueTranslationImmediate(Vector2 screenPosition)
	{
		ContinueTranslation(screenPosition);
		base.transform.localPosition = m_DesiredLocalPosition;
	}

	public void EndTranslation()
	{
		if (hasValidPosition)
		{
			TransformationCoordinator coordinator = GetCoordinator<TransformationCoordinator>();
			Transform anchorForPlane = coordinator.GetAnchorForPlane(m_LastValidPlacement.Value.placementPlane);
			if (anchorForPlane != null)
			{
				base.transform.SetParent(anchorForPlane, worldPositionStays: true);
			}
			else if (Application.isEditor && base.transform.parent.name != "PlaneAnchor")
			{
				Transform transform = new GameObject("Anchor").transform;
				transform.SetParent(coordinator.transform);
				Transform transform2 = new GameObject("PlaneAnchor").transform;
				transform2.SetParent(transform);
				base.transform.SetParent(transform2);
			}
			m_DesiredLocalPosition = m_LastValidPlacement.Value.placementPosition.Value;
			if (base.transform.parent != null)
			{
				m_DesiredLocalPosition = base.transform.parent.InverseTransformPoint(m_DesiredLocalPosition);
			}
			m_HoverEndingEase.JumpTo(base.transform.localPosition.y);
			m_HoverEndingEase.easingFunction = placementEaseFunction;
			float num = 0.350000024f;
			float num2 = Mathf.Clamp01(m_LastValidPlacement.Value.hoveringPosition.Value.y - m_DesiredLocalPosition.y - hoverOffset);
			float duration = 0.75f + num2 * num;
			m_HoverEndingEase.FadeTo(m_DesiredLocalPosition.y, duration, Time.time);
			placedOnNewPlane = m_StartPlane != m_LastValidPlacement.Value.placementPlane;
			currentState = State.HoverEnding;
		}
		else
		{
			currentState = State.Idle;
		}
		if (m_ActivePlaneFocus != null)
		{
			m_PlaneFocusController.RemoveFocusPoint(m_ActivePlaneFocus);
			m_ActivePlaneFocus = null;
		}
		m_IsOverlapping = false;
		m_StartPlane = null;
		m_LastPlacement = null;
		m_PlaneFocusController.TriggerFocusEnd();
		if (onEndTransformation != null)
		{
			onEndTransformation.Invoke();
		}
	}

	private void Start()
	{
		m_DesiredLocalPosition = base.transform.localPosition;
		m_PlaneFocusController = ElementsSystem.instance.planeFocusController;
	}

	protected virtual void Update()
	{
		if (currentState == State.Idle)
		{
			return;
		}
		Vector3 position = base.transform.position;
		Vector3 localPosition = base.transform.localPosition;
		Vector3 localPosition2 = Vector3.Lerp(localPosition, m_DesiredLocalPosition, Time.deltaTime * positionSpeed);
		base.transform.localPosition = localPosition2;
		Vector3 position2 = base.transform.position;
		if (currentState == State.Transforming && m_GroundingPlaneHeight > position2.y)
		{
			position2.y = m_GroundingPlaneHeight;
			base.transform.position = position2;
		}
		ApplyWobbleRotation(position2, position);
		if (currentState == State.HoverEnding && m_HoverEndingEase != null)
		{
			float y = m_HoverEndingEase.ValueAtTime(Time.time);
			Vector3 localPosition3 = base.transform.localPosition;
			localPosition3.y = y;
			base.transform.localPosition = localPosition3;
			if (m_HoverEndingEase.IsCompleted(Time.time))
			{
				currentState = State.Idle;
			}
		}
	}

	protected override bool CanStartTransformationForGesture(DragGesture gesture)
	{
		if (gesture.targetObject == null)
		{
			return false;
		}
		SelectableItem componentInParent = gesture.targetObject.GetComponentInParent<SelectableItem>();
		if (componentInParent != base.Item)
		{
			return false;
		}
		if (!base.Item.isSelected && !base.Item.TrySelect())
		{
			return false;
		}
		return true;
	}

	protected override void OnStartTransformation(DragGesture gesture)
	{
		StartTranslation(GetInitialGroundingPlaneHeight());
	}

	protected override void OnContinueTransformation(DragGesture gesture)
	{
		ContinueTranslation(gesture.position);
	}

	protected override void OnEndTransformation(DragGesture gesture)
	{
		EndTranslation();
	}

	protected void ApplyWobbleRotation(Vector3 newPosition, Vector3 oldPosition)
	{
		Quaternion b = Quaternion.Euler(0f, base.transform.localEulerAngles.y, 0f);
		if (currentState == State.Transforming)
		{
			Vector3 vector = Camera.main.WorldToScreenPoint(newPosition);
			Vector3 vector2 = Camera.main.WorldToScreenPoint(oldPosition);
			float num = GestureTouches.PixelsToInches((vector - vector2).magnitude);
			float num2 = num / Time.deltaTime;
			Vector3 direction = Vector3.Cross((newPosition - oldPosition).normalized, Vector3.up);
			direction = base.transform.InverseTransformDirection(direction);
			float a = num2 * wobbleSensitivity;
			a = Mathf.Min(a, maxWobbleDegrees);
			Vector3 eulerAngles = Quaternion.AngleAxis(a, direction).eulerAngles;
			b = Quaternion.Euler(eulerAngles.x, base.transform.localEulerAngles.y, eulerAngles.z);
		}
		base.transform.localRotation = Quaternion.Slerp(base.transform.localRotation, b, Time.deltaTime * wobbleSpeed);
	}

	protected float GetInitialGroundingPlaneHeight()
	{
		if (hasValidPosition)
		{
			return m_LastValidPlacement.Value.placementPosition.Value.y;
		}
		return base.transform.position.y;
	}
}
}
