using System;
using System.Collections;
using System.Runtime.CompilerServices;
using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class SceneInitializer : MonoBehaviour
{
	public GameObject sceneRoot;

	public GameObject staticSceneRoot;

	public PlacematSetup placematSetupTemplate;

	private bool sceneRootIsPrefab
	{
		[CompilerGenerated]
		get
		{
			return (bool)sceneRoot && sceneRoot.scene != base.gameObject.scene;
		}
	}

	private void Start()
	{
		if ((bool)sceneRoot && !sceneRootIsPrefab)
		{
			sceneRoot.SetActive(value: false);
		}
		if ((bool)staticSceneRoot)
		{
			staticSceneRoot.SetActive(value: false);
		}
		if ((bool)SceneArea.current)
		{
			StartCoroutine(SetupSceneDelayed());
			return;
		}
		PlacematSetup placematSetup = UnityEngine.Object.Instantiate(placematSetupTemplate);
		placematSetup.onCommitted.AddListener(delegate
		{
			StartCoroutine(SetupSceneDelayed());
		});
		placematSetup.sceneRoot = sceneRoot;
	}

	private IEnumerator SetupSceneDelayed()
	{
		yield return null;
		SetupScene();
	}

	private void SetupScene()
	{
		if (!sceneRoot)
		{
			return;
		}
		Transform scenePivot = SceneArea.current.scenePivot;
		if (sceneRootIsPrefab)
		{
			throw new Exception("Prefabs not supported.");
		}
		sceneRoot.transform.SetParent(scenePivot, worldPositionStays: false);
		sceneRoot.transform.localPosition = Vector3.zero;
		sceneRoot.transform.localRotation = Quaternion.identity;
		sceneRoot.transform.localScale = Vector3.one;
		SelectableItem[] componentsInChildren = sceneRoot.GetComponentsInChildren<SelectableItem>();
		bool flag = true;
		SelectableItem[] array = componentsInChildren;
		foreach (SelectableItem selectableItem in array)
		{
			ScaleController component = selectableItem.gameObject.GetComponent<ScaleController>();
			if ((bool)component)
			{
				component.minScale *= SceneArea.current.scaleFactor;
				component.maxScale *= SceneArea.current.scaleFactor;
			}
			SelectionCoordinator selectionCoordinator = ElementsSystem.instance.selectionCoordinator;
			selectableItem.transform.parent = selectionCoordinator.transform;
			if (flag)
			{
				if (selectionCoordinator.SelectedItem != null)
				{
					selectionCoordinator.TryClearSelectedItem();
				}
				selectableItem.TrySelect();
			}
			flag = false;
		}
		sceneRoot.gameObject.SetActive(value: true);
		if ((bool)staticSceneRoot)
		{
			staticSceneRoot.SetActive(value: true);
		}
		SceneDescription sceneDescription = UnityEngine.Object.FindObjectOfType<SceneDescription>();
		if ((bool)sceneDescription?.pedestalContent)
		{
			SceneArea.current.pedestal.gameObject.SetActive(value: true);
			sceneDescription.pedestalContent.transform.SetParent(SceneArea.current.pedestalContentPivot, worldPositionStays: false);
			sceneDescription.pedestalContent.transform.localPosition = Vector3.zero;
			sceneDescription.pedestalContent.SetActive(value: true);
		}
	}
}
}
