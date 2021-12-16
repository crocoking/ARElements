using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements{

public class MenuItemPlacementTransition : MenuItemBasePlacementTransition
{
	private Camera m_Camera;

	private bool m_IsBusy;

	private const float k_InvalidPlacementDepth = 3f;

	private GameObject m_PlacedObject;

	public override void BeginPlacement(MenuItem item, PointerEventData eventData)
	{
		if (m_PlacedObject != null)
		{
			Debug.LogError("Can't begin placement since there's already an object busy");
			return;
		}
		SelectionCoordinator selectionCoordinator = ElementsSystem.instance.selectionCoordinator;
		if (selectionCoordinator.TryClearSelectedItem())
		{
			m_Camera = Camera.main;
			m_IsBusy = true;
			m_PlacedObject = Object.Instantiate(item.itemData.objectPrefab, selectionCoordinator.transform);
			m_PlacedObject.transform.localPosition = Vector3.zero;
			if (item.itemData.modelPrefab != null)
			{
				Object.Instantiate(item.itemData.modelPrefab, Vector3.zero, Quaternion.identity, m_PlacedObject.transform);
			}
			SelectableItem componentInChildren = m_PlacedObject.GetComponentInChildren<SelectableItem>();
			componentInChildren.transform.position = m_Camera.transform.position + m_Camera.transform.forward;
			componentInChildren.transform.LookAt(m_Camera.transform, Vector3.up);
			componentInChildren.transform.rotation = Quaternion.Euler(0f, componentInChildren.transform.rotation.eulerAngles.y, 0f);
			TranslationController component = m_PlacedObject.GetComponent<TranslationController>();
			component.StartTranslation(GetInitialGroundingPlaneHeight());
			component.ContinueTranslationImmediate(eventData.position);
			component.placedOnNewPlane = true;
			componentInChildren.TrySelect();
		}
	}

	public override void ContinuePlacement(MenuItem item, PointerEventData eventData)
	{
		if (m_PlacedObject == null)
		{
			Debug.LogError("Can't continue placement transition without object");
			return;
		}
		TranslationController component = m_PlacedObject.GetComponent<TranslationController>();
		component.ContinueTranslation(eventData.position);
	}

	public override bool EndPlacement(MenuItem item, PointerEventData eventData = null)
	{
		TranslationController component = m_PlacedObject.GetComponent<TranslationController>();
		if (!component.hasValidPosition)
		{
			CancelPlacement(item, eventData);
			return false;
		}
		component.EndTranslation();
		m_PlacedObject = null;
		m_IsBusy = false;
		return true;
	}

	public override void CancelPlacement(MenuItem item, PointerEventData eventData = null)
	{
		if (m_PlacedObject != null)
		{
			TranslationController component = m_PlacedObject.GetComponent<TranslationController>();
			component.EndTranslation();
			Object.Destroy(m_PlacedObject);
			m_PlacedObject = null;
		}
		m_IsBusy = false;
	}

	public override bool IsBusyTransitioning()
	{
		return m_IsBusy;
	}

	private float GetInitialGroundingPlaneHeight()
	{
		return (m_Camera.transform.position + m_Camera.transform.forward * 3f).y;
	}

	public void setPlacedObject(GameObject placedObject)
	{
		m_PlacedObject = placedObject;
	}

	public void clearPlacedObject()
	{
		m_PlacedObject = null;
	}
}
}
