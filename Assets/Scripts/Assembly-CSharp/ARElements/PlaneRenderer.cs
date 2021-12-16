using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace ARElements{

public class PlaneRenderer : MonoBehaviour
{
	private Camera _renderCamera;

	public Material zWriteMaterial;

	private CommandBuffer commandBuffer;

	private const CameraEvent cameraEvent = CameraEvent.BeforeForwardOpaque;

	private List<PlaneStack> planeStackCache = new List<PlaneStack>();

	public Camera renderCamera => (!_renderCamera) ? (_renderCamera = base.gameObject.GetComponent<Camera>()) : _renderCamera;

	private void OnEnable()
	{
		if ((bool)renderCamera)
		{
			commandBuffer = new CommandBuffer();
			commandBuffer.name = "PlaneRenderer";
			renderCamera.AddCommandBuffer(CameraEvent.BeforeForwardOpaque, commandBuffer);
		}
	}

	private void OnDisable()
	{
		if (commandBuffer != null)
		{
			renderCamera.RemoveCommandBuffer(CameraEvent.BeforeForwardOpaque, commandBuffer);
			commandBuffer.Dispose();
		}
	}

	private void OnPreCull()
	{
		if (renderCamera == null || !renderCamera || !ElementsSystem.instance || !ElementsSystem.instance.planeManager)
		{
			return;
		}
		planeStackCache.Clear();
		planeStackCache.AddRange(ElementsSystem.instance.planeManager.planeStacks);
		planeStackCache.Sort(ComparePlaneStacks);
		commandBuffer.Clear();
		foreach (PlaneStack item in planeStackCache)
		{
			if (!item.isActiveAndEnabled || item.planeLayers.Count <= 0)
			{
				continue;
			}
			PlaneLayer planeLayer = item.planeLayers[0];
			commandBuffer.DrawMesh(planeLayer.mesh, item.transform.localToWorldMatrix, zWriteMaterial);
			foreach (PlaneLayer planeLayer2 in item.planeLayers)
			{
				if (planeLayer2.isActiveAndEnabled && !item.IsLayerTypeDisabled(planeLayer2.layerType) && planeLayer2.shouldRender)
				{
					commandBuffer.DrawRenderer(planeLayer2.meshRenderer, planeLayer2.meshRenderer.sharedMaterial);
				}
			}
		}
	}

	private int ComparePlaneStacks(PlaneStack a, PlaneStack b)
	{
		float num = Mathf.Abs(a.transform.position.y - base.transform.position.y);
		float value = Mathf.Abs(b.transform.position.y - base.transform.position.y);
		return num.CompareTo(value);
	}
}
}
