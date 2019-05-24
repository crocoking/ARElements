using System;
using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements
{
    public class AndroidPlane : ITrackedPlane
    {
        public AndroidPlane(DetectedPlane trackedPlane)
        {
            this.trackedPlane = trackedPlane;
        }

        public DetectedPlane trackedPlane { get; private set; }

        public Vector3 position
        {
            get
            {
                return this.trackedPlane.CenterPose.position;
            }
        }

        public Quaternion rotation
        {
            get
            {
                return this.trackedPlane.CenterPose.rotation;
            }
        }

        public Vector2 size
        {
            get
            {
                return new Vector2(this.trackedPlane.ExtentX, this.trackedPlane.ExtentZ);
            }
        }

        public List<Vector3> boundaryPoints
        {
            get
            {
                this.m_BoundaryList.Clear();
                this.trackedPlane.GetBoundaryPolygon(this.m_BoundaryList);
                return this.m_BoundaryList;
            }
        }

        public PlaneState planeState
        {
            get
            {
                if (this.trackedPlane.SubsumedBy != null)
                {
                    return PlaneState.Replaced;
                }
                if (this.trackedPlane.TrackingState == TrackingState.Tracking)
                {
                    return PlaneState.Valid;
                }
                return PlaneState.Invalid;
            }
        }

        private List<Vector3> m_BoundaryList = new List<Vector3>();
    }
}
