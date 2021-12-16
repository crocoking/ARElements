using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RenderTargetSetter : MonoBehaviour
{
	public RenderScaleManager renderScaleManager;

	private Camera _camera;

	public Camera camera
	{
		[CompilerGenerated]
		get
		{
			return (!_camera) ? (_camera = base.gameObject.GetComponent<Camera>()) : _camera;
		}
	}

	private void OnPreCull()
	{
		camera.targetTexture = renderScaleManager.renderTarget;
	}
}
}
