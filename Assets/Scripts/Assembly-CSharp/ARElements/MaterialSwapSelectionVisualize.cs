using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class MaterialSwapSelectionVisualizer : BaseSelectionVisualizer
{
	public Material swapMaterial;

	private MeshRenderer m_selectedMeshRenderer;

	private List<Material> m_originalMaterials;

	public override void ApplySelectionVisual(SelectableItem item)
	{
		MeshRenderer componentInChildren = item.gameObject.GetComponentInChildren<MeshRenderer>();
		if (!(componentInChildren == null))
		{
			m_selectedMeshRenderer = componentInChildren;
			m_originalMaterials = new List<Material>(componentInChildren.sharedMaterials);
			List<Material> list = new List<Material>();
			for (int i = 0; i < m_selectedMeshRenderer.sharedMaterials.Length; i++)
			{
				list.Add(swapMaterial);
			}
			m_selectedMeshRenderer.materials = list.ToArray();
		}
	}

	public override void RemoveSelectionVisual(SelectableItem item)
	{
		if ((bool)m_selectedMeshRenderer)
		{
			m_selectedMeshRenderer.materials = m_originalMaterials.ToArray();
		}
	}
}
}
