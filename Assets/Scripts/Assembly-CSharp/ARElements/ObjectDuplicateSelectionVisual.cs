using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements{

public class ObjectDuplicateSelectionVisualizer : BaseSelectionVisualizer
{
	public Material selectionMaterial;

	protected GameObject m_DuplicateObject;

	public override void ApplySelectionVisual(SelectableItem item)
	{
		Transform transform = item.gameObject.transform;
		m_DuplicateObject = Object.Instantiate(item.gameObject, transform.position, transform.rotation, transform);
		m_DuplicateObject.transform.localScale = Vector3.one;
		MeshRenderer componentInChildren = m_DuplicateObject.GetComponentInChildren<MeshRenderer>();
		if (componentInChildren == null)
		{
			return;
		}
		MonoBehaviour[] componentsInChildren = m_DuplicateObject.GetComponentsInChildren<MonoBehaviour>(includeInactive: true);
		foreach (MonoBehaviour monoBehaviour in componentsInChildren)
		{
			if (monoBehaviour != componentInChildren)
			{
				monoBehaviour.enabled = false;
			}
		}
		Transform transform2 = m_DuplicateObject.transform.Find("Shadow");
		if (transform2 != null)
		{
			transform2.gameObject.SetActive(value: false);
		}
		Collider[] componentsInChildren2 = m_DuplicateObject.GetComponentsInChildren<Collider>(includeInactive: true);
		foreach (Collider collider in componentsInChildren2)
		{
			collider.enabled = false;
		}
		List<Material> list = new List<Material>();
		for (int k = 0; k < componentInChildren.sharedMaterials.Length; k++)
		{
			list.Add(selectionMaterial);
		}
		componentInChildren.materials = list.ToArray();
		EventSystem.current.SetSelectedGameObject(item.gameObject);
	}

	public override void RemoveSelectionVisual(SelectableItem item)
	{
		Object.Destroy(m_DuplicateObject);
		m_DuplicateObject = null;
	}
}
}
