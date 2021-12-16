using System.Collections;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class MaintainAxisDistance : MonoBehaviour
{
	public Transform axisTransform;

	public float maxForce = 20f;

	public ForceMode forceMode = ForceMode.Acceleration;

	public float radius;

	private void FixedUpdate()
	{
		Constrain();
		StartCoroutine(ConstrainAfterFixedUpdate());
	}

	private IEnumerator ConstrainAfterFixedUpdate()
	{
		yield return new WaitForFixedUpdate();
		Constrain();
	}

	private void Constrain()
	{
		Vector3 up = axisTransform.up;
		Vector3 position = axisTransform.position;
		Vector3 vector = base.transform.position - position;
		Vector3 vector2 = Vector3.Project(vector, up) + position;
		float num = Vector3.Distance(vector2, base.transform.position);
		Rigidbody componentInParent = base.gameObject.GetComponentInParent<Rigidbody>();
		if (radius > 0f)
		{
			float num2 = num / radius;
			Vector3 normalized = (base.transform.position - vector2).normalized;
			if (num2 > 1f)
			{
				Vector3 position2 = vector2 + normalized * radius;
				if ((bool)componentInParent)
				{
					componentInParent.position = position2;
					componentInParent.velocity = Vector3.ProjectOnPlane(componentInParent.velocity, normalized);
				}
				else
				{
					base.transform.position = position2;
				}
				num2 = 1f;
			}
			if ((bool)componentInParent)
			{
				componentInParent.AddForce(normalized * (0f - maxForce) * num2, forceMode);
			}
		}
		else if ((bool)componentInParent)
		{
			componentInParent.position = vector2;
			componentInParent.velocity = Vector3.Project(componentInParent.velocity, up);
		}
		else
		{
			base.transform.position = vector2;
		}
	}

	private void OnDrawGizmosSelected()
	{
		if ((bool)axisTransform)
		{
			Gizmos.matrix = Matrix4x4.Translate(axisTransform.position);
			Gizmos.matrix *= Matrix4x4.Rotate(axisTransform.rotation);
			Gizmos.DrawLine(Vector3.down, Vector3.up);
			Gizmos.matrix = Matrix4x4.Translate(axisTransform.position);
			Gizmos.matrix *= Matrix4x4.Rotate(axisTransform.rotation);
			Matrix4x4 matrix = Gizmos.matrix;
			Gizmos.matrix *= Matrix4x4.Translate(Vector3.up);
			Gizmos.matrix *= Matrix4x4.Scale(new Vector3(1f, 0f, 1f));
			Gizmos.DrawWireSphere(Vector3.up, radius);
			Gizmos.matrix = matrix;
			Gizmos.matrix *= Matrix4x4.Translate(Vector3.down);
			Gizmos.matrix *= Matrix4x4.Scale(new Vector3(1f, 0f, 1f));
			Gizmos.DrawWireSphere(Vector3.down, radius);
		}
	}
}
}
