using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CaptureCameraUser : MonoBehaviour
{
	public string captureTag = string.Empty;

	private CaptureCameraTexture captureCameraTexture
	{
		get
		{
			if (string.IsNullOrEmpty(captureTag))
			{
				return null;
			}
			return CaptureCameraTexture.GetByTag(captureTag);
		}
	}

	private void OnEnable()
	{
		if ((bool)captureCameraTexture)
		{
			captureCameraTexture.RegisterUser(this);
		}
	}

	private void OnDisable()
	{
		if ((bool)captureCameraTexture)
		{
			captureCameraTexture.UnregisterUser(this);
		}
	}
}
}
