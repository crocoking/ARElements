using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CenterOfMass : MonoBehaviour
{
	public bool dynamicUpdate = true;

	private void Start()
	{
		UpdateCenterOfMass();
	}

	private void Update()
	{
		if (dynamicUpdate)
		{
			UpdateCenterOfMass();
		}
	}

	private void UpdateCenterOfMass()
	{
		Rigidbody componentInParent = base.gameObject.GetComponentInParent<Rigidbody>();
		if ((bool)componentInParent)
		{
			componentInParent.centerOfMass = componentInParent.transform.InverseTransformPoint(base.transform.position);
		}
	}
}
}
