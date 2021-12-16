using UnityEngine;

namespace GoogleARCore.BestPractices{

public class LabelOrientToCamera : MonoBehaviour
{
	private const float blendBias = 4f;

	private void LateUpdate()
	{
		Camera main = Camera.main;
		Vector3 zero = Vector3.zero;
		switch(OrientationManager.current.deviceOrientation)
		{
			case DeviceOrientation.Portrait: zero = main.transform.right; break;
			case DeviceOrientation.PortraitUpsideDown : zero = main.transform.right; break;
				case DeviceOrientation.LandscapeRight : zero = -main.transform.up; break;
                default: zero = main.transform.up;break;
		};
		float num = Mathf.Abs(Vector3.Dot(main.transform.forward, Vector3.up));
		num -= 0.75f;
		num *= 4f;
		num = Mathf.Clamp01(num);
		Vector3 upwards = Vector3.Slerp(Vector3.up, zero, num);
		Quaternion rotation = Quaternion.LookRotation(main.transform.forward, upwards);
		base.transform.rotation = rotation;
	}
}
}
