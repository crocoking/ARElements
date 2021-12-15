using UnityEngine;

namespace ARElements{

public class TapGestureRecognizer : BaseGestureRecognizer
{
	[Range(0f, 10f)]
	[Tooltip("Amount that the user's touch can move before the gesture is no longer considered a tap.")]
	public float slopInches = 0.1f;

	[Range(0f, 10f)]
	[Tooltip("Amount time the user can be touching before the gesture is no longer considered a tap.")]
	public float timeSeconds = 0.3f;

	protected override void TryCreateGestures()
	{
		TryCreateOneFingerGestureOnTouchBegan(CreateGesture);
	}

	private TapGesture CreateGesture(Touch touch)
	{
		return new TapGesture(this, touch);
	}
}
}
