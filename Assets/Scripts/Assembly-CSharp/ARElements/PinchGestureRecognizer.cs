using UnityEngine;

namespace ARElements{

public class PinchGestureRecognizer : BaseGestureRecognizer
{
	[Range(0f, 10f)]
	[Tooltip("Amount that the gap between the two finger's must change before a pinch is recognized.")]
	public float slopInches = 0.05f;

	[Range(0f, 180f)]
	[Tooltip("Direction variance allowed in a touch's motion for a pinch to be recognized.")]
	public float slopMotionDirectionDegrees = 30f;

	protected override void TryCreateGestures()
	{
		TryCreateTwoFingerGestureOnTouchBegan(CreateGesture);
	}

	private PinchGesture CreateGesture(Touch touch1, Touch touch2)
	{
		return new PinchGesture(this, touch1, touch2);
	}
}
}
