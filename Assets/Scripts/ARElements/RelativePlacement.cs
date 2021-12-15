using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(RectTransform))]
public class RelativePlacement : MonoBehaviour
{
	[Tooltip("Position will be set relative to this transform")]
	[SerializeField]
	private RectTransform m_RelativeTransform;

	[Tooltip("The vertical position will be maintained at the top of relativeTransform offset by this value")]
	[SerializeField]
	private float m_VerticalInsetDistance;

	[SerializeField]
	[Tooltip("The Horizontal position will be maintained at the center of relativeTransform offset by this value")]
	private float m_HorizontalInsetDistance;

	private Canvas m_Canvas;

	private RectTransform m_Parent;

	private RectTransform m_rectTransform;

	public RectTransform relativeTransform
	{
		get
		{
			return m_RelativeTransform;
		}
		set
		{
			m_RelativeTransform = value;
		}
	}

	public float verticalInsetDistance
	{
		get
		{
			return m_VerticalInsetDistance;
		}
		set
		{
			m_VerticalInsetDistance = value;
		}
	}

	public float horizontalInsetDistance
	{
		get
		{
			return m_HorizontalInsetDistance;
		}
		set
		{
			m_HorizontalInsetDistance = value;
		}
	}

	private void Start()
	{
		m_Canvas = GetComponentInParent<Canvas>();
		m_Parent = base.transform.parent as RectTransform;
		m_rectTransform = base.transform as RectTransform;
	}

	private void LateUpdate()
	{
		float num = m_RelativeTransform.position.y / m_Canvas.transform.localScale.y + m_RelativeTransform.rect.yMax;
		float num2 = m_Parent.position.y / m_Canvas.transform.localScale.y + m_Parent.rect.yMin;
		float inset = num - num2 - m_VerticalInsetDistance;
		float height = m_rectTransform.rect.height;
		m_rectTransform.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Bottom, inset, height);
		RectTransform rectTransform = (RectTransform)m_Canvas.transform;
		float inset2 = (rectTransform.rect.width - m_rectTransform.rect.width) / 2f + m_HorizontalInsetDistance;
		m_rectTransform.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Left, inset2, m_rectTransform.rect.width);
	}
}
}
