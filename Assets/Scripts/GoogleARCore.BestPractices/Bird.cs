using System;
using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class Bird : MonoBehaviour
{
	public Animator animator;

	public float torqueCompensation = 0.1f;

	public float toequeSpeed = 10f;

	public float flapUpForce = 0.35f;

	public float speed = 5f;

	public float maxFlapSpeed = 5f;

	public float minFlapSpeed = 0.25f;

	public float circleRadius = 1f;

	public float targetHeightNoise = 2f;

	private Rigidbody _rigidbody;

	private float flapSpeed = 1f;

	public Transform target { get; set; }

	private Rigidbody rigidbody
	{
		[CompilerGenerated]
		get
		{
			return (!_rigidbody) ? (_rigidbody = GetComponent<Rigidbody>()) : _rigidbody;
		}
	}

	private void Start()
	{
	}

	private void FixedUpdate()
	{
		if ((bool)target)
		{
			Vector3 targetPosition = GetTargetPosition();
			Vector3 normalized = (targetPosition - base.transform.position).normalized;
			Quaternion quaternion = Quaternion.Euler(rigidbody.angularVelocity * 57.29578f * torqueCompensation);
			Vector3 b = Vector3.ProjectOnPlane(normalized, base.transform.forward);
			b = Vector3.Lerp(Vector3.up, b, Vector3.Dot(base.transform.forward, normalized) * 0.5f);
			Vector3 normalized2 = Vector3.ProjectOnPlane(b, normalized).normalized;
			Vector3 lhs = quaternion * base.transform.up;
			Vector3 vector = Vector3.Cross(lhs, normalized2);
			vector *= 360f;
			Vector3 lhs2 = quaternion * base.transform.forward;
			Vector3 vector2 = Vector3.Cross(lhs2, normalized);
			vector2 *= 360f;
			rigidbody.AddTorque((vector2 + vector) * ((float)Math.PI / 180f) * toequeSpeed, ForceMode.Acceleration);
			float num = base.transform.position.y + rigidbody.velocity.y * 0f - targetPosition.y;
			num += UnityEngine.Random.Range(0f - targetHeightNoise, targetHeightNoise);
			float num2 = 0f;
			num2 = ((!(num < 0f)) ? (1f / ((num + 0.5f) * 4f)) : (1f + (0f - num) * 4f));
			num2 = Mathf.Clamp(num2, minFlapSpeed, maxFlapSpeed);
			flapSpeed = Mathf.Lerp(flapSpeed, num2, 10f * Time.deltaTime);
			animator.SetFloat("FlapSpeed", flapSpeed);
		}
		rigidbody.AddForce(-Physics.gravity * 0.7f, ForceMode.Acceleration);
	}

	private void OnFlapAnimationEvent(AnimationEvent animationEvent)
	{
		Vector3 vector = Vector3.zero;
		if ((bool)target)
		{
			vector = GetTargetPosition();
		}
		Vector3 normalized = (vector - base.transform.position).normalized;
		Vector3 force = (normalized + base.transform.forward) / 2f * speed;
		force *= 0.1f;
		force += -Physics.gravity * flapUpForce / 2f;
		rigidbody.AddForce(force, ForceMode.Impulse);
	}

	private Vector3 GetTargetPosition()
	{
		Vector3 normalized = Vector3.Cross((target.position - base.transform.position).normalized, Vector3.up).normalized;
		return target.position + normalized * circleRadius;
	}

	private void OnDrawGizmos()
	{
		if ((bool)target)
		{
			Gizmos.DrawLine(base.transform.position, GetTargetPosition());
			Gizmos.matrix = target.localToWorldMatrix * Matrix4x4.Scale(new Vector3(1f, 0f, 1f));
			Gizmos.DrawWireSphere(Vector3.zero, circleRadius);
		}
	}
}
}
