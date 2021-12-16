using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(Camera))]
public class ShadowMapController : MonoBehaviour
{
	[Tooltip("Increase or decrease the size of shadows.")]
	[Range(0f, 2f)]
	public float shadowScale = 1.2f;

	[Range(0f, 16f)]
	[Tooltip("Number of blur passes to apply to shadowmap if blur material is assigned.")]
	public int blurPasses;

	[Tooltip("Optional material used for most process blurring of the depth texture.")]
	public Material blurMaterial;

	[Tooltip("Shader for calculating the depth to create the shadow map.")]
	public Shader depthShader;

	private Camera m_ShadowCamera;

	private RenderTexture m_CameraRenderTexture;

	private const int k_ShadowTextureSize = 256;

	[HideInInspector]
	public RenderTexture shadowMap => m_CameraRenderTexture;

	private void Start()
	{
		m_CameraRenderTexture = CreateShadowMapRenderTexture();
		m_ShadowCamera = GetComponent<Camera>();
		m_ShadowCamera.targetTexture = m_CameraRenderTexture;
		m_ShadowCamera.clearFlags = CameraClearFlags.Color;
		m_ShadowCamera.backgroundColor = Color.red;
		if (!m_ShadowCamera.enabled)
		{
			m_ShadowCamera.enabled = true;
		}
	}

	private RenderTexture CreateShadowMapRenderTexture()
	{
		RenderTexture renderTexture = new RenderTexture(256, 256, 16, RenderTextureFormat.RGFloat, RenderTextureReadWrite.Linear);
		renderTexture.wrapMode = TextureWrapMode.Clamp;
		renderTexture.autoGenerateMips = false;
		renderTexture.useMipMap = false;
		renderTexture.filterMode = FilterMode.Bilinear;
		renderTexture.Create();
		return renderTexture;
	}

	private void Update()
	{
		if (!m_CameraRenderTexture.IsCreated())
		{
			m_CameraRenderTexture.Create();
		}
		SyncGlobalShaders();
		m_ShadowCamera.SetReplacementShader(depthShader, "RenderType");
	}

	private void OnPreRender()
	{
		SyncGlobalShaders();
	}

	private void OnPostRender()
	{
		SyncGlobalShaders();
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (blurMaterial != null)
		{
			BlurShadowMap(source, destination);
		}
		else
		{
			Graphics.Blit(source, destination);
		}
	}

	private void BlurShadowMap(RenderTexture source, RenderTexture destination)
	{
		RenderTexture renderTexture = source;
		RenderTexture renderTexture2 = destination;
		for (int i = 0; i < blurPasses; i++)
		{
			Graphics.Blit(renderTexture, renderTexture2, blurMaterial, 0);
			RenderTexture renderTexture3 = renderTexture2;
			renderTexture2 = renderTexture;
			renderTexture = renderTexture3;
		}
		if (renderTexture != destination)
		{
			renderTexture2.DiscardContents();
			Graphics.Blit(renderTexture, renderTexture2);
		}
	}

	private void SyncGlobalShaders()
	{
		Shader.SetGlobalTexture("_CustomShadowMap", shadowMap);
		Shader.SetGlobalMatrix("_CustomShadowMatrix", m_ShadowCamera.projectionMatrix * m_ShadowCamera.worldToCameraMatrix);
		Shader.SetGlobalMatrix("_CustomShadowWorldToCamera", m_ShadowCamera.worldToCameraMatrix);
		Shader.SetGlobalFloat("_CustomShadowFarClipPlane", m_ShadowCamera.farClipPlane);
		Shader.SetGlobalFloat("_CustomShadowScale", shadowScale);
	}
}
}
