using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements{

public class MenuItem : MonoBehaviour, IBeginDragHandler, IDragHandler, IEndDragHandler, IPointerClickHandler, IEventSystemHandler
{
	public delegate void HandleItemBeginDrag(MenuItem item, PointerEventData eventData);

	public delegate void HandleItemDrag(MenuItem item, PointerEventData eventData);

	public delegate void HandleItemEndDrag(MenuItem item, PointerEventData eventData);

	public delegate void HandleItemClick(MenuItem item);

	public MenuItemData itemData;

	public HandleItemBeginDrag beginDragHandler;

	public HandleItemDrag dragHandler;

	public HandleItemEndDrag endDragHandler;

	public HandleItemClick clickHandler;

	public void OnBeginDrag(PointerEventData eventData)
	{
		beginDragHandler(this, eventData);
	}

	public void OnDrag(PointerEventData eventData)
	{
		dragHandler(this, eventData);
	}

	public void OnEndDrag(PointerEventData eventData)
	{
		endDragHandler(this, eventData);
	}

	public void OnPointerClick(PointerEventData eventData)
	{
		clickHandler(this);
	}
}
}
