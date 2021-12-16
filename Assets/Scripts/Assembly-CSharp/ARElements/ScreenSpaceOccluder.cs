using System.Collections.Generic;
using UnityEngine.Rendering;

namespace ARElements{

public class ScreenSpaceOccluder : ScreenSpaceOutliner
{
	private static HashSet<ScreenSpaceOccluder> s_Occluders = new HashSet<ScreenSpaceOccluder>();

	public static int count => s_Occluders.Count;

	private void OnEnable()
	{
		s_Occluders.Add(this);
	}

	private void OnDisable()
	{
		s_Occluders.Remove(this);
	}

	private void FillBufferInternal(CommandBuffer buffer)
	{
		for (int i = 0; i < m_MeshData.Count; i++)
		{
			RendererData rendererData = m_MeshData[i];
			buffer.DrawRenderer(rendererData.renderer, rendererData.material, rendererData.submeshIndex, 0);
		}
	}

	public new static void FillBuffer(CommandBuffer buffer)
	{
		HashSet<ScreenSpaceOccluder>.Enumerator enumerator = s_Occluders.GetEnumerator();
		while (enumerator.MoveNext())
		{
			enumerator.Current.FillBufferInternal(buffer);
		}
	}
}
}
