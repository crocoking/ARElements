using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class TrackingPlaneDiscoveryRule : PlaneDiscoveryRule
{
	public bool requireAtleastOnePlane = true;

	private List<DetectedPlane> planesCache = new List<DetectedPlane>();

	public override bool GetPlaneDiscoveryState()
	{
		if (Application.isEditor)
		{
			return false;
		}
		if (Session.Status != SessionStatus.Tracking)
		{
			return true;
		}
		if (requireAtleastOnePlane)
		{
			Session.GetTrackables(planesCache);
			if (planesCache.Count <= 0)
			{
				return true;
			}
		}
		return base.GetPlaneDiscoveryState();
	}
}
}
