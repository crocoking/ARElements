using UnityEngine;

namespace GoogleARCore.BestPractices{

public class PlaneAnchor : MonoBehaviour
{
	public DetectedPlane trackedPlane { get; private set; }

	private void Update()
	{
		if (trackedPlane != null)
		{
			base.transform.localPosition = Vector3.zero;
			base.transform.localRotation = Quaternion.identity;
			Plane plane = new Plane(trackedPlane.CenterPose.rotation * Vector3.up, trackedPlane.CenterPose.position);
			Vector3 position = plane.ClosestPointOnPlane(base.transform.position);
			base.transform.position = position;
			Vector3 forward = Vector3.ProjectOnPlane(base.transform.forward, plane.normal);
			base.transform.rotation = Quaternion.LookRotation(forward, plane.normal);
		}
	}

	public void SetPlane(DetectedPlane plane)
	{
		trackedPlane = plane;
	}
}
}
