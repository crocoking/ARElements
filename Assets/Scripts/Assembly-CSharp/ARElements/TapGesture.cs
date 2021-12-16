using UnityEngine;

namespace ARElements{

public class TapGesture : BaseGesture
{
	private float m_ElapsedTime;

	public int fingerId { get; private set; }

	public Vector2 startPosition { get; private set; }

	public TapGesture(TapGestureRecognizer recognizer, Touch touch)
		: base(recognizer)
	{
		fingerId = touch.fingerId;
		startPosition = touch.position;
	}

	protected override bool CanStart()
	{
		return true;
	}

	protected override void OnStart()
	{
		DebugLog("Started: " + fingerId);
		if (GestureTouches.RaycastFromCamera(startPosition, out var result))
		{
			base.targetObject = result.gameObject;
		}
	}

	protected override bool UpdateGesture()
	{
		if (GestureTouches.TryFindTouch(fingerId, out var touch))
		{
			TapGestureRecognizer tapGestureRecognizer = base.Recognizer as TapGestureRecognizer;
			m_ElapsedTime += touch.deltaTime;
			if (m_ElapsedTime > tapGestureRecognizer.timeSeconds)
			{
				Cancel();
			}
			else if (touch.phase == TouchPhase.Moved)
			{
				float magnitude = (touch.position - startPosition).magnitude;
				float num = GestureTouches.PixelsToInches(magnitude);
				if (num > tapGestureRecognizer.slopInches)
				{
					Cancel();
				}
			}
			else if (touch.phase == TouchPhase.Ended)
			{
				Complete();
			}
		}
		else
		{
			Cancel();
		}
		return false;
	}

	protected override void OnCancel()
	{
		DebugLog("Cancelled: " + fingerId);
	}

	protected override void OnFinish()
	{
		DebugLog("Finished: " + fingerId);
	}

	private void DebugLog(string log)
	{
	}
}
}
