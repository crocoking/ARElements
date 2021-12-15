using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

namespace ARElements{

public class SelectableItem : CoordinatorReceiver
{
	public UnityEvent onSelected = new UnityEvent();

	public UnityEvent onDeselected = new UnityEvent();

	public bool isSelectable = true;

	public bool useSelectionVisual = true;

	public virtual bool isBusy => false;

	public bool isSelected => GetCoordinator<SelectionCoordinator>().SelectedItem == this;

	public bool TrySelect()
	{
		SelectionCoordinator coordinator = GetCoordinator<SelectionCoordinator>();
		if (coordinator == null)
		{
			return false;
		}
		return coordinator.TrySelectItem(this);
	}

	public bool TryDeselect()
	{
		if (!isSelected)
		{
			return false;
		}
		SelectionCoordinator coordinator = GetCoordinator<SelectionCoordinator>();
		if (coordinator == null)
		{
			return false;
		}
		return coordinator.TryClearSelectedItem();
	}

	protected void ForwardEventToParent(PointerEventData eventData)
	{
		ExecuteEvents.Execute(base.transform.parent.gameObject, eventData, ExecuteEvents.pointerClickHandler);
	}

	public virtual void OnDeselected()
	{
		if (onDeselected != null)
		{
			onDeselected.Invoke();
		}
	}

	public void OnSelected()
	{
		if (onSelected != null)
		{
			onSelected.Invoke();
		}
	}

	public ITrackedPlane GetPlane()
	{
		Ray ray = new Ray(base.transform.position + Vector3.up * 0.01f, Vector3.down);
		if (ElementsSystem.instance.planeManager.Raycast(ray, out var hit))
		{
			return hit.plane;
		}
		return null;
	}
}
}
