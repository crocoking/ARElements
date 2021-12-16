using UnityEngine;

namespace ARElements{

public class TwistRotationController : BaseTransformationController<TwistGesture>
{
	[Tooltip("Rate that the item rotates in degrees per degree of twisting.")]
	public float rotationRateDegrees = 2.5f;

	protected override void OnContinueTransformation(TwistGesture gesture)
	{
		float yAngle = (0f - gesture.deltaRotation) * rotationRateDegrees;
		base.transform.Rotate(0f, yAngle, 0f);
	}
}
}
