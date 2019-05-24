using System;
using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements
{
    public class AndroidTrackingService : MonoBehaviour, ITrackingService
    {
        public SessionStatus trackingState
        {
            get
            {
                return Session.Status;
            }
        }

        public bool enabledOnPlatform
        {
            get
            {
                return Application.platform == RuntimePlatform.Android;
            }
        }

        public void GetNewPlanes(ref List<ITrackedPlane> planes)
        {
            this.m_AddedPlanes.Clear();
            Session.GetTrackables<DetectedPlane>(this.m_AddedPlanes, TrackableQueryFilter.New);
            if (planes == null)
            {
                planes = new List<ITrackedPlane>();
            }
            foreach (DetectedPlane detectedPlane in this.m_AddedPlanes)
            {
                AndroidPlane androidPlane = new AndroidPlane(detectedPlane);
                this.m_AndroidPlanes[detectedPlane] = androidPlane;
                planes.Add(androidPlane);
            }
        }

        public void GetUpdatedPlanes(ref List<ITrackedPlane> planes)
        {
            this.m_UpdatedPlanes.Clear();
            Session.GetTrackables<DetectedPlane>(this.m_UpdatedPlanes, TrackableQueryFilter.Updated);
            if (planes == null)
            {
                planes = new List<ITrackedPlane>();
            }
            foreach (DetectedPlane key in this.m_UpdatedPlanes)
            {
                if (!this.m_AndroidPlanes.ContainsKey(key))
                {
                    Debug.LogError("Can't update untracked android plane");
                }
                else
                {
                    planes.Add(this.m_AndroidPlanes[key]);
                }
            }
        }

        private List<DetectedPlane> m_AddedPlanes = new List<DetectedPlane>();

        private List<DetectedPlane> m_UpdatedPlanes = new List<DetectedPlane>();

        private Dictionary<DetectedPlane, AndroidPlane> m_AndroidPlanes = new Dictionary<DetectedPlane, AndroidPlane>();
    }
}
