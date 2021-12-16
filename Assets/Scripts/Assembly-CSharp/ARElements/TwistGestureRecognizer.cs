using UnityEngine;

namespace ARElements
{

	public class TwistGestureRecognizer : BaseGestureRecognizer
	{
		[Tooltip("Amount (degrees) that the rotation of the two finger's must change before a twist is recognized.")]
		public float slopRotation = 10f;

		protected override void TryCreateGestures()
		{
			TryCreateTwoFingerGestureOnTouchBegan(CreateGesture);
		}

		private TwistGesture CreateGesture(Touch touch1, Touch touch2)
		{
			return new TwistGesture(this, touch1, touch2);
		}
	}
}
