using System;
using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

public class SingleItemPlacement : MonoBehaviour
{
	private enum UIState
	{
		FindTable,
		PlaneDetection,
		PlaceAndConfirm,
		AfterPlacement
	}

	public GameObject rootUI;

	public GameObject findTableUI;

	public GameObject planeDetectionUI;

	public GameObject placeAndConfirmUI;

	public TranslationController singleItemForPlacement;

	public GameObject singleItemAfterPlacement;

	private UIState m_UIState;

	private void Start()
	{
		StartFindingTable();
		Button[] componentsInChildren = findTableUI.GetComponentsInChildren<Button>();
		if (componentsInChildren.Length != 1)
		{
			throw new Exception("Expected one and only one button in " + findTableUI);
		}
		componentsInChildren[0].onClick.AddListener(StartPlaneDetection);
		Button[] componentsInChildren2 = placeAndConfirmUI.GetComponentsInChildren<Button>();
		if (componentsInChildren2.Length != 1)
		{
			throw new Exception("Expected one and only one button in " + placeAndConfirmUI);
		}
		componentsInChildren2[0].onClick.AddListener(StartAfterPlacement);
	}

	private void Update()
	{
		switch (m_UIState)
		{
		case UIState.PlaneDetection:
			ContinuePlaneDetection();
			break;
		case UIState.PlaceAndConfirm:
			ContinuePlaceAndConfirm();
			break;
		}
	}

	private void StartFindingTable()
	{
		m_UIState = UIState.FindTable;
		rootUI.SetActive(value: true);
		findTableUI.SetActive(value: true);
		planeDetectionUI.SetActive(value: false);
		placeAndConfirmUI.SetActive(value: false);
		singleItemForPlacement.gameObject.SetActive(value: false);
		singleItemAfterPlacement.SetActive(value: false);
	}

	private void StartPlaneDetection()
	{
		m_UIState = UIState.PlaneDetection;
		rootUI.SetActive(value: true);
		findTableUI.SetActive(value: false);
		planeDetectionUI.SetActive(value: true);
		placeAndConfirmUI.SetActive(value: false);
		singleItemForPlacement.gameObject.SetActive(value: false);
		singleItemAfterPlacement.SetActive(value: false);
	}

	private void StartPlaceAndConfirm()
	{
		m_UIState = UIState.PlaceAndConfirm;
		rootUI.SetActive(value: true);
		findTableUI.SetActive(value: false);
		planeDetectionUI.SetActive(value: false);
		placeAndConfirmUI.SetActive(value: true);
		singleItemForPlacement.gameObject.SetActive(value: true);
		singleItemAfterPlacement.SetActive(value: false);
		singleItemForPlacement.StartTranslation(singleItemForPlacement.transform.position.y);
		singleItemForPlacement.ContinueTranslationImmediate(new Vector2(Screen.width, Screen.height) * 0.5f);
		singleItemForPlacement.EndTranslation();
		ContinuePlaceAndConfirm();
	}

	private void StartAfterPlacement()
	{
		m_UIState = UIState.AfterPlacement;
		rootUI.SetActive(value: false);
		findTableUI.SetActive(value: false);
		planeDetectionUI.SetActive(value: false);
		placeAndConfirmUI.SetActive(value: false);
		singleItemForPlacement.gameObject.SetActive(value: false);
		singleItemAfterPlacement.SetActive(value: true);
		singleItemAfterPlacement.transform.SetPositionAndRotation(singleItemForPlacement.transform.position, singleItemForPlacement.transform.rotation);
		singleItemAfterPlacement.transform.localScale = singleItemAfterPlacement.transform.localScale;
	}

	private void ContinuePlaceAndConfirm()
	{
	}

	private void ContinuePlaneDetection()
	{
		if (RaycastUtilities.GetCenterScreenRaycastResult(Camera.main, out var hit))
		{
			singleItemForPlacement.transform.position = hit.Pose.position;
			singleItemForPlacement.transform.LookAt(Camera.main.transform);
			singleItemForPlacement.transform.rotation = Quaternion.Euler(0f, singleItemForPlacement.transform.rotation.eulerAngles.y, singleItemForPlacement.transform.rotation.eulerAngles.z);
			StartPlaceAndConfirm();
		}
	}
}
}
