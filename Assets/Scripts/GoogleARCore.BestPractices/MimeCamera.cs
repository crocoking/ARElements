using UnityEngine;

namespace GoogleARCore.BestPractices{

public class MimeCamera : MonoBehaviour
{
	public Camera targetCamera;

	private Camera _camera;

	private Camera camera => (!_camera) ? (_camera = base.gameObject.GetComponent<Camera>()) : _camera;

	private void OnPreCull()
	{
		camera.fieldOfView = targetCamera.fieldOfView;
		camera.nearClipPlane = targetCamera.nearClipPlane;
		camera.farClipPlane = targetCamera.farClipPlane;
		camera.projectionMatrix = targetCamera.projectionMatrix;
	}
}
}
