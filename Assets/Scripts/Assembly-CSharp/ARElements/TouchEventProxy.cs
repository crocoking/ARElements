using System;
using UnityEngine;
using UnityEngine.Events;

namespace ARElements{

public class TouchEventProxy : MonoBehaviour
{
	[Serializable]
	public class TouchEvent : UnityEvent<Touch>
	{
	}

	public TouchEvent onTouchStart = new TouchEvent();

	public TouchEvent onTouchContinue = new TouchEvent();

	public TouchEvent onTouchStop = new TouchEvent();

	private Vector3 m_TouchStartPosition;

	private float m_TouchStartTime;

	private Touch m_currentTouch;

	private bool m_TouchInProgress;

	private void Update()
	{
		if ((bool)ElementsSystem.instance.annotationPresenter && ElementsSystem.instance.annotationPresenter.isPresentingCard)
		{
			return;
		}
		Touch[] touches = Input.touches;
		for (int i = 0; i < touches.Length; i++)
		{
			Touch touch = touches[i];
			if (touch.phase == TouchPhase.Began)
			{
				onTouchStart.Invoke(touch);
				m_TouchInProgress = true;
			}
			else if (touch.phase == TouchPhase.Ended)
			{
				onTouchStop.Invoke(touch);
				m_TouchInProgress = false;
			}
			else
			{
				onTouchContinue.Invoke(touch);
				m_TouchInProgress = true;
			}
			m_currentTouch = touch;
		}
		if (Application.isEditor)
		{
			if (Input.GetMouseButtonDown(0))
			{
				m_TouchStartPosition = Input.mousePosition;
				m_TouchStartTime = Time.time;
				m_currentTouch = FakeTouch();
				onTouchStart.Invoke(m_currentTouch);
				m_TouchInProgress = true;
			}
			else if (Input.GetMouseButtonUp(0))
			{
				m_currentTouch = FakeTouch();
				onTouchStop.Invoke(m_currentTouch);
				m_TouchInProgress = false;
			}
			else if (Input.GetMouseButton(0))
			{
				m_currentTouch = FakeTouch();
				onTouchContinue.Invoke(m_currentTouch);
				m_TouchInProgress = true;
			}
		}
		if (m_TouchInProgress && Input.touchCount == 0 && !Input.GetMouseButton(0))
		{
			onTouchStop.Invoke(m_currentTouch);
			m_TouchInProgress = false;
		}
	}

	private Touch FakeTouch()
	{
		Touch result = default(Touch);
		result.position = Input.mousePosition;
		result.fingerId = 0;
		result.deltaPosition = Input.mousePosition - m_TouchStartPosition;
		result.deltaTime = Time.time - m_TouchStartTime;
		result.radius = 10f;
		return result;
	}
}
}
