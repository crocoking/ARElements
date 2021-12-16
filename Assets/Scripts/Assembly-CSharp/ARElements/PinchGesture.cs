using System;
using UnityEngine;

namespace ARElements{

public class PinchGesture : BaseGesture
{
	public int fingerId1 { get; private set; }

	public int fingerId2 { get; private set; }

	public Vector2 startPosition1 { get; private set; }

	public Vector2 startPosition2 { get; private set; }

	public float gap { get; private set; }

	public float gapDelta { get; private set; }

	public PinchGesture(PinchGestureRecognizer recognizer, Touch touch1, Touch touch2)
		: base(recognizer)
	{
		fingerId1 = touch1.fingerId;
		fingerId2 = touch2.fingerId;
		startPosition1 = touch1.position;
		startPosition2 = touch2.position;
		DebugLog("Created");
	}

	protected override bool CanStart()
	{
		if (GestureTouches.IsFingerIdRetained(fingerId1) || GestureTouches.IsFingerIdRetained(fingerId2))
		{
			Cancel();
			return false;
		}
		Touch touch;
		bool flag = GestureTouches.TryFindTouch(fingerId1, out touch);
		if (!GestureTouches.TryFindTouch(fingerId2, out var touch2) || !flag)
		{
			Cancel();
			return false;
		}
		if (touch.deltaPosition == Vector2.zero && touch2.deltaPosition == Vector2.zero)
		{
			return false;
		}
		PinchGestureRecognizer pinchGestureRecognizer = base.Recognizer as PinchGestureRecognizer;
		Vector3 vector = (startPosition1 - startPosition2).normalized;
		float f = Vector3.Dot(touch.deltaPosition.normalized, -vector);
		float f2 = Vector3.Dot(touch2.deltaPosition.normalized, vector);
		float num = Mathf.Cos(pinchGestureRecognizer.slopMotionDirectionDegrees * ((float)Math.PI / 180f));
		if (touch.deltaPosition != Vector2.zero && Mathf.Abs(f) < num)
		{
			return false;
		}
		if (touch2.deltaPosition != Vector2.zero && Mathf.Abs(f2) < num)
		{
			return false;
		}
		float magnitude = (startPosition1 - startPosition2).magnitude;
		gap = (touch.position - touch2.position).magnitude;
		float num2 = GestureTouches.PixelsToInches(Mathf.Abs(gap - magnitude));
		if (num2 < pinchGestureRecognizer.slopInches)
		{
			return false;
		}
		return true;
	}

	protected override void OnStart()
	{
		DebugLog("Started");
		GestureTouches.LockFingerId(fingerId1);
		GestureTouches.LockFingerId(fingerId2);
	}

	protected override bool UpdateGesture()
	{
		Touch touch;
		bool flag = GestureTouches.TryFindTouch(fingerId1, out touch);
		if (!GestureTouches.TryFindTouch(fingerId2, out var touch2) || !flag)
		{
			Cancel();
			return false;
		}
		if (touch.phase == TouchPhase.Canceled || touch2.phase == TouchPhase.Canceled)
		{
			Cancel();
			return false;
		}
		if (touch.phase == TouchPhase.Ended || touch2.phase == TouchPhase.Ended)
		{
			Complete();
			return false;
		}
		if (touch.phase == TouchPhase.Moved || touch2.phase == TouchPhase.Moved)
		{
			float magnitude = (touch.position - touch2.position).magnitude;
			gapDelta = magnitude - gap;
			gap = magnitude;
			DebugLog("Update: " + gapDelta);
			return true;
		}
		return false;
	}

	protected override void OnCancel()
	{
		DebugLog("Cancelled");
	}

	protected override void OnFinish()
	{
		DebugLog("Finished");
		GestureTouches.ReleaseFingerId(fingerId1);
		GestureTouches.ReleaseFingerId(fingerId2);
	}

	private void DebugLog(string log)
	{
	}
}
}
