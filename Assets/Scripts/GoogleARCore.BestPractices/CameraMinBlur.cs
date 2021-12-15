using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CameraMinBlur : MonoBehaviour
{
	public float minBackgroundBlur;

	public float minBlur;

	private void OnEnable()
	{
		CameraBlurController.current?.RegisterRequiredBackgroundBlur(GetBackgroundBlur);
		CameraBlurController.current?.RegisterRequiredBlur(GetBlur);
	}

	private void OnDisable()
	{
		CameraBlurController.current?.UnregisterRequiredBackgroundBlur(GetBackgroundBlur);
		CameraBlurController.current?.UnregisterRequiredBlur(GetBlur);
	}

	private float GetBackgroundBlur()
	{
		return minBackgroundBlur;
	}

	private float GetBlur()
	{
		return minBlur;
	}
}
}
