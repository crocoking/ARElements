using System.Collections.Generic;
using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class VirtualPlaneTrackingService : MonoBehaviour, ITrackingService
{
	private List<VirtualPlane> m_VirtualPlanes = new List<VirtualPlane>();

	private HashSet<VirtualPlane> m_AnnouncedPlanes = new HashSet<VirtualPlane>();

	public SessionStatus trackingState => SessionStatus.Tracking;

	public bool enabledOnPlatform => true;

	private void Start()
	{
		if (!Application.isEditor)
		{
			base.enabled = false;
		}
	}

	public void AddPlane(VirtualPlane plane)
	{
		if (plane == null)
		{
			Debug.LogError("Can't add null editor plane");
		}
		else
		{
			m_VirtualPlanes.Add(plane);
		}
	}

	public void RemovePlane(VirtualPlane plane)
	{
		if (plane == null)
		{
			Debug.LogError("Can't remove null plane");
			return;
		}
		m_VirtualPlanes.Remove(plane);
		m_AnnouncedPlanes.Remove(plane);
	}

	public void GetNewPlanes(ref List<ITrackedPlane> planes)
	{
		if (planes == null)
		{
			planes = new List<ITrackedPlane>();
		}
		foreach (VirtualPlane virtualPlane in m_VirtualPlanes)
		{
			if (!m_AnnouncedPlanes.Contains(virtualPlane))
			{
				planes.Add(virtualPlane);
				m_AnnouncedPlanes.Add(virtualPlane);
			}
		}
	}

	public void GetUpdatedPlanes(ref List<ITrackedPlane> planes)
	{
		foreach (VirtualPlane announcedPlane in m_AnnouncedPlanes)
		{
			if (announcedPlane.isUpdated)
			{
				planes.Add(announcedPlane);
				announcedPlane.isUpdated = false;
			}
		}
	}
}
}
