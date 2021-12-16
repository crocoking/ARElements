using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace ARElements{

[RequireComponent(typeof(TouchEventProxy))]
public class ScrollDragController : MonoBehaviour
{
	public enum MovementType
	{
		DragScrollRect,
		DragMenuItem,
		None
	}

	[Serializable]
	public class ScrollDragEvent : UnityEvent<Touch>
	{
	}

	public ScrollRect scrollRect;

	public ScrollDragEvent startForcedDrag = new ScrollDragEvent();

	public ScrollDragEvent continueForcedDrag = new ScrollDragEvent();

	public ScrollDragEvent endForcedDrag = new ScrollDragEvent();

	public float minAngleToDragItem = 30f;

	public float longPressDuration = 0.3f;

	private bool m_TouchLongPressPossible = true;

	private Vector2 m_TouchStartPos;

	private float m_TouchStartTime;

	private int m_TouchFingerId = -1;

	private const float k_PixelDragThreshold = 7f;

	private const float k_ScrollSpeedThreshold = 40f;

	public MovementType movementType { get; set; }

	private void Start()
	{
		TouchEventProxy component = GetComponent<TouchEventProxy>();
		component.onTouchStart.AddListener(StartTouch);
		component.onTouchStop.AddListener(StopTouch);
		component.onTouchContinue.AddListener(ContinueTouch);
	}

	private void Update()
	{
	}

	private void OnEnable()
	{
		StopTouch();
	}

	private void StartTouch(Touch touch)
	{
		m_TouchStartTime = Time.time;
		m_TouchFingerId = touch.fingerId;
		m_TouchLongPressPossible = true;
		m_TouchStartPos = touch.position - touch.deltaPosition;
		startForcedDrag.Invoke(touch);
		if (touch.deltaPosition != Vector2.zero)
		{
			ContinueTouch(touch);
		}
	}

	private void StopTouch(Touch touch)
	{
		if (touch.fingerId == m_TouchFingerId)
		{
			if (movementType == MovementType.DragMenuItem)
			{
				endForcedDrag.Invoke(touch);
			}
			StopTouch();
		}
	}

	public void StopTouch()
	{
		m_TouchFingerId = -1;
		movementType = MovementType.None;
	}

	private void ContinueTouch(Touch touch)
	{
		if (touch.fingerId != m_TouchFingerId)
		{
			return;
		}
		Vector2 vector = touch.position - m_TouchStartPos;
		Vector2 normalized = vector.normalized;
		if (scrollRect.velocity.magnitude > 40f)
		{
			movementType = MovementType.DragScrollRect;
		}
		else if (m_TouchLongPressPossible && vector.magnitude < 7f && Time.time - m_TouchStartTime > longPressDuration)
		{
			movementType = MovementType.DragMenuItem;
		}
		else if (vector.magnitude < 7f)
		{
			movementType = MovementType.None;
		}
		else
		{
			if (movementType != MovementType.None)
			{
				m_TouchLongPressPossible = false;
				return;
			}
			if (Mathf.Abs(normalized.x) < Mathf.Cos((float)Math.PI / 180f * minAngleToDragItem))
			{
				movementType = MovementType.DragMenuItem;
				m_TouchLongPressPossible = false;
			}
			else
			{
				movementType = MovementType.DragScrollRect;
				m_TouchLongPressPossible = false;
			}
		}
		if (movementType == MovementType.DragMenuItem)
		{
			continueForcedDrag.Invoke(touch);
		}
	}
}
}
