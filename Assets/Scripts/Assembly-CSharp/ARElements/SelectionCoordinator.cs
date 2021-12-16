using UnityEngine;

namespace ARElements{

public class SelectionCoordinator : MonoBehaviour
{
	public delegate void SelectionEvent(SelectableItem item);

	public BaseSelectionVisualizer[] selectionVisualizers;

	public SelectionEvent onSelect;

	public SelectionEvent onDeselect;

	public SelectableItem SelectedItem { get; protected set; }

	public bool CanSelectItem(SelectableItem item)
	{
		if (item == null || SelectedItem == item)
		{
			return false;
		}
		if (SelectedItem != null && SelectedItem.isBusy)
		{
			return false;
		}
		if (!item.isSelectable)
		{
			return false;
		}
		return true;
	}

	public bool TrySelectItem(SelectableItem item)
	{
		if (!CanSelectItem(item))
		{
			return false;
		}
		HideSelectionVisual();
		SelectableItem selectedItem = SelectedItem;
		SelectedItem = item;
		if (selectedItem != null)
		{
			selectedItem.OnDeselected();
		}
		SelectedItem.OnSelected();
		ShowSelectionVisual();
		return true;
	}

	public bool TryClearSelectedItem()
	{
		if (SelectedItem == null)
		{
			return true;
		}
		if (SelectedItem.isBusy)
		{
			return false;
		}
		HideSelectionVisual();
		SelectableItem selectedItem = SelectedItem;
		SelectedItem = null;
		selectedItem.OnDeselected();
		return true;
	}

	private void Start()
	{
		if (selectionVisualizers == null || selectionVisualizers.Length == 0)
		{
			Debug.LogError("You must specify at least one selection visualizer.");
		}
	}

	private void ShowSelectionVisual()
	{
		if (selectionVisualizers == null || !SelectedItem)
		{
			return;
		}
		if (SelectedItem.useSelectionVisual)
		{
			for (int i = 0; i < selectionVisualizers.Length; i++)
			{
				BaseSelectionVisualizer baseSelectionVisualizer = selectionVisualizers[i];
				baseSelectionVisualizer.ApplySelectionVisual(SelectedItem);
			}
		}
		if (onSelect != null)
		{
			onSelect(SelectedItem);
		}
	}

	private void HideSelectionVisual()
	{
		if (selectionVisualizers != null && (bool)SelectedItem)
		{
			for (int i = 0; i < selectionVisualizers.Length; i++)
			{
				BaseSelectionVisualizer baseSelectionVisualizer = selectionVisualizers[i];
				baseSelectionVisualizer.RemoveSelectionVisual(SelectedItem);
			}
			if (onDeselect != null)
			{
				onDeselect(SelectedItem);
			}
		}
	}
}
}
