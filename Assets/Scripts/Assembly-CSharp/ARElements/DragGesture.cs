using UnityEngine;

namespace ARElements
{

	public class DragGesture : BaseGesture
	{
		public int fingerId { get; private set; }

		public Vector2 startPosition { get; private set; }

		public Vector2 position { get; private set; }

		public Vector2 delta { get; private set; }

		public DragGesture(DragGestureRecognizer recognizer, Touch touch)
			: base(recognizer)
		{
			fingerId = touch.fingerId;
			startPosition = touch.position;
			position = startPosition;
			DebugLog("Created: " + fingerId);
		}

		protected override bool CanStart()
		{
			if (GestureTouches.IsFingerIdRetained(fingerId))
			{
				Cancel();
				return false;
			}
			if (GestureTouches.touches.Length > 1)
			{
				for (int i = 0; i < GestureTouches.touches.Length; i++)
				{
					Touch touch = GestureTouches.touches[i];
					if (touch.fingerId != fingerId && !GestureTouches.IsFingerIdRetained(touch.fingerId))
					{
						return false;
					}
				}
			}
			if (GestureTouches.TryFindTouch(fingerId, out var touch2))
			{
				Vector2 vector = touch2.position;
				float magnitude = (vector - startPosition).magnitude;
				if (GestureTouches.PixelsToInches(magnitude) >= (base.Recognizer as DragGestureRecognizer).slopInches)
				{
					return true;
				}
			}
			else
			{
				Cancel();
			}
			return false;
		}

		protected override void OnStart()
		{
			DebugLog("Started: " + fingerId);
			GestureTouches.LockFingerId(fingerId);
			if (GestureTouches.RaycastFromCamera(startPosition, out var result))
			{
				base.targetObject = result.gameObject;
			}
			GestureTouches.TryFindTouch(fingerId, out var touch);
			position = touch.position;
		}

		protected override bool UpdateGesture()
		{
			if (GestureTouches.TryFindTouch(fingerId, out var touch))
			{
				if (touch.phase == TouchPhase.Moved)
				{
					delta = touch.position - position;
					position = touch.position;
					DebugLog("Updated: " + fingerId + " : " + position.ToString("F4"));
					return true;
				}
				if (touch.phase == TouchPhase.Ended)
				{
					Complete();
				}
				else if (touch.phase == TouchPhase.Canceled)
				{
					Cancel();
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
			GestureTouches.ReleaseFingerId(fingerId);
		}

		private void DebugLog(string log)
		{
		}
	}
}
