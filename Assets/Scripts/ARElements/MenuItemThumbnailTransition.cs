using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace ARElements{

public class MenuItemThumbnailTransition : MenuItemBaseThumbnailTransition
{
	public float displayObjectThreshold = 120f;

	[Tooltip("Controls the size of the icon during a drag.")]
	public float scale = 3f;

	[Tooltip("Duration in seconds of scaling animation")]
	public float m_ScaleDuration = 0.25f;

	private bool m_IsMoving;

	private bool m_IsDragging;

	private MenuItem m_MenuItem;

	private Vector3 m_StartParentPosition;

	private Vector3 m_StartThumbnailPosition;

	private Vector3 m_TargetThumbnailPosition;

	private const float k_DefaultScale = 1f;

	private EasedFloat m_EasedScale = new EasedFloat(1f);

	private bool m_IsScaling = true;

	public override void BeginThumnailDrag(MenuItem item, PointerEventData eventData)
	{
		if (m_MenuItem != null && m_IsMoving)
		{
			m_MenuItem.transform.position = m_StartThumbnailPosition + CalculateParentOffset();
			m_MenuItem.transform.localScale = Vector3.one * 1f;
		}
		Transform parent = item.gameObject.transform.parent;
		if (parent != null)
		{
			item.gameObject.transform.SetSiblingIndex(parent.childCount - 1);
			m_StartParentPosition = parent.position;
		}
		m_MenuItem = item;
		m_IsDragging = true;
		m_IsMoving = true;
		m_StartThumbnailPosition = item.transform.position;
		m_EasedScale.FadeFromTo(1f, scale, m_ScaleDuration, Time.time);
		m_IsScaling = true;
	}

	public override void ContinueThumbnailDrag(MenuItem item, PointerEventData eventData)
	{
		m_TargetThumbnailPosition = eventData.position;
		if (IsPastDragThreshold(eventData.position))
		{
			HideThumbnail();
		}
		else
		{
			ShowThumbnail();
		}
	}

	public override void EndThumbnailDrag(MenuItem item, PointerEventData eventData)
	{
		m_EasedScale.JumpTo(1f);
		m_IsScaling = true;
		m_MenuItem.transform.position = (m_TargetThumbnailPosition = m_StartThumbnailPosition);
		m_IsDragging = false;
		ShowThumbnail();
	}

	public override void CancelThumbnailDrag(MenuItem item, PointerEventData eventData)
	{
		m_TargetThumbnailPosition = m_StartThumbnailPosition;
		m_IsDragging = false;
		m_EasedScale.ShortenedFadeTo(1f, m_ScaleDuration, Time.time);
		m_IsScaling = true;
		ShowThumbnail();
	}

	public override bool IsThumnailActionTriggered(MenuItem item, PointerEventData eventData)
	{
		return IsPastDragThreshold(eventData.position);
	}

	public override bool IsBusyTransitioning()
	{
		return m_IsMoving;
	}

	private bool IsPastDragThreshold(Vector3 touchPosition)
	{
		return (touchPosition - m_StartThumbnailPosition).y >= displayObjectThreshold;
	}

	private void Update()
	{
		AnimateScale();
		if (m_IsMoving)
		{
			PositionThumbnail();
		}
	}

	private void AnimateScale()
	{
		if (m_IsScaling && !(m_MenuItem == null))
		{
			m_MenuItem.transform.localScale = Vector3.one * m_EasedScale.ValueAtTime(Time.time);
			m_IsScaling = !m_EasedScale.IsCompleted(Time.time);
		}
	}

	private void PositionThumbnail()
	{
		Vector3 vector = CalculateParentOffset();
		m_MenuItem.transform.position = Vector3.Lerp(m_MenuItem.transform.position, m_TargetThumbnailPosition + vector, 0.2f);
		if (!m_IsDragging && Vector3.Distance(m_MenuItem.transform.position, m_TargetThumbnailPosition + vector) < 0.001f)
		{
			m_IsMoving = false;
		}
	}

	private void ShowThumbnail()
	{
		if (!(m_MenuItem == null))
		{
			m_MenuItem.transform.Find("Image").GetComponent<Image>().enabled = true;
		}
	}

	private void HideThumbnail()
	{
		if (!(m_MenuItem == null))
		{
			m_MenuItem.transform.Find("Image").GetComponent<Image>().enabled = false;
		}
	}

	private Vector3 CalculateParentOffset()
	{
		if (m_MenuItem == null || m_MenuItem.transform.parent == null)
		{
			return Vector3.zero;
		}
		return m_MenuItem.transform.parent.position - m_StartParentPosition;
	}
}
}
