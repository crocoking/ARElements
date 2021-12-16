using UnityEngine;

namespace ARElements{

public static class TransformationUtilities
{
	public struct Placement
	{
		public Vector3? hoveringPosition;

		public Vector3? placementPosition;

		public ITrackedPlane placementPlane;

		public float updatedGroundingPlaneHeight;
	}

	public const float downRayOffset = 0.01f;

	private const float k_MaxScreenTouchOffset = 0.4f;

	private const float k_HoverDistanceThreshold = 1f;

	public static Placement GetBestPlacementPosition(Vector3 currentObjectPosition, Vector2 screenPos, float groundingPlaneHeight, float hoverOffset)
	{
		Placement result = default(Placement);
		result.updatedGroundingPlaneHeight = groundingPlaneHeight;
		float num = Vector3.Angle(Camera.main.transform.forward, Vector3.down);
		if (num > 90f)
		{
			return result;
		}
		num = 90f - num;
		float num2 = Mathf.Clamp01(num / 90f);
		float inches = num2 * 0.4f;
		screenPos.y += GestureTouches.InchesToPixels(inches);
		float num3 = Mathf.Clamp01(num / 45f);
		hoverOffset *= num3;
		float magnitude = (Camera.main.transform.position - currentObjectPosition).magnitude;
		float num4 = Mathf.Clamp01(magnitude / 1f);
		hoverOffset *= num4;
		Ray ray = Camera.main.ScreenPointToRay(screenPos);
		if (new Plane(Vector3.up, new Vector3(0f, groundingPlaneHeight, 0f)).Raycast(ray, out var enter))
		{
			Vector3 point = ray.GetPoint(enter);
			result.hoveringPosition = point + Vector3.up * hoverOffset;
			if (ElementsSystem.instance.planeManager.Raycast(ray, out var hit) && hit.point.y > point.y)
			{
				result.placementPlane = hit.plane;
				result.placementPosition = hit.point;
				result.hoveringPosition = hit.point + Vector3.up * hoverOffset;
				result.updatedGroundingPlaneHeight = hit.point.y;
				return result;
			}
			Ray ray2 = new Ray(point + Vector3.up * 0.01f, Vector3.down);
			if (ElementsSystem.instance.planeManager.Raycast(ray2, out hit))
			{
				result.placementPlane = hit.plane;
				result.placementPosition = hit.point;
				return result;
			}
			return result;
		}
		return result;
	}
}
}
