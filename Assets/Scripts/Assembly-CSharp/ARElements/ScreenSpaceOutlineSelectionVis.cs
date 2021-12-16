using UnityEngine;
using UnityEngine.SpatialTracking;

namespace ARElements{

public class ScreenSpaceOutlineSelectionVisualizer : BaseSelectionVisualizer
{
	[Tooltip("The color of the outline.")]
	public Color outlineColor;

	[Tooltip("The width of the outline.")]
	[Range(0f, 10f)]
	public int iteration = 4;

	[Range(0f, 3f)]
	[Tooltip("The spread of the blur.")]
	public float blurSpread = 0.65f;

	[Tooltip("The opacity of the blur.")]
	[Range(0f, 1f)]
	public float opacity = 0.3f;

	[Range(0f, 1f)]
	[Tooltip("The light estimation scale of the geometry outline.")]
	public float lightEstimationScale;

	[Range(0f, 1f)]
	[Tooltip("The transition time for the outline effect.")]
	public float transisionTime;

	private ScreenSpaceOutlineRenderer m_OutlineRenderer;

	private ScreenSpaceOutliner m_Outliner;

	private void Start()
	{
		FindOutlineRenderer();
		ApplySettings();
	}

	private void OnValidate()
	{
		ApplySettings();
	}

	private void FindOutlineRenderer()
	{
		if (m_OutlineRenderer != null)
		{
			return;
		}
		Camera camera = null;
		if (Application.isEditor)
		{
			camera = Camera.main;
		}
		else
		{
			Camera[] allCameras = Camera.allCameras;
			foreach (Camera camera2 in allCameras)
			{
				if (camera2.GetComponent<TrackedPoseDriver>() != null)
				{
					camera = camera2;
					break;
				}
			}
			if (camera == null)
			{
				Debug.LogError("No first person camera found on session component!");
				return;
			}
		}
		m_OutlineRenderer = camera.GetComponent<ScreenSpaceOutlineRenderer>();
		if (m_OutlineRenderer == null)
		{
			m_OutlineRenderer = camera.gameObject.AddComponent<ScreenSpaceOutlineRenderer>();
		}
	}

	private void ApplySettings()
	{
		Shader.SetGlobalFloat("_GlobalLightEstimationScale", lightEstimationScale);
		if (!(m_OutlineRenderer == null))
		{
			m_OutlineRenderer.iteration = iteration;
			m_OutlineRenderer.blurSpread = blurSpread;
			m_OutlineRenderer.opacity = opacity;
		}
	}

	public override void ApplySelectionVisual(SelectableItem item)
	{
		m_Outliner = item.GetComponentInChildren<ScreenSpaceOutliner>();
		if (m_Outliner == null)
		{
			m_Outliner = item.gameObject.AddComponent<ScreenSpaceOutliner>();
		}
		m_Outliner.color = outlineColor;
		m_Outliner.enabled = true;
	}

	public override void RemoveSelectionVisual(SelectableItem item)
	{
		if ((bool)m_Outliner)
		{
			m_Outliner.enabled = false;
		}
	}
}
}
