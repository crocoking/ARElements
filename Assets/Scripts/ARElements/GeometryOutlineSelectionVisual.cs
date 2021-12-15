using UnityEngine;

namespace ARElements{

public class GeometryOutlineSelectionVisualizer : ObjectDuplicateSelectionVisualizer
{
	[Tooltip("The color of the geometry outline.")]
	public Color outlineColor;

	[Tooltip("The thickness of the geometry outline.")]
	[Range(0.001f, 0.015f)]
	public float outlineThickness = 0.01f;

	[Range(0f, 1f)]
	[Tooltip("The light estimation scale of the geometry outline.")]
	public float lightEstimationScale;

	private float m_TransitionCompletion = 1f;

	public float transitionCompletion
	{
		get
		{
			return m_TransitionCompletion;
		}
		set
		{
			m_TransitionCompletion = value;
			MeshRenderer componentInChildren = m_DuplicateObject.GetComponentInChildren<MeshRenderer>();
			if (componentInChildren != null)
			{
				for (int i = 0; i < componentInChildren.materials.Length; i++)
				{
					componentInChildren.materials[i].SetFloat("_Completion", m_TransitionCompletion);
				}
			}
		}
	}

	private void ApplySettings()
	{
		Shader.SetGlobalFloat("_GlobalLightEstimationScale", lightEstimationScale);
		MeshRenderer componentInChildren = m_DuplicateObject.GetComponentInChildren<MeshRenderer>();
		for (int i = 0; i < componentInChildren.materials.Length; i++)
		{
			componentInChildren.materials[i].SetColor("_OutlineColor", outlineColor);
			componentInChildren.materials[i].SetFloat("_Outline", outlineThickness);
		}
	}

	public override void ApplySelectionVisual(SelectableItem item)
	{
		base.ApplySelectionVisual(item);
		ApplySettings();
	}
}
}
