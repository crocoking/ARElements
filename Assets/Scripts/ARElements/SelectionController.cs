using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(SelectableItem))]
public class SelectionController : CoordinatorReceiver
{
	private SelectableItem m_SelectableItem;

	private void Awake()
	{
		m_SelectableItem = GetComponent<SelectableItem>();
		GestureCoordinator coordinator = GetCoordinator<GestureCoordinator>();
		if (coordinator != null && coordinator.tapGestureRecognizer != null)
		{
			coordinator.tapGestureRecognizer.onGestureStarted += OnGestureStarted;
		}
	}

	private void OnDestroy()
	{
		GestureCoordinator coordinator = GetCoordinator<GestureCoordinator>();
		if (coordinator != null && coordinator.tapGestureRecognizer != null)
		{
			coordinator.tapGestureRecognizer.onGestureStarted -= OnGestureStarted;
		}
	}

	private void OnGestureStarted(BaseGesture gesture)
	{
		gesture.onFinished += OnFinished;
	}

	private void OnFinished(BaseGesture gesture)
	{
		if (gesture.wasCancelled)
		{
			return;
		}
		if (gesture.targetObject != null)
		{
			SelectableItem componentInParent = gesture.targetObject.GetComponentInParent<SelectableItem>();
			if (componentInParent == m_SelectableItem)
			{
				if (componentInParent.isSelected)
				{
					componentInParent.TryDeselect();
				}
				else
				{
					componentInParent.TrySelect();
				}
			}
			else if (componentInParent == null)
			{
				ClearSelectedItem();
			}
		}
		else
		{
			ClearSelectedItem();
		}
	}

	private void ClearSelectedItem()
	{
		SelectionCoordinator coordinator = GetCoordinator<SelectionCoordinator>();
		coordinator.TryClearSelectedItem();
	}
}
}
