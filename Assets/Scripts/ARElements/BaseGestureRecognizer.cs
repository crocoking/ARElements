using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public abstract class BaseGestureRecognizer : MonoBehaviour
{
	[Range(0f, 10f)]
	[Tooltip("Used to filter out accidental touches on the edge of the screen.")]
	public float edgeThresholdInches = 0.1f;

	protected List<BaseGesture> m_Gestures = new List<BaseGesture>();

	public event Action<BaseGesture> onGestureStarted;

	private void Update()
	{
		TryCreateGestures();
		for (int i = 0; i < m_Gestures.Count; i++)
		{
			BaseGesture baseGesture = m_Gestures[i];
			baseGesture.Update();
			if (baseGesture.justStarted && this.onGestureStarted != null)
			{
				this.onGestureStarted(baseGesture);
			}
		}
	}

	private void LateUpdate()
	{
		for (int num = m_Gestures.Count - 1; num >= 0; num--)
		{
			if (m_Gestures[num].hasFinished)
			{
				m_Gestures.RemoveAt(num);
			}
		}
	}

	protected abstract void TryCreateGestures();

	protected void TryCreateOneFingerGestureOnTouchBegan<T>(Func<Touch, T> createGestureFunction) where T : BaseGesture
	{
		for (int i = 0; i < GestureTouches.touches.Length; i++)
		{
			Touch touch = GestureTouches.touches[i];
			if (touch.phase == TouchPhase.Began && !GestureTouches.IsFingerIdRetained(touch.fingerId) && !GestureTouches.IsTouchOffScreenEdge(touch, edgeThresholdInches))
			{
				m_Gestures.Add(createGestureFunction(touch));
			}
		}
	}

	protected void TryCreateTwoFingerGestureOnTouchBegan<T>(Func<Touch, Touch, T> createGestureFunction) where T : BaseGesture
	{
		if (GestureTouches.touches.Length >= 2)
		{
			for (int i = 0; i < GestureTouches.touches.Length; i++)
			{
				TryCreateGestureTwoFingerGestureOnTouchBeganForTouchIndex(i, createGestureFunction);
			}
		}
	}

	private void TryCreateGestureTwoFingerGestureOnTouchBeganForTouchIndex<T>(int touchIndex, Func<Touch, Touch, T> createGestureFunction) where T : BaseGesture
	{
		if (GestureTouches.touches[touchIndex].phase != 0)
		{
			return;
		}
		Touch touch = GestureTouches.touches[touchIndex];
		if (GestureTouches.IsFingerIdRetained(touch.fingerId) || GestureTouches.IsTouchOffScreenEdge(touch, edgeThresholdInches))
		{
			return;
		}
		for (int i = 0; i < GestureTouches.touches.Length; i++)
		{
			if (i != touchIndex && (i >= touchIndex || GestureTouches.touches[i].phase != 0))
			{
				Touch touch2 = GestureTouches.touches[i];
				if (!GestureTouches.IsFingerIdRetained(touch2.fingerId) && !GestureTouches.IsTouchOffScreenEdge(touch2, edgeThresholdInches))
				{
					m_Gestures.Add(createGestureFunction(touch, touch2));
				}
			}
		}
	}
}
}
