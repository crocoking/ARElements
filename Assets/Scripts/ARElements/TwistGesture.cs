using UnityEngine;

namespace ARElements{

public class TwistGesture : BaseGesture
{
	private Vector2 m_PreviousPosition1;

	private Vector2 m_PreviousPosition2;

	public int fingerId1 { get; private set; }

	public int fingerId2 { get; private set; }

	public Vector2 startPosition1 { get; private set; }

	public Vector2 startPosition2 { get; private set; }

	public float deltaRotation { get; private set; }

	public TwistGesture(TwistGestureRecognizer recognizer, Touch touch1, Touch touch2)
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
		if (touch.deltaPosition == Vector2.zero || touch2.deltaPosition == Vector2.zero)
		{
			return false;
		}
		TwistGestureRecognizer twistGestureRecognizer = base.Recognizer as TwistGestureRecognizer;
		float f = CalculateDeltaRotation(touch.position, touch2.position, startPosition1, startPosition2);
		if (Mathf.Abs(f) < twistGestureRecognizer.slopRotation)
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
		GestureTouches.TryFindTouch(fingerId1, out var touch);
		GestureTouches.TryFindTouch(fingerId2, out var touch2);
		m_PreviousPosition1 = touch.position;
		m_PreviousPosition2 = touch2.position;
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
			float num2 = (deltaRotation = CalculateDeltaRotation(touch.position, touch2.position, m_PreviousPosition1, m_PreviousPosition2));
			m_PreviousPosition1 = touch.position;
			m_PreviousPosition2 = touch2.position;
			DebugLog("Update: " + deltaRotation);
			return true;
		}
		m_PreviousPosition1 = touch.position;
		m_PreviousPosition2 = touch2.position;
		deltaRotation = 0f;
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

	private static float CalculateDeltaRotation(Vector2 currentPosition1, Vector2 currentPosition2, Vector2 previousPosition1, Vector2 previousPosition2)
	{
		Vector2 normalized = (currentPosition1 - currentPosition2).normalized;
		Vector2 normalized2 = (previousPosition1 - previousPosition2).normalized;
		float num = Mathf.Sign(normalized2.x * normalized.y - normalized2.y * normalized.x);
		return Vector2.Angle(normalized, normalized2) * num;
	}

	private void DebugLog(string log)
	{
	}
}
}
