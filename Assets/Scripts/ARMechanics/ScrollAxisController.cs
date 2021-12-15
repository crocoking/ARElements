using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace ARMechanics
{

	public class ScrollAxisController : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler, IEventSystemHandler
	{
		private enum Axis
		{
			Vertical,
			Horizontal,
			Unknown
		}

		public ScrollRect scrollRect;

		[SerializeField]
		[Tooltip("Seconds allocated to detect vertical or horizontal movement.")]
		private float m_Timeout = 0.25f;

		[SerializeField]
		[Range(0f, 1f)]
		[Tooltip("Applies a clamp on vertical scroll rect movement past the content rect. 0 will be a hard clamp. 1.0 will be no clamp")]
		private float m_VerticalBoundaryElasticity;

		[SerializeField]
		[Range(0f, 1f)]
		[Tooltip("Applies a clamp on horizontal scroll rect movement past the content rect. 0 will be a hard clamp. 1.0 will be no clamp")]
		private float m_HorizontalBoundaryElasticity = 0.4f;

		private float m_BeginDragTimestamp;

		private const float k_MinAngleForHorizontal = 0.471238941f;

		private readonly float k_MinCosineForHorizontal = Mathf.Cos(0.471238941f);

		private float k_MinDistance = 5f;

		private Axis m_Axis = Axis.Unknown;

		public float timeout
		{
			get
			{
				return m_Timeout;
			}
			set
			{
				m_Timeout = value;
			}
		}

		public float verticalBoundaryElasticity
		{
			get
			{
				return m_VerticalBoundaryElasticity;
			}
			set
			{
				m_VerticalBoundaryElasticity = value;
			}
		}

		public float horizontalBoundaryElasticity
		{
			get
			{
				return m_HorizontalBoundaryElasticity;
			}
			set
			{
				m_HorizontalBoundaryElasticity = value;
			}
		}

		private void onEnable()
		{
			m_Axis = Axis.Unknown;
		}

		private void EditEvent(PointerEventData eventData)
		{
			if (m_Axis != 0)
			{
				EditEventVertical(eventData);
			}
			if (m_Axis != Axis.Horizontal)
			{
				EditEventHorizontal(eventData);
			}
		}

		private static void EditEventHorizontal(PointerEventData eventData)
		{
			Vector2 delta = eventData.delta;
			delta.x = 0f;
			eventData.delta = delta;
			Vector2 scrollDelta = eventData.scrollDelta;
			Vector2 position = eventData.position;
			scrollDelta.x = 0f;
			position.x = eventData.pressPosition.x;
			eventData.scrollDelta = scrollDelta;
			eventData.position = position;
		}

		private static void EditEventVertical(PointerEventData eventData)
		{
			Vector2 delta = eventData.delta;
			Vector2 scrollDelta = eventData.scrollDelta;
			Vector2 position = eventData.position;
			delta.y = 0f;
			scrollDelta.y = 0f;
			position.y = eventData.pressPosition.y;
			eventData.delta = delta;
			eventData.scrollDelta = scrollDelta;
			eventData.position = position;
		}

		private Axis DetermineDirection(PointerEventData eventData)
		{
			Vector2 vector = eventData.position - eventData.pressPosition;
			Vector2 normalized = vector.normalized;
			if (Time.time - m_BeginDragTimestamp < m_Timeout && vector.magnitude < k_MinDistance)
			{
				return Axis.Unknown;
			}
			if (vector.magnitude < k_MinDistance)
			{
				return Axis.Horizontal;
			}
			if (Mathf.Abs(normalized.x) < k_MinCosineForHorizontal)
			{
				return Axis.Vertical;
			}
			return Axis.Horizontal;
		}

		void IBeginDragHandler.OnBeginDrag(PointerEventData eventData)
		{
			m_BeginDragTimestamp = Time.time;
			if (scrollRect.verticalNormalizedPosition > 0.01f)
			{
				m_Axis = Axis.Vertical;
			}
			else if (!RectTransformUtility.RectangleContainsScreenPoint(scrollRect.transform as RectTransform, eventData.pressPosition, eventData.pressEventCamera))
			{
				m_Axis = Axis.Vertical;
			}
			else
			{
				m_Axis = Axis.Unknown;
			}
			EditEvent(eventData);
			scrollRect.OnBeginDrag(eventData);
		}

		void IDragHandler.OnDrag(PointerEventData eventData)
		{
			if (m_Axis == Axis.Unknown)
			{
				m_Axis = DetermineDirection(eventData);
			}
			EditEvent(eventData);
			scrollRect.OnDrag(eventData);
		}

		void IEndDragHandler.OnEndDrag(PointerEventData eventData)
		{
			EditEvent(eventData);
			scrollRect.OnEndDrag(eventData);
			m_Axis = Axis.Unknown;
		}

		private void LateUpdate()
		{
			if (scrollRect.movementType != ScrollRect.MovementType.Clamped)
			{
				Vector2 normalizedPosition = scrollRect.normalizedPosition;
				if (normalizedPosition.x < 0f)
				{
					normalizedPosition.x = m_HorizontalBoundaryElasticity * normalizedPosition.x;
				}
				else if (normalizedPosition.x > 1f)
				{
					normalizedPosition.x = 1f + m_HorizontalBoundaryElasticity * (normalizedPosition.x - 1f);
				}
				if (normalizedPosition.y < 0f)
				{
					normalizedPosition.y = m_VerticalBoundaryElasticity * normalizedPosition.y;
				}
				else if (normalizedPosition.y > 1f)
				{
					normalizedPosition.y = 1f + m_VerticalBoundaryElasticity * (normalizedPosition.y - 1f);
				}
				scrollRect.normalizedPosition = normalizedPosition;
			}
		}
	}
}
