using System;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ScreenAttachment : MonoBehaviour
{
	public float positionSpring = 1f;

	public float positionDamper = 0.5f;

	public float positionProjection;

	public float rotationSpring = 1f;

	public float rotationDamper = 0.5f;

	public bool autoConfigurePosition = true;

	public float gravityCorrection;

	public float jitterSmoothing = 0.1f;

	public bool parentToCamera;

	public bool counterDeviceOrientation = true;

	private Camera attachCamera;

	private Vector3 smoothCameraPosition;

	private Quaternion smoothCameraRotation;

	private Rigidbody _rigidbody;

	public Vector3 localPosition { get; set; }

	public Quaternion localRotation { get; set; }

	public Rigidbody rigidbody => (!_rigidbody) ? (_rigidbody = base.gameObject.GetComponent<Rigidbody>()) : _rigidbody;

	private void Start()
	{
		attachCamera = Camera.main;
		localPosition = Vector3.zero;
		localRotation = Quaternion.identity;
		if ((bool)attachCamera && autoConfigurePosition)
		{
			localPosition = base.transform.localPosition;
			localRotation = base.transform.localRotation;
		}
		smoothCameraPosition = attachCamera.transform.position;
		smoothCameraRotation = attachCamera.transform.rotation;
		if (parentToCamera)
		{
			base.transform.parent = attachCamera.transform;
		}
	}

	private void FixedUpdate()
	{
		if (!attachCamera)
		{
			return;
		}
		Vector3 vector = attachCamera.transform.position - smoothCameraPosition;
		Quaternion quaternion = attachCamera.transform.rotation * Quaternion.Inverse(smoothCameraRotation);
		Quaternion quaternion2 = localRotation;
		if (counterDeviceOrientation)
		{
			if (OrientationManager.current.deviceOrientation == DeviceOrientation.LandscapeRight)
			{
				quaternion2 *= Quaternion.Euler(0f, 0f, -90f);
			}
			if (OrientationManager.current.deviceOrientation == DeviceOrientation.LandscapeLeft)
			{
				quaternion2 *= Quaternion.Euler(0f, 0f, 90f);
			}
		}
		Vector3 vector2 = attachCamera.transform.TransformPoint(localPosition);
		Quaternion quaternion3 = attachCamera.transform.rotation * quaternion2;
		vector2 -= vector;
		quaternion3 *= quaternion;
		vector2 -= Physics.gravity * gravityCorrection * Time.fixedDeltaTime;
		rigidbody.velocity /= 1f + positionDamper * Time.fixedDeltaTime;
		if (positionSpring > 0f)
		{
			Vector3 vector3 = vector2 - base.transform.position;
			vector3 += vector3 * positionProjection;
			rigidbody.AddForceAtPosition(vector3 * positionSpring, base.transform.position);
		}
		rigidbody.angularVelocity /= 1f + rotationDamper * Time.fixedDeltaTime;
		if (rotationSpring > 0f)
		{
			Vector3 eulerAngles = (quaternion3 * Quaternion.Inverse(base.transform.rotation)).eulerAngles;
			eulerAngles.z = Mathf.DeltaAngle(0f, eulerAngles.z);
			eulerAngles.x = Mathf.DeltaAngle(0f, eulerAngles.x);
			eulerAngles.y = Mathf.DeltaAngle(0f, eulerAngles.y);
			rigidbody.AddTorque(eulerAngles * ((float)Math.PI / 180f) * rotationSpring);
		}
		if (jitterSmoothing <= 0f)
		{
			smoothCameraPosition = attachCamera.transform.position;
			smoothCameraRotation = attachCamera.transform.rotation;
		}
		else
		{
			smoothCameraPosition = Vector3.Lerp(smoothCameraPosition, attachCamera.transform.position, 1f / jitterSmoothing * Time.fixedDeltaTime);
			smoothCameraRotation = Quaternion.Slerp(smoothCameraRotation, attachCamera.transform.rotation, 1f / jitterSmoothing * Time.fixedDeltaTime);
		}
	}
}
}
