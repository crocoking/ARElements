using UnityEngine;

namespace ARElements{

public class DirectPlacer : MonoBehaviour
{
	public GameObject ModelPrefab;

	public GameObject FunctionalityTemplate;

	public int MaxObjects = 1;

	public int PlacedObjects;

	private bool m_MouseActive;

	private void Start()
	{
		if (FunctionalityTemplate == null)
		{
			FunctionalityTemplate = new GameObject();
		}
	}

	private void Update()
	{
		if (Input.touchCount > 0)
		{
			Touch touch = Input.touches[0];
			if (touch.phase == TouchPhase.Began && PlacedObjects < MaxObjects)
			{
				Ray ray = Camera.main.ScreenPointToRay(touch.position);
				if (ElementsSystem.instance.planeManager.Raycast(ray, out var hit))
				{
					PlaceItem(ModelPrefab, FunctionalityTemplate, hit.point);
				}
			}
		}
		if (!Application.isEditor)
		{
			return;
		}
		if (Input.GetMouseButtonDown(0))
		{
			if (!m_MouseActive && PlacedObjects < MaxObjects)
			{
				Ray ray2 = Camera.main.ScreenPointToRay(Input.mousePosition);
				if (ElementsSystem.instance.planeManager.Raycast(ray2, out var hit2))
				{
					PlaceItem(ModelPrefab, FunctionalityTemplate, hit2.point);
				}
			}
		}
		else
		{
			m_MouseActive = false;
		}
	}

	public void PlaceItem(GameObject modelPrefab, GameObject functionalityTemplate, Vector3 placementPosition = default(Vector3))
	{
		SelectionCoordinator selectionCoordinator = ElementsSystem.instance.selectionCoordinator;
		if (selectionCoordinator.SelectedItem != null)
		{
			selectionCoordinator.TryClearSelectedItem();
			return;
		}
		GameObject gameObject = Object.Instantiate(functionalityTemplate, selectionCoordinator.transform);
		gameObject.transform.localPosition = Vector3.zero;
		if (modelPrefab != null)
		{
			Object.Instantiate(modelPrefab, Vector3.zero, Quaternion.identity, gameObject.transform);
		}
		SelectableItem componentInChildren = gameObject.GetComponentInChildren<SelectableItem>();
		componentInChildren.transform.position = placementPosition;
		componentInChildren.transform.LookAt(Camera.main.transform, Vector3.up);
		componentInChildren.transform.rotation = Quaternion.Euler(0f, componentInChildren.transform.rotation.eulerAngles.y, 0f);
		componentInChildren.TrySelect();
		PlacedObjects++;
	}
}
}
