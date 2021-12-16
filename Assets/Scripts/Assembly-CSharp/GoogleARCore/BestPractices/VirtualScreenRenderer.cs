using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class VirtualScreenRenderer : MonoBehaviour
{
	[Serializable]
	public struct RendererMaterialInfo
	{
		public Renderer renderer;

		public int materialIndex;
	}

	public Material materialTemplate;

	public List<RendererMaterialInfo> rendererMaterialInfos = new List<RendererMaterialInfo>();

	private Material screenMaterial;

	private RenderTexture screenRT;

	private void Start()
	{
		screenRT = new RenderTexture(256, 512, 0, RenderTextureFormat.ARGB32);
		screenRT.useMipMap = true;
		screenMaterial = new Material(materialTemplate);
		screenMaterial.SetTexture("_EmissionTex", screenRT);
		foreach (RendererMaterialInfo rendererMaterialInfo in rendererMaterialInfos)
		{
			Material[] sharedMaterials = rendererMaterialInfo.renderer.sharedMaterials;
			sharedMaterials[rendererMaterialInfo.materialIndex] = screenMaterial;
			rendererMaterialInfo.renderer.sharedMaterials = sharedMaterials;
		}
	}

	private void LateUpdate()
	{
		screenRT.DiscardContents();
		CameraImageBLitter.Blit(screenRT, fixedOrientation: true);
	}
}
}
