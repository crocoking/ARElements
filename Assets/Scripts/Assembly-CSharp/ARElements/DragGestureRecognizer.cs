using UnityEngine;

namespace ARElements{

public class DragGestureRecognizer : BaseGestureRecognizer
{
	[Range(0f, 10f)]
	[Tooltip("Amount that the user's touch must move before a drag is recognized.")]
	public float slopInches = 0.1f;

	protected override void TryCreateGestures()
	{
		TryCreateOneFingerGestureOnTouchBegan(CreateGesture);
	}

	private DragGesture CreateGesture(Touch touch)
	{
		return new DragGesture(this, touch);
	}
}
}
