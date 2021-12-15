using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements
{

	public class AndroidTrackingService : MonoBehaviour, ITrackingService
	{
		private List<DetectedPlane> m_AddedPlanes = new List<DetectedPlane>();

		private List<DetectedPlane> m_UpdatedPlanes = new List<DetectedPlane>();

		private Dictionary<DetectedPlane, AndroidPlane> m_AndroidPlanes = new Dictionary<DetectedPlane, AndroidPlane>();

		public SessionStatus trackingState => Session.Status;

		public bool enabledOnPlatform => Application.platform == RuntimePlatform.Android;

		public void GetNewPlanes(ref List<ITrackedPlane> planes)
		{
			m_AddedPlanes.Clear();
			Session.GetTrackables(m_AddedPlanes, TrackableQueryFilter.New);
			if (planes == null)
			{
				planes = new List<ITrackedPlane>();
			}
			foreach (DetectedPlane addedPlane in m_AddedPlanes)
			{
				AndroidPlane androidPlane = new AndroidPlane(addedPlane);
				m_AndroidPlanes[addedPlane] = androidPlane;
				planes.Add(androidPlane);
			}
		}

		public void GetUpdatedPlanes(ref List<ITrackedPlane> planes)
		{
			m_UpdatedPlanes.Clear();
			Session.GetTrackables(m_UpdatedPlanes, TrackableQueryFilter.Updated);
			if (planes == null)
			{
				planes = new List<ITrackedPlane>();
			}
			foreach (DetectedPlane updatedPlane in m_UpdatedPlanes)
			{
				if (!m_AndroidPlanes.ContainsKey(updatedPlane))
				{
					Debug.LogError("Can't update untracked android plane");
				}
				else
				{
					planes.Add(m_AndroidPlanes[updatedPlane]);
				}
			}
		}
	}
}
