using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CameraFacingToggle : MonoBehaviour
{
	public GameObject toggleGameObject;

	public bool useToggleGameObjectTransform;

	private void LateUpdate()
	{
		if (!toggleGameObject)
		{
			return;
		}
		Transform transform = base.transform;
		if (useToggleGameObjectTransform)
		{
			transform = toggleGameObject.transform;
		}
		Camera main = Camera.main;
		if (!main)
		{
			return;
		}
		Vector3 forward = main.transform.forward;
		forward = (transform.position - main.transform.position).normalized;
		float num = Vector3.Dot(transform.forward, forward);
		if (num <= 0f)
		{
			if (toggleGameObject.activeSelf)
			{
				toggleGameObject.SetActive(value: false);
			}
		}
		else if (!toggleGameObject.activeSelf)
		{
			toggleGameObject.SetActive(value: true);
		}
	}
}
}
