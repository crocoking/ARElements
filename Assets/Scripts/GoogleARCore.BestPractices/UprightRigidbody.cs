using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class UprightRigidbody : MonoBehaviour
{
	private Rigidbody _rigidbody;

	public float correctionRate;

	public Rigidbody rigidbody
	{
		[CompilerGenerated]
		get
		{
			return (!_rigidbody) ? (_rigidbody = base.gameObject.GetComponent<Rigidbody>()) : _rigidbody;
		}
	}

	private void FixedUpdate()
	{
		if ((bool)rigidbody)
		{
			Quaternion.FromToRotation(rigidbody.rotation * Vector3.up, Vector3.up).ToAngleAxis(out var angle, out var axis);
			rigidbody.AddTorque(axis * angle * correctionRate, ForceMode.Acceleration);
		}
	}
}
}
