using UnityEngine;

namespace ARElements{

public class FootprintOutlineSelectionVisualizer : BaseSelectionVisualizer
{
	[Tooltip("The prefab for the footprint geometry.")]
	public GameObject footprintPrefab;

	[Tooltip("The color of the footprint.")]
	public Color outlineColor;

	[Tooltip("The color to show when the item has an invalid transformation.")]
	public Color outlineColorInvalid = Color.red;

	[Range(0f, 2f)]
	[Tooltip("Offset applied to the size of the footprint.")]
	public float sizeOffset = 0.1f;

	[Tooltip("The height of the footprint.")]
	public float height = 0.01f;

	[Tooltip("The sharpness of the footprint corner.")]
	[Range(0f, 1f)]
	public float cornerSharpness;

	[Tooltip("The radius of the footprint corner.")]
	[Range(0.04f, 0.5f)]
	public float cornerRadius = 0.1f;

	[Tooltip("The thickness of the footprint stroke.")]
	[Range(0.01f, 0.05f)]
	public float strokeThickness = 0.02f;

	[Tooltip("The range of the front indicator.")]
	[Range(0f, 1f)]
	public float frontIndicatorRange = 0.25f;

	[Tooltip("The opacity of the front indicator.")]
	[Range(0f, 1f)]
	public float frontIndicatorOpacity = 0.25f;

	[Tooltip("The length of the front arrow.")]
	public float frontArrowLength;

	[Tooltip("The width of the front arrow.")]
	public float frontArrowWidth;

	[Range(1f, 10f)]
	[Tooltip("The length of the front arrow.")]
	public float frontArrowShape = 1f;

	[Range(0f, 1f)]
	[Tooltip("Percentage of final size at the beginning of the scale transition.")]
	public float minimumScale = 0.75f;

	[Range(0f, 1f)]
	[Tooltip("How square the footprint will be at the beginning of the scale transition.")]
	public float startingScaleUniformity = 0.75f;

	private GameObject m_Footprint;

	private MeshRenderer m_FootprintRenderer;

	private MaterialPropertyBlock m_FootprintPropertyBlock;

	private SelectableItem m_SelectedItem;

	private TransformableItem m_SelectedTransformableItem;

	private MeshFilter m_SelectedMeshFilter;

	private float m_CurrentCompletion;

	private Color m_CurrentColor;

	private float m_Width;

	private float m_Length;

	private int m_ColorId;

	private int m_WidthId;

	private int m_LengthId;

	private int m_HeightId;

	private int m_SharpnessId;

	private int m_RadiusId;

	private int m_ThicknessId;

	private int m_FrontIndicatorRangeId;

	private int m_FrontIndicatorOpacityId;

	private int m_FrontArrowLengthId;

	private int m_FrontArrowWidthId;

	private int m_FrontArrowShapeId;

	private int m_MinScaleId;

	private int m_StartingScaleUniformId;

	private int m_OpacityCompletionId;

	public override void ApplySelectionVisual(SelectableItem item)
	{
		m_SelectedItem = item;
		m_SelectedTransformableItem = m_SelectedItem as TransformableItem;
		m_SelectedMeshFilter = item.GetComponentInChildren<MeshFilter>(includeInactive: true);
		m_CurrentColor = outlineColor;
	}

	public override void RemoveSelectionVisual(SelectableItem item)
	{
		m_SelectedItem = null;
	}

	private void Awake()
	{
		m_FootprintPropertyBlock = new MaterialPropertyBlock();
		m_ColorId = Shader.PropertyToID("_Color");
		m_WidthId = Shader.PropertyToID("_Width");
		m_LengthId = Shader.PropertyToID("_Length");
		m_HeightId = Shader.PropertyToID("_Height");
		m_SharpnessId = Shader.PropertyToID("_Sharpness");
		m_RadiusId = Shader.PropertyToID("_Radius");
		m_ThicknessId = Shader.PropertyToID("_Thickness");
		m_FrontIndicatorRangeId = Shader.PropertyToID("_FrontIndicatorRange");
		m_FrontIndicatorOpacityId = Shader.PropertyToID("_FrontIndicatorOpacity");
		m_FrontArrowLengthId = Shader.PropertyToID("_FrontArrowLength");
		m_FrontArrowWidthId = Shader.PropertyToID("_FrontArrowWidth");
		m_FrontArrowShapeId = Shader.PropertyToID("_FrontArrowShape");
		m_MinScaleId = Shader.PropertyToID("_MinScale");
		m_StartingScaleUniformId = Shader.PropertyToID("_StartingScaleUniform");
		m_OpacityCompletionId = Shader.PropertyToID("_OpacityCompletion");
		CreateFootprint();
	}

