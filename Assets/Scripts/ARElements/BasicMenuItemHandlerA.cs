using UnityEngine;
using UnityEngine.UI;

namespace ARElements
{

	public class BasicMenuItemHandlerA : MenuItemHandler
	{
		public override void PrepareMenuItemThumbnail(GameObject thumnailObj, MenuItemData itemData)
		{
			Image component = thumnailObj.transform.Find("Image").GetComponent<Image>();
			component.sprite = itemData.thumbnailImage;
			component.type = Image.Type.Simple;
			Text componentInChildren = thumnailObj.GetComponentInChildren<Text>();
			componentInChildren.text = itemData.title;
		}

		public override void DidSelectMenuItem(MenuItem item)
		{
			SelectionCoordinator selectionCoordinator = ElementsSystem.instance.selectionCoordinator;
			if (selectionCoordinator.SelectedItem != null)
			{
				selectionCoordinator.TryClearSelectedItem();
				return;
			}
			PlaneFocusController planeFocusController = ElementsSystem.instance.planeFocusController;
			if (planeFocusController.focusPoints.Count > 0)
			{
				PlaneFocusPoint planeFocusPoint = planeFocusController.focusPoints[0];
				Camera main = Camera.main;
				GameObject gameObject = Object.Instantiate(item.itemData.objectPrefab, selectionCoordinator.transform);
				gameObject.transform.localPosition = Vector3.zero;
				if (item.itemData.modelPrefab != null)
				{
					Object.Instantiate(item.itemData.modelPrefab, Vector3.zero, Quaternion.identity, gameObject.transform);
				}
				SelectableItem componentInChildren = gameObject.GetComponentInChildren<SelectableItem>();
				componentInChildren.transform.position = planeFocusPoint.worldPoint;
				componentInChildren.transform.LookAt(main.transform, Vector3.up);
				componentInChildren.transform.rotation = Quaternion.Euler(0f, componentInChildren.transform.rotation.eulerAngles.y, 0f);
				componentInChildren.TrySelect();
				Menu menu = Object.FindObjectOfType<Menu>();
				menu.cancelForcedDrag();
			}
			else
			{
				Debug.LogError("Can't place an item without a focus point.");
			}
		}
	}
}
