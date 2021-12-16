using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class TransformationCoordinator : MonoBehaviour
{
	private Dictionary<DetectedPlane, Transform> m_PlaneAnchors = new Dictionary<DetectedPlane, Transform>();

	public Transform GetAnchorForPlane(ITrackedPlane plane)
	{
		if (plane != null && !Application.isEditor && plane.GetType() == typeof(AndroidPlane))
		{
			return GetAndroidAnchor(plane as AndroidPlane);
		}
		return null;
	}

	public Transform GetAndroidAnchor(AndroidPlane plane)
	{
		DetectedPlane trackedPlane = plane.trackedPlane;
		if (m_PlaneAnchors.TryGetValue(trackedPlane, out var value))
		{
			return value;
		}
		Anchor anchor = Session.CreateAnchor(trackedPlane.CenterPose);
		anchor.transform.SetParent(base.transform, worldPositionStays: true);
		GameObject gameObject = new GameObject("PlaneAnchor");
		value = gameObject.transform;
		value.SetParent(anchor.transform, worldPositionStays: false);
		PlaneAttachment planeAttachment = gameObject.AddComponent<PlaneAttachment>();
		planeAttachment.Attach(trackedPlane);
		m_PlaneAnchors[trackedPlane] = value;
		return value;
	}
}
}
