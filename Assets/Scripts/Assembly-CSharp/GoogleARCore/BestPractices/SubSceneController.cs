using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace GoogleARCore.BestPractices{

public class SubSceneController : MonoBehaviour
{
	public List<Transform> subSceneRoots = new List<Transform>();

	public List<string> shortDescriptionTexts = new List<string>();

	public List<string> descriptionTexts = new List<string>();

	public int currentSubSceneIndex { get; private set; }

	public bool isFirstSubScene
	{
		[CompilerGenerated]
		get
		{
			return currentSubSceneIndex <= 0;
		}
	}

	public bool isLastSubScene
	{
		[CompilerGenerated]
		get
		{
			return currentSubSceneIndex >= subSceneRoots.Count - 1;
		}
	}

	public SubSceneController()
	{
		currentSubSceneIndex = -1;
	}

	private void Awake()
	{
		foreach (Transform subSceneRoot in subSceneRoots)
		{
			subSceneRoot.gameObject.SetActive(value: false);
		}
		int newSceneIndex = 0;
		List<string> sceneNameHistory = SceneArea.current.sceneNameHistory;
		if (sceneNameHistory.Count > 1)
		{
			string sceneName = sceneNameHistory[sceneNameHistory.Count - 2];
			int sceneInfoIndex = SceneArea.current.sceneInfoCollection.GetSceneInfoIndex(sceneName);
			int sceneInfoIndex2 = SceneArea.current.sceneInfoCollection.GetSceneInfoIndex(SceneManager.GetActiveScene().name);
			if (sceneInfoIndex >= 0 && sceneInfoIndex2 >= 0 && sceneInfoIndex2 < sceneInfoIndex)
			{
				newSceneIndex = subSceneRoots.Count - 1;
			}
		}
		ChangeSceneInternal(newSceneIndex);
	}

	private void OnEnable()
	{
		SceneArea.current.sceneTransitionController.subSceneController = this;
	}

	private void OnDisable()
	{
		SceneArea.current.sceneTransitionController.subSceneController = null;
	}

	public void ChangeScene(int newSceneIndex)
	{
		ChangeSceneInternal(newSceneIndex);
	}

	private void ChangeSceneInternal(int newSceneIndex)
	{
		if (newSceneIndex != currentSubSceneIndex)
		{
			if (newSceneIndex < 0 || newSceneIndex >= subSceneRoots.Count)
			{
				throw new ArgumentOutOfRangeException("newSceneIndex");
			}
			Transform transform = ((currentSubSceneIndex < 0) ? null : subSceneRoots[currentSubSceneIndex]);
			Transform transform2 = subSceneRoots[newSceneIndex];
			if ((bool)transform)
			{
				transform.gameObject.SetActive(value: false);
			}
			transform2.gameObject.SetActive(value: true);
			currentSubSceneIndex = newSceneIndex;
			if (newSceneIndex < shortDescriptionTexts.Count)
			{
				string text = shortDescriptionTexts[newSceneIndex];
				string body = ((descriptionTexts.Count <= newSceneIndex) ? text : descriptionTexts[newSceneIndex]);
				SceneArea.current.infoCard.SetContent(SceneArea.current.infoCard.expandedTitleText.text, text, body);
				SceneArea.current.infoCard.Collapse();
			}
		}
	}
}
}
