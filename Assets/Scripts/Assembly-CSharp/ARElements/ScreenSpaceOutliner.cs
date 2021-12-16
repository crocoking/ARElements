using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

namespace ARElements{

public class ScreenSpaceOutliner : MonoBehaviour
{
	protected struct RendererData
	{
		public Renderer renderer;

		public Material material;

		public int submeshIndex;
	}

	private static HashSet<ScreenSpaceOutliner> s_Outliners = new HashSet<ScreenSpaceOutliner>();

	private static Shader s_OpaqueShader;

	private Material m_OpaqueMaterial;

	private Color m_Color;

	protected List<RendererData> m_MeshData;

	private bool m_RenderersDirty;

	public static Shader opaqueShader
	{
		get
		{
			if (s_OpaqueShader == null)
			{
				s_OpaqueShader = Shader.Find("Screen Space Outline/Opaque");
			}
			return s_OpaqueShader;
		}
	}

	private Material opaqueMaterial
	{
		get
		{
			if (m_OpaqueMaterial == null)
			{
				m_OpaqueMaterial = new Material(opaqueShader);
			}
			return m_OpaqueMaterial;
		}
	}

	public Color color
	{
		get
		{
			return m_Color;
		}
		set
		{
			m_Color = value;
			opaqueMaterial.SetColor("_Color", m_Color);
		}
	}

	private void OnEnable()
	{
		s_Outliners.Add(this);
	}

	private void OnDisable()
	{
		s_Outliners.Remove(this);
	}

	private void Start()
	{
		Initialize();
	}

	private void Initialize()
	{
		m_MeshData = new List<RendererData>();
		Renderer[] componentsInChildren = base.gameObject.GetComponentsInChildren<Renderer>();
		foreach (Renderer renderer in componentsInChildren)
		{
			if (!renderer.enabled)
			{
				continue;
			}
			Material[] sharedMaterials = renderer.sharedMaterials;
			for (int j = 0; j < sharedMaterials.Length; j++)
			{
				Material material = sharedMaterials[j];
				if ((bool)material && material.GetTag("RenderType", searchFallbacks: true, string.Empty) == "Opaque")
				{
					RendererData item = default(RendererData);
					item.renderer = renderer;
					item.material = material;
					item.submeshIndex = j;
					m_MeshData.Add(item);
				}
			}
		}
	}

	private void FillBufferInternal(CommandBuffer buffer)
	{
		for (int i = 0; i < m_MeshData.Count; i++)
		{
			RendererData rendererData = m_MeshData[i];
			buffer.DrawRenderer(rendererData.renderer, opaqueMaterial, rendererData.submeshIndex);
		}
	}

	public static void FillBuffer(CommandBuffer buffer)
	{
		HashSet<ScreenSpaceOutliner>.Enumerator enumerator = s_Outliners.GetEnumerator();
		while (enumerator.MoveNext())
		{
			enumerator.Current.FillBufferInternal(buffer);
		}
	}
}
}