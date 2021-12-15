using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using KeenTween;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace GoogleARCore.BestPractices{

public class SceneTransitionController : MonoBehaviour
{
	private Coroutine transitionCoroutine;

	public const float transitionTime = 0.5f;

	private static List<NavigationInterface> navigationInterfaces = new List<NavigationInterface>();

	public SubSceneController subSceneController { get; set; }

	public bool isTransitioning
	{
		[CompilerGenerated]
		get
		{
			return transitionCoroutine != null;
		}
	}

	private void OnDisable()
	{
		transitionCoroutine = null;
	}

	public static void RegisterNavigationInterface(NavigationInterface navigationInterface)
	{
		navigationInterfaces.Add(navigationInterface);
	}

	public static void UnregisterNavigationInterface(NavigationInterface navigationInterface)
	{
		navigationInterfaces.Remove(navigationInterface);
	}

	public void TransitionToScene(string sceneName, int subSceneIndex = -1)
	{
		if (isTransitioning)
		{
			throw new Exception("Scene transition already active.");
		}
		transitionCoroutine = StartCoroutine(TransitionAsync(sceneName, subSceneIndex));
	}

	private IEnumerator TransitionAsync(string sceneName, int subSceneIndex)
	{
		Tween tween2 = Fade(fadeIn: false);
		while (!tween2.isDone)
		{
			yield return null;
		}
		if (subSceneIndex >= 0)
		{
			subSceneController.ChangeScene(subSceneIndex);
		}
		else
		{
			SceneManager.LoadScene(sceneName);
			yield return null;
			yield return null;
			yield return null;
		}
		NotifyButtonVisibility();
		tween2 = Fade(fadeIn: true);
		while (!tween2.isDone)
		{
			yield return null;
		}
		transitionCoroutine = null;
	}

	public Tween Fade(bool fadeIn)
	{
		float from = ((!fadeIn) ? 1 : 0);
		float to = (fadeIn ? 1 : 0);
		return new Tween(null, from, to, 0.25f, new CurveCubic(TweenCurveMode.InOut), delegate(Tween t)
		{
			if ((bool)SceneFadeController.current)
			{
				SceneFadeController.current.weight = t.currentValue;
			}
		});
	}

	public void TransitionToPreviousScene()
	{
		if (!isTransitioning)
		{
			if ((bool)subSceneController && !subSceneController.isFirstSubScene)
			{
				TransitionToScene(null, subSceneController.currentSubSceneIndex - 1);
				return;
			}
			SceneInfoCollection.SceneInfo previousSceneInfo = SceneArea.current.sceneInfoCollection.GetPreviousSceneInfo(SceneManager.GetActiveScene().name);
			TransitionToScene(previousSceneInfo.name);
		}
	}

	public void TransitionToNextScene()
	{
		if (!isTransitioning)
		{
			if ((bool)subSceneController && !subSceneController.isLastSubScene)
			{
				TransitionToScene(null, subSceneController.currentSubSceneIndex + 1);
				return;
			}
			SceneInfoCollection.SceneInfo nextSceneInfo = SceneArea.current.sceneInfoCollection.GetNextSceneInfo(SceneManager.GetActiveScene().name);
			TransitionToScene(nextSceneInfo.name);
		}
	}

	public void TransitionToMenu()
	{
		if (!isTransitioning)
		{
			TransitionToScene("Menu");
		}
	}

	public void NotifyButtonVisibility()
	{
		bool previous = false;
		bool next = false;
		bool menu = false;
		if (CheckNavigationVisible())
		{
			previous = CheckPreviousButtonVisible();
			next = CheckNextButtonVisible();
			menu = CheckMenuNavigationVisible();
		}
		foreach (NavigationInterface navigationInterface in navigationInterfaces)
		{
			navigationInterface.OnVisibilityUpdated(previous, next, menu);
		}
	}

	public bool CheckPreviousButtonVisible()
	{
		if ((bool)subSceneController && !subSceneController.isFirstSubScene)
		{
			return true;
		}
		string sceneName = SceneManager.GetActiveScene().name;
		SceneInfoCollection.SceneInfo sceneInfo = SceneArea.current.sceneInfoCollection.GetSceneInfo(sceneName);
		if (sceneInfo == null)
		{
			return false;
		}
		SceneInfoCollection.SceneInfo previousSceneInfo = SceneArea.current.sceneInfoCollection.GetPreviousSceneInfo(sceneName);
		return previousSceneInfo.islandGroup == sceneInfo.islandGroup;
	}

	public bool CheckNextButtonVisible()
	{
		if ((bool)subSceneController && !subSceneController.isLastSubScene)
		{
			return true;
		}
		string sceneName = SceneManager.GetActiveScene().name;
		SceneInfoCollection.SceneInfo sceneInfo = SceneArea.current.sceneInfoCollection.GetSceneInfo(sceneName);
		if (sceneInfo == null)
		{
			return false;
		}
		SceneInfoCollection.SceneInfo nextSceneInfo = SceneArea.current.sceneInfoCollection.GetNextSceneInfo(sceneName);
		return nextSceneInfo.islandGroup == sceneInfo.islandGroup;
	}

	public bool CheckMenuNavigationVisible()
	{
		return true;
	}

	public bool CheckNavigationVisible()
	{
		SceneDescription sceneDescription = UnityEngine.Object.FindObjectOfType<SceneDescription>();
		if ((bool)sceneDescription)
		{
			return sceneDescription.showNavButtons;
		}
		return true;
	}
}
}
