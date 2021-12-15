using System.Linq;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class LinkCanvasToCamera : MonoBehaviour
{
	public Canvas canvas;

	public string cameraName;

	public float canvasDistance;

	private void Start()
	{
		Camera camera = Camera.allCameras.FirstOrDefault((Camera v) => v.name == cameraName);
		if ((bool)camera)
		{
			canvas.worldCamera = camera;
			if (canvasDistance > 0f)
			{
				canvas.planeDistance = canvasDistance;
			}
		}
	}
}
}
