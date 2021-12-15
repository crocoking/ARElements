using UnityEngine;

namespace GoogleARCore.BestPractices{

public class DottyRaycastLift : MonoBehaviour
{
	public RaycastGrabberLine grabberLine;

	public Transform liftTarget;

	private void LateUpdate()
	{
		grabberLine.startPosition = grabberLine.lineRenderer.transform.position;
		grabberLine.endPosition = liftTarget.position;
		float num = Vector3.Distance(grabberLine.startPosition, grabberLine.endPosition);
		grabberLine.controlPosition = grabberLine.transform.position + grabberLine.transform.forward * (num / 2f);
		grabberLine.UpdateLineRenderer();
	}
}
}
