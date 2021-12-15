using UnityEngine;
using UnityEngine.XR;

namespace GoogleARCore.BestPractices{

public static class CameraImageBLitter
{
	private static Camera backgroundCamera;

	private static ARBackgroundRenderer backgroundRenderer;

	public static void Blit(RenderTexture targetTexture, bool fixedOrientation)
	{
		if (!backgroundCamera)
		{
			backgroundCamera = new GameObject("EditorPreviewCamera").AddComponent<Camera>();
			backgroundCamera.enabled = false;
			backgroundCamera.cullingMask = 0;
			if (!Application.isEditor)
			{
				ARCoreBackgroundRenderer aRCoreBackgroundRenderer = Object.FindObjectOfType<ARCoreBackgroundRenderer>();
				ARBackgroundRenderer aRBackgroundRenderer = new ARBackgroundRenderer();
				aRBackgroundRenderer.backgroundMaterial = aRCoreBackgroundRenderer.BackgroundMaterial;
				aRBackgroundRenderer.camera = backgroundCamera;
				aRBackgroundRenderer.mode = ARRenderMode.MaterialAsBackground;
			}
		}
		backgroundCamera.targetTexture = targetTexture;
		backgroundCamera.Render();
		backgroundCamera.targetTexture = null;
	}
}
}
