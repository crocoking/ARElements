using GoogleARCore;
using UnityEngine;

namespace ARElements{

public static class RaycastUtilities
{
	public static readonly TrackableHit k_NullHit = new TrackableHit(Pose.identity, 0f, TrackableHitFlags.None, null);

	public static bool GetRaycastResult(Vector3 screenPoint, Camera camera, out TrackableHit hit)
	{
		if (camera != null && camera.isActiveAndEnabled)
		{
			return GetRaycastResultInAR(screenPoint, out hit);
		}
		return GetRaycastResultInEditor(Camera.main.ScreenPointToRay(screenPoint), out hit);
	}

	public static bool GetCenterScreenRaycastResult(Camera camera, out TrackableHit hit)
	{
		bool flag = camera != null && camera.isActiveAndEnabled;
		if (Application.isEditor)
		{
			flag = false;
		}
		if (flag)
		{
			return GetCenterScreenRaycastResultInAR(camera, out hit);
		}
		return GetCenterScreenRaycastResultInEditor(Camera.main, out hit);
	}

	public static bool GetCenterScreenRaycastResultInEditor(Camera camera, out TrackableHit hit)
	{
		Ray cameraRay = new Ray(camera.transform.position, camera.transform.forward);
		return GetRaycastResultInEditor(cameraRay, out hit);
	}

	public static bool GetCenterScreenRaycastResultInAR(Camera camera, out TrackableHit hit)
	{
		return GetRaycastResultInAR(new Vector3(Screen.width / 2, Screen.height / 2, 0f), out hit);
	}

	public static bool GetRaycastResultInEditor(Ray cameraRay, out TrackableHit hit)
	{
		if (!Physics.Raycast(cameraRay, out var hitInfo))
		{
			hit = k_NullHit;
			return false;
		}
		hit = new TrackableHit(new Pose(hitInfo.point, Quaternion.LookRotation(hitInfo.normal)), hitInfo.distance, TrackableHitFlags.PlaneWithinBounds, null);
		return true;
	}

	public static bool GetRaycastResultInAR(Vector3 screenPoint, out TrackableHit hit)
	{
		hit = k_NullHit;
		TrackableHitFlags filter = TrackableHitFlags.PlaneWithinBounds;
		bool flag = Frame.Raycast(screenPoint.x, screenPoint.y, filter, out hit);
		if (!flag)
		{
			hit = k_NullHit;
		}
		return flag;
	}
}
}