	private void OnDestroy()
	{
		DestroyFootprint();
	}

	private void LateUpdate()
	{
		if (!m_Footprint)
		{
			CreateFootprint();
		}
		float b = ((!(m_SelectedItem != null)) ? 0f : 1f);
		m_CurrentCompletion = Mathf.Lerp(m_CurrentCompletion, b, Time.deltaTime * 12f);
		if (m_SelectedTransformableItem != null)
		{
			Color b2 = ((!m_SelectedTransformableItem.isTransformationValid) ? outlineColorInvalid : outlineColor);
			m_CurrentColor = Color.Lerp(m_CurrentColor, b2, Time.deltaTime * 12f);
		}
		if (m_SelectedMeshFilter != null && m_SelectedMeshFilter.sharedMesh != null)
		{
			Bounds bounds = m_SelectedMeshFilter.sharedMesh.bounds;
			Vector3 localScale = m_SelectedMeshFilter.transform.parent.localScale;
			m_Width = bounds.size.x * localScale.x + sizeOffset;
			m_Length = bounds.size.z * localScale.z + sizeOffset;
		}
		if (m_SelectedItem != null && m_Footprint != null)
		{
			Transform transform = m_Footprint.transform;
			Transform transform2 = m_SelectedItem.transform;
			transform.position = GetFootprintPosition();
			transform.eulerAngles = new Vector3(0f, transform2.eulerAngles.y, 0f);
			transform.localScale = transform2.localScale;
		}
		UpdateFootprint();
	}

	private void UpdateFootprint()
	{
		if (!(m_FootprintRenderer == null))
		{
			m_FootprintRenderer.GetPropertyBlock(m_FootprintPropertyBlock);
			m_FootprintPropertyBlock.SetColor(m_ColorId, m_CurrentColor);
			m_FootprintPropertyBlock.SetFloat(m_WidthId, m_Width);
			m_FootprintPropertyBlock.SetFloat(m_LengthId, m_Length);
			m_FootprintPropertyBlock.SetFloat(m_HeightId, height);
			m_FootprintPropertyBlock.SetFloat(m_SharpnessId, cornerSharpness);
			m_FootprintPropertyBlock.SetFloat(m_RadiusId, cornerRadius);
			m_FootprintPropertyBlock.SetFloat(m_ThicknessId, strokeThickness);
			m_FootprintPropertyBlock.SetFloat(m_FrontIndicatorRangeId, frontIndicatorRange);
			m_FootprintPropertyBlock.SetFloat(m_FrontIndicatorOpacityId, frontIndicatorOpacity);
			m_FootprintPropertyBlock.SetFloat(m_FrontArrowLengthId, frontArrowLength);
			m_FootprintPropertyBlock.SetFloat(m_FrontArrowWidthId, frontArrowWidth);
			m_FootprintPropertyBlock.SetFloat(m_FrontArrowShapeId, frontArrowShape);
			m_FootprintPropertyBlock.SetFloat(m_MinScaleId, minimumScale);
			m_FootprintPropertyBlock.SetFloat(m_StartingScaleUniformId, startingScaleUniformity);
			m_FootprintPropertyBlock.SetFloat(m_OpacityCompletionId, m_CurrentCompletion);
			m_FootprintRenderer.SetPropertyBlock(m_FootprintPropertyBlock);
			m_Footprint.SetActive(m_CurrentCompletion > 0.001f);
		}
	}

	private void CreateFootprint()
	{
		if (!(footprintPrefab == null) && !(m_Footprint != null))
		{
			Transform transform = base.transform;
			m_Footprint = Object.Instantiate(footprintPrefab, transform.position, transform.rotation, transform);
			m_FootprintRenderer = m_Footprint.GetComponent<MeshRenderer>();
			m_Footprint.SetActive(value: false);
		}
	}

	private void DestroyFootprint()
	{
		if (m_Footprint != null)
		{
			Object.Destroy(m_Footprint);
		}
	}

	private Vector3 GetFootprintPosition()
	{
		if (m_SelectedItem == null)
		{
			throw new UnityException("Cannot call GetFootprintPosition if there is no selected item.");
		}
		TranslationController component = m_SelectedItem.GetComponent<TranslationController>();
		if (component == null)
		{
			return m_SelectedItem.transform.position;
		}
		return component.FootprintPosition;
	}
}
}
