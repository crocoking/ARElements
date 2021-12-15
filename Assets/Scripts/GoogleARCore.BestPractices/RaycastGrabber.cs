using System.Collections;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RaycastGrabber : MonoBehaviour
{
	public SpringJoint target;

	public RaycastGrabberLine raycastGrabberLine;

	public Rigidbody testRigidBody;

	public float nonBendingMassThreshold;

	public TargetingButton targetingButton;

	private float grabbedDistance;

	private Vector3 localHitPosition;

	private Camera mainCamera;

	private void Start()
	{
		mainCamera = Camera.main;
		raycastGrabberLine.transform.SetParent(Camera.main.transform, worldPositionStays: false);
		raycastGrabberLine.lineRenderer.enabled = false;
		targetingButton.onButtonDown = OnButtonDown;
		targetingButton.onButtonUp = OnButtonUp;
		targetingButton.onTestHit = OnTestHit;
	}

	private bool OnTestHit(RaycastHit hit)
	{
		return (bool)hit.rigidbody && !hit.rigidbody.isKinematic && (bool)hit.rigidbody.gameObject.GetComponent<RaycastGrabbable>();
	}

	private void OnButtonDown(RaycastHit hit)
	{
		if (OnTestHit(hit))
		{
			target.connectedBody = hit.rigidbody;
			localHitPosition = hit.point;
			localHitPosition = target.connectedBody.transform.InverseTransformPoint(localHitPosition);
			Vector3 position = Vector3.Lerp(target.connectedBody.transform.position, hit.point, 0.5f);
			target.transform.position = position;
			target.connectedAnchor = target.connectedBody.transform.InverseTransformPoint(position);
			grabbedDistance = hit.distance;
			raycastGrabberLine.lineRenderer.enabled = true;
			RaycastGrabbable component = hit.rigidbody.gameObject.GetComponent<RaycastGrabbable>();
			if ((bool)component)
			{
				component.Grab();
			}
		}
	}

	private void OnButtonUp()
	{
		if ((bool)target.connectedBody)
		{
			RaycastGrabbable component = target.connectedBody.gameObject.GetComponent<RaycastGrabbable>();
			if ((bool)component)
			{
				component.Release();
			}
		}
		target.connectedBody = null;
		raycastGrabberLine.lineRenderer.enabled = false;
	}

	private void FixedUpdate()
	{
		if ((bool)target.connectedBody)
		{
			Ray ray = new Ray(mainCamera.transform.position, mainCamera.transform.forward);
			target.transform.position = ray.origin + ray.direction * grabbedDistance;
			target.connectedBody.AddForce(-Physics.gravity * 0.85f, ForceMode.Acceleration);
			target.connectedBody.AddForce(-target.connectedBody.velocity * 0.5f, ForceMode.Acceleration);
			Vector3 angularVelocity = target.connectedBody.angularVelocity;
			angularVelocity /= 1f + 1f * Time.deltaTime;
			target.connectedBody.angularVelocity = angularVelocity;
		}
		StartCoroutine(ConstrainAfterFixedUpdate());
	}

	private IEnumerator ConstrainAfterFixedUpdate()
	{
		yield return new WaitForFixedUpdate();
		if ((bool)target.connectedBody)
		{
			target.connectedBody.AddForce(-target.connectedBody.velocity * 0.5f, ForceMode.Acceleration);
		}
	}

	private void LateUpdate()
	{
		if (raycastGrabberLine.lineRenderer.enabled)
		{
			Vector3 zero = Vector3.zero;
			switch( OrientationManager.current.deviceOrientation )
			{
				case DeviceOrientation.Portrait: zero = Vector3.right; break; 
				case DeviceOrientation.PortraitUpsideDown: zero = Vector3.left; break;
				case DeviceOrientation.LandscapeLeft : zero = Vector3.down; break;
				case DeviceOrientation.LandscapeRight: zero = Vector3.up; break;
				default : zero = Vector3.down; break;
			};
			raycastGrabberLine.startPosition = raycastGrabberLine.transform.position + raycastGrabberLine.transform.rotation * zero * 0.1f;
			raycastGrabberLine.endPosition = target.connectedBody.transform.TransformPoint(localHitPosition);
			if (target.connectedBody.mass < nonBendingMassThreshold)
			{
				raycastGrabberLine.controlPosition = (raycastGrabberLine.startPosition + raycastGrabberLine.endPosition) / 2f;
			}
			else
			{
				float num = Vector3.Distance(raycastGrabberLine.startPosition, raycastGrabberLine.endPosition);
				raycastGrabberLine.controlPosition = raycastGrabberLine.transform.position + raycastGrabberLine.transform.forward * (num / 2f);
			}
			raycastGrabberLine.UpdateLineRenderer();
		}
	}
}
}
