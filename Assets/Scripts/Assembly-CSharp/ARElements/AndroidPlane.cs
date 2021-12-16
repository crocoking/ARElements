using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements
{

	public class AndroidPlane : ITrackedPlane
	{
		private List<Vector3> m_BoundaryList = new List<Vector3>();

		public DetectedPlane trackedPlane { get; private set; }

		public Vector3 position => trackedPlane.CenterPose.position;

		public Quaternion rotation => trackedPlane.CenterPose.rotation;

		public Vector2 size => new Vector2(trackedPlane.ExtentX, trackedPlane.ExtentZ);

		public List<Vector3> boundaryPoints
		{
			get
			{
				m_BoundaryList.Clear();
				trackedPlane.GetBoundaryPolygon(m_BoundaryList);
				return m_BoundaryList;
			}
		}

		public PlaneState planeState
		{
			get
			{
				if (trackedPlane.SubsumedBy != null)
				{
					return PlaneState.Replaced;
				}
				if (trackedPlane.TrackingState == TrackingState.Tracking)
				{
					return PlaneState.Valid;
				}
				return PlaneState.Invalid;
			}
		}

		public AndroidPlane(DetectedPlane trackedPlane)
		{
			this.trackedPlane = trackedPlane;
		}
	}
}
