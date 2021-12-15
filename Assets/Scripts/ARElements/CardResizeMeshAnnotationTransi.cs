using UnityEngine;

namespace ARElements{

[ExecuteInEditMode]
public class CardResizeMeshAnnotationTransition : BaseMeshAnnotationTransition
{
	[Tooltip("Mesh card that we'll morph between different sizes using a vertex animation. You must use our custom mesh morph material.")]
	public MeshRenderer cardMeshRenderer;

	[Tooltip("Mesh filter is used for adjusting the bouding box to avoid screen clipping.")]
	public MeshFilter cardMeshFilter;

	[Tooltip("Speed of the mesh card resize.")]
	public float cardResizeSpeed = 2f;

	public Vector2 m_SmallSize = new Vector2(1f, 1f);

	public Vector2 m_MediumSize = new Vector2(2f, 1f);

	public Vector2 m_LargeSize = new Vector2(3f, 2f);

	private Vector2 m_BeginSize;

	private Vector2 m_CurrentSize;

	private Vector2 m_TargetSize;

	private MaterialPropertyBlock m_PropertyBlock;

	private void Awake()
	{
		m_PropertyBlock = new MaterialPropertyBlock();
	}

	private void Start()
	{
		if (cardMeshFilter != null)
		{
			cardMeshFilter.sharedMesh.bounds = new Bounds(Vector3.zero, new Vector3(m_LargeSize.x * 3f, m_LargeSize.y * 3f, m_LargeSize.x * 3f));
		}
	}

	public override void TransitionToViewSize(AnnotationData annotationData, AnnotationViewSize nextAnnotationViewSize)
	{
		if (cardMeshRenderer == null)
		{
			Debug.LogError("Can't transition without mesh renderer");
			return;
		}
		switch (nextAnnotationViewSize)
		{
		case AnnotationViewSize.Hidden:
			m_TargetSize = Vector2.zero;
			break;
		case AnnotationViewSize.Small:
			m_TargetSize = m_SmallSize;
			break;
		case AnnotationViewSize.Medium:
			m_TargetSize = m_MediumSize;
			break;
		case AnnotationViewSize.Large:
			m_TargetSize = m_LargeSize;
			break;
		}
		m_TargetSize.x -= 1f;
		m_TargetSize.y -= 1f;
		base.viewSize = nextAnnotationViewSize;
		SetAnnotationColor(annotationData.cardColor);
		cardMeshRenderer.SetPropertyBlock(m_PropertyBlock);
	}

	private void Update()
	{
		if (!(cardMeshRenderer == null))
		{
			if (m_PropertyBlock == null)
			{
				m_PropertyBlock = new MaterialPropertyBlock();
			}
			ContinueVertexResizeAnimation();
			cardMeshRenderer.SetPropertyBlock(m_PropertyBlock);
		}
	}

	private void SetAnnotationColor(Color c)
	{
		if (m_PropertyBlock != null)
		{
			m_PropertyBlock.SetColor("_Color", c);
		}
	}

	private void ContinueVertexResizeAnimation()
	{
		if (base.viewSize == AnnotationViewSize.Hidden)
		{
			if (cardMeshRenderer.enabled)
			{
				cardMeshRenderer.enabled = false;
			}
			m_CurrentSize = Vector2.zero;
			return;
		}
		if (!cardMeshRenderer.enabled)
		{
			cardMeshRenderer.enabled = true;
		}
		float num = Mathf.MoveTowards(m_CurrentSize.x, m_TargetSize.x, cardResizeSpeed * Time.deltaTime);
		float num2 = Mathf.MoveTowards(m_CurrentSize.y, m_TargetSize.y, cardResizeSpeed * Time.deltaTime);
		m_PropertyBlock.SetFloat("_Width", num);
		m_PropertyBlock.SetFloat("_Height", num2);
		m_CurrentSize = new Vector2(num, num2);
		cardMeshRenderer.SetPropertyBlock(m_PropertyBlock);
	}
}
}
