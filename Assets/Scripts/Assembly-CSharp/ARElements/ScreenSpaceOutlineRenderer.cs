using UnityEngine;
using UnityEngine.Rendering;

namespace ARElements{

[RequireComponent(typeof(Camera))]
public class ScreenSpaceOutlineRenderer : MonoBehaviour
{
	private int m_Iteration = 4;

	private float m_BlurSpread = 1f;

	private float m_Opacity = 0.3f;

	private Material m_BlurMaterial;

	private Material m_CutMaterial;

	private Material m_CompositeMaterial;

	private Material m_OccludeMaterial;

	private RenderTexture m_RenderTexture;

	private RenderTexture m_OccluderTexture;

	private CommandBuffer m_CommandBuffer;

	private Camera m_Camera;

	private int m_DownSampleFactor = 4;

	private static readonly Color colorClear = new Color(0f, 0f, 0f, 0f);

	public int iteration
	{
		get
		{
			return m_Iteration;
		}
		set
		{
			m_Iteration = value;
		}
	}

	public float blurSpread
	{
		get
		{
			return m_BlurSpread;
		}
		set
		{
			m_BlurSpread = value;
			blurMaterial.SetFloat("_BlurOffset", m_BlurSpread);
		}
	}

	public float opacity
	{
		get
		{
			return m_Opacity;
		}
		set
		{
			m_Opacity = value;
			blurMaterial.SetFloat("_Intensity", m_Opacity);
		}
	}

	private Material blurMaterial
	{
		get
		{
			if (m_BlurMaterial == null)
			{
				m_BlurMaterial = new Material(Shader.Find("Screen Space Outline/Blur"));
			}
			return m_BlurMaterial;
		}
	}

	private Material cutMaterial
	{
		get
		{
			if (m_CutMaterial == null)
			{
				m_CutMaterial = new Material(Shader.Find("Screen Space Outline/Cut"));
			}
			return m_CutMaterial;
		}
	}

	private Material compositeMaterial
	{
		get
		{
			if (m_CompositeMaterial == null)
			{
				m_CompositeMaterial = new Material(Shader.Find("Screen Space Outline/Composite"));
			}
			return m_CompositeMaterial;
		}
	}

	private Material occludeMaterial
	{
		get
		{
			if (m_OccludeMaterial == null)
			{
				m_OccludeMaterial = new Material(Shader.Find("Screen Space Outline/Occlude"));
			}
			return m_OccludeMaterial;
		}
	}

	protected virtual void OnEnable()
	{
		m_Camera = GetComponent<Camera>();
		m_CommandBuffer = new CommandBuffer();
		m_CommandBuffer.name = "ScreenSpaceOutline";
		m_Camera.AddCommandBuffer(CameraEvent.BeforeImageEffectsOpaque, m_CommandBuffer);
		if (m_RenderTexture != null && !m_RenderTexture.IsCreated())
		{
			m_RenderTexture.Create();
		}
		if (m_OccluderTexture != null && !m_OccluderTexture.IsCreated())
		{
			m_OccluderTexture.Create();
		}
	}

	protected virtual void OnDisable()
	{
		if (m_CommandBuffer != null)
		{
			m_Camera.RemoveCommandBuffer(CameraEvent.BeforeImageEffectsOpaque, m_CommandBuffer);
			m_CommandBuffer = null;
		}
		if (m_RenderTexture != null && m_RenderTexture.IsCreated())
		{
			m_RenderTexture.Release();
		}
		if (m_OccluderTexture != null && m_OccluderTexture.IsCreated())
		{
			m_OccluderTexture.Release();
		}
	}

	private void RebuildCommandBuffer()
	{
		m_CommandBuffer.Clear();
		if (m_RenderTexture == null)
		{
			m_RenderTexture = new RenderTexture(m_Camera.pixelWidth, m_Camera.pixelHeight, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default);
			m_RenderTexture.filterMode = FilterMode.Point;
			m_RenderTexture.useMipMap = false;
			m_RenderTexture.wrapMode = TextureWrapMode.Clamp;
			m_RenderTexture.Create();
			compositeMaterial.SetTexture("_OutlineBuffer", m_RenderTexture);
		}
		m_CommandBuffer.SetRenderTarget(m_RenderTexture);
		m_CommandBuffer.ClearRenderTarget(clearDepth: true, clearColor: true, colorClear);
		ScreenSpaceOutliner.FillBuffer(m_CommandBuffer);
		m_CommandBuffer.GetTemporaryRT(Shader.PropertyToID("_OutlineBlur1"), m_RenderTexture.width / m_DownSampleFactor, m_RenderTexture.height / m_DownSampleFactor, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default);
		m_CommandBuffer.GetTemporaryRT(Shader.PropertyToID("_OutlineBlur2"), m_RenderTexture.width / m_DownSampleFactor, m_RenderTexture.height / m_DownSampleFactor, 0, FilterMode.Bilinear, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default);
		RenderTargetIdentifier renderTargetIdentifier = new RenderTargetIdentifier(Shader.PropertyToID("_OutlineBlur1"));
		RenderTargetIdentifier renderTargetIdentifier2 = new RenderTargetIdentifier(Shader.PropertyToID("_OutlineBlur2"));
		RenderTargetIdentifier renderTargetIdentifier3 = new RenderTargetIdentifier(m_RenderTexture);
		m_CommandBuffer.Blit(renderTargetIdentifier3, renderTargetIdentifier);
		RenderTargetIdentifier renderTargetIdentifier4 = renderTargetIdentifier;
		RenderTargetIdentifier renderTargetIdentifier5 = renderTargetIdentifier2;
		for (int i = 0; i < iteration; i++)
		{
			m_CommandBuffer.Blit(renderTargetIdentifier4, renderTargetIdentifier5, blurMaterial, 0);
			RenderTargetIdentifier renderTargetIdentifier6 = renderTargetIdentifier4;
			renderTargetIdentifier4 = renderTargetIdentifier5;
			renderTargetIdentifier5 = renderTargetIdentifier6;
		}
		if (ScreenSpaceOccluder.count > 0)
		{
			if (m_OccluderTexture == null)
			{
				m_OccluderTexture = new RenderTexture(m_Camera.pixelWidth, m_Camera.pixelHeight, 24, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Default);
				m_OccluderTexture.antiAliasing = QualitySettings.antiAliasing;
				m_OccluderTexture.filterMode = FilterMode.Point;
				m_OccluderTexture.useMipMap = false;
				m_OccluderTexture.wrapMode = TextureWrapMode.Clamp;
				m_OccluderTexture.Create();
			}
			m_CommandBuffer.SetRenderTarget(m_OccluderTexture);
			m_CommandBuffer.ClearRenderTarget(clearDepth: true, clearColor: true, colorClear);
			ScreenSpaceOccluder.FillBuffer(m_CommandBuffer);
			RenderTargetIdentifier source = new RenderTargetIdentifier(m_OccluderTexture);
			m_CommandBuffer.Blit(source, renderTargetIdentifier3, occludeMaterial);
		}
		m_CommandBuffer.Blit(renderTargetIdentifier4, renderTargetIdentifier3, cutMaterial);
		m_CommandBuffer.ReleaseTemporaryRT(Shader.PropertyToID("_OutlineBlur1"));
		m_CommandBuffer.ReleaseTemporaryRT(Shader.PropertyToID("_OutlineBlur2"));
	}

	private void OnPreRender()
	{
		RebuildCommandBuffer();
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit(source, destination, compositeMaterial);
	}
}
}
