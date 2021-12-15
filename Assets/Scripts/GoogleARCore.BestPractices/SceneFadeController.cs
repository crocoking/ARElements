using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class SceneFadeController : MonoBehaviour
{
	private static SceneFadeController _current;

	public float weight;

	public string preSceneCaptureTag;

	private Material blendMaterial;

	public static SceneFadeController current
	{
		[CompilerGenerated]
		get
		{
			return _current ? _current : (_current = Object.FindObjectOfType<SceneFadeController>());
		}
	}

	private void Awake()
	{
		blendMaterial = new Material(Shader.Find("Hidden/ARCoreBestPractices/AlphaBlit"));
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		CaptureCameraTexture byTag = CaptureCameraTexture.GetByTag(preSceneCaptureTag);
		if (!byTag || weight >= 1f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		Graphics.Blit(byTag.cameraTexture, destination);
		if (!(weight <= 0f))
		{
			Graphics.Blit(byTag.cameraTexture, destination);
			blendMaterial.SetFloat("_Alpha", weight);
			blendMaterial.SetFloat("_SourceAlphaChannelWeight", 0f);
			Graphics.Blit(source, destination, blendMaterial, 0);
		}
	}
}
}
