using UnityEngine;

namespace GoogleARCore.BestPractices{

public class BackgroundCameraRenderer : MonoBehaviour
{
	public Camera backgroundRenderCamera;

	private void Awake()
	{
		if (Application.isEditor)
		{
			backgroundRenderCamera.enabled = true;
		}
	}

	private void Update()
	{
		if (!Application.isEditor)
		{
			backgroundRenderCamera.Render();
		}
	}
}
}
