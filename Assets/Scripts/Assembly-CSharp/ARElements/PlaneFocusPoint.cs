using UnityEngine;

namespace ARElements{

public class PlaneFocusPoint
{
	public ITrackedPlane plane { get; private set; }

	public Vector3 worldPoint { get; private set; }

	public PlaneFocusPoint(ITrackedPlane plane, Vector3 worldPoint)
	{
		this.plane = plane;
		this.worldPoint = worldPoint;
	}
}
}
