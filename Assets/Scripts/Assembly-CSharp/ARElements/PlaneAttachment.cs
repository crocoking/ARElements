using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class PlaneAttachment : MonoBehaviour
{
	private DetectedPlane plane;

	private Anchor anchor;

	public bool IsTracking => plane.TrackingState == TrackingState.Tracking && anchor.TrackingState == TrackingState.Tracking;

	public PlaneAttachment(DetectedPlane plane, Anchor anchor)
	{
		this.plane = plane;
		this.anchor = anchor;
	}

	public Pose GetPose()
	{
		return new Pose(new Vector3(anchor.transform.position.x, plane.CenterPose.position.y, anchor.transform.position.z), anchor.transform.rotation);
	}

	public Anchor GetAnchor()
	{
		return anchor;
	}

	public void Attach(DetectedPlane plane)
	{
		this.plane = plane;
	}
}
}
