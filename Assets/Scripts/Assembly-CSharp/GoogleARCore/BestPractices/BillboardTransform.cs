using UnityEngine;

namespace GoogleARCore.BestPractices{

public class BillboardTransform : MonoBehaviour
{
	private void LateUpdate()
	{
		Vector3 forward = base.transform.position - Camera.main.transform.position;
		forward.y = 0f;
		forward.Normalize();
		if (forward.magnitude == 0f)
		{
			forward = Vector3.forward;
		}
		base.transform.rotation = Quaternion.LookRotation(forward);
	}
}
}
