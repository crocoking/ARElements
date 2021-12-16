using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements{

public class DragEventProxy : MonoBehaviour, IBeginDragHandler, IEndDragHandler, IDragHandler, IEventSystemHandler
{
	public MonoBehaviour dragHandler;

	private bool m_IsDragging;

	public bool IsDragging => m_IsDragging;

	private void Update()
	{
	}

	private void OnEnable()
	{
		m_IsDragging = false;
	}

	public void OnBeginDrag(PointerEventData eventData)
	{
		m_IsDragging = true;
		if (dragHandler is IBeginDragHandler beginDragHandler)
		{
			beginDragHandler.OnBeginDrag(eventData);
		}
	}

	public void OnDrag(PointerEventData eventData)
	{
		if (this.dragHandler is IDragHandler dragHandler)
		{
			dragHandler.OnDrag(eventData);
		}
	}

	public void OnEndDrag(PointerEventData eventData)
	{
		m_IsDragging = false;
		if (dragHandler is IEndDragHandler endDragHandler)
		{
			endDragHandler.OnEndDrag(eventData);
		}
	}
}
}
