using UnityEngine;

namespace ARElements{

public class DragRotationController : BaseTransformationController<DragGesture>
{
	public enum DirectionMode
	{
		Constant,
		ScreenRelevant
	}

	[Tooltip("Rate that the item rotates in degrees per inch.")]
	public float rotationRateDegrees = 100f;

	public DirectionMode directionMode;

	[Tooltip("Ignore the gesture if it hit an object on one of the layers specified by this layerMask.")]
	public LayerMask blockedLayers;

	protected override bool CanStartTransformationForGesture(DragGesture gesture)
	{
		if (!base.CanStartTransformationForGesture(gesture))
		{
			return false;
		}
		bool result = true;
		if (gesture.targetObject != null)
		{
			if ((int)blockedLayers == ((int)blockedLayers | (1 << gesture.targetObject.layer)))
			{
				result = false;
			}
			SelectableItem componentInParent = gesture.targetObject.GetComponentInParent<SelectableItem>();
			if (componentInParent != null)
			{
				result = false;
			}
		}
		return result;
	}

	protected override void OnContinueTransformation(DragGesture gesture)
	{
		Vector2 vector = Camera.main.WorldToScreenPoint(base.transform.position);
		float num = -1f;
		if (directionMode == DirectionMode.ScreenRelevant)
		{
			Vector2 directionOnScreen = gesture.position - vector;
			if (ScreenOrientationToDeviceOrientation.Rotate(directionOnScreen).y > 0f)
			{
				num = 1f;
			}
		}
		Vector2 delta = gesture.delta;
		delta.y = 0f - delta.y;
		float yAngle = num * (ScreenOrientationToDeviceOrientation.Rotate(delta).x / Screen.dpi) * rotationRateDegrees;
		base.transform.Rotate(0f, yAngle, 0f);
	}
}
}
