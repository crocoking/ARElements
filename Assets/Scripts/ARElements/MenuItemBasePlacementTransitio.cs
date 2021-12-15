using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements{

public abstract class MenuItemBasePlacementTransition : MonoBehaviour
{
	public abstract void BeginPlacement(MenuItem item, PointerEventData eventData);

	public abstract void ContinuePlacement(MenuItem item, PointerEventData eventData);

	public abstract bool EndPlacement(MenuItem item, PointerEventData eventData);

	public abstract void CancelPlacement(MenuItem item, PointerEventData eventData);

	public abstract bool IsBusyTransitioning();
}
}
