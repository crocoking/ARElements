using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements{

public abstract class MenuItemBaseThumbnailTransition : MonoBehaviour
{
	public abstract void BeginThumnailDrag(MenuItem item, PointerEventData eventData);

	public abstract void ContinueThumbnailDrag(MenuItem item, PointerEventData eventData);

	public abstract void EndThumbnailDrag(MenuItem item, PointerEventData eventData);

	public abstract void CancelThumbnailDrag(MenuItem item, PointerEventData eventData);

	public abstract bool IsThumnailActionTriggered(MenuItem item, PointerEventData eventData);

	public abstract bool IsBusyTransitioning();
}
}
