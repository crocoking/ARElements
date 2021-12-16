using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class HeadLookController : MonoBehaviour
{
	[Serializable]
	public class LookAtInfo
	{
		public Transform transform;

		public AnimationCurve weightCurve;

		public float maxAngle;

		public float lookRate;

		public Vector3 rotationOffset;

		private Quaternion currentLookOffset;

		public float SampleLookWeight(float angle)
		{
			float time = angle / maxAngle;
			return weightCurve.Evaluate(time);
		}

		public void UpdateLook(Vector3 targetLookDirection)
		{
			if (!(transform == null))
			{
				Vector3 forward = transform.InverseTransformDirection(targetLookDirection);
				Quaternion b = Quaternion.LookRotation(forward, Vector3.up) * Quaternion.Euler(rotationOffset);
				currentLookOffset = Quaternion.Slerp(currentLookOffset, b, lookRate * Time.deltaTime);
				transform.localRotation *= currentLookOffset;
			}
		}
	}

	public float weight = 1f;

	public Vector3 worldLookOffset;

	public Transform overrideTarget;

	public Transform headTransform;

	public float headRate = 10f;

	public List<LookAtInfo> lookAtInfos = new List<LookAtInfo>();

	private void LateUpdate()
	{
		Transform transform = ((!overrideTarget) ? Camera.main.transform : overrideTarget);
		foreach (LookAtInfo lookAtInfo in lookAtInfos)
		{
			Vector3 vector = headTransform.forward;
			if ((bool)transform)
			{
				Vector3 vector2 = transform.position + worldLookOffset;
				Vector3 vector3 = vector2 - headTransform.position;
				float num = Vector3.Angle(vector, vector3);
				if (num < lookAtInfo.maxAngle)
				{
					vector = Vector3.Lerp(vector, vector3, lookAtInfo.SampleLookWeight(num) * weight);
				}
			}
			lookAtInfo.UpdateLook(vector);
		}
	}
}
}
