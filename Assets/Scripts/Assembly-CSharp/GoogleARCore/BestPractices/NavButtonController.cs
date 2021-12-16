using KeenTween;
using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class NavButtonController : NavigationInterface
{
	public Transform contentTransform;

	public Button previousSceneButton;

	public Button nextSceneButton;

	public Button menuButton;

	private Tween showHideButtonsTween;

	private void Awake()
	{
	}

	private void Start()
	{
		previousSceneButton.onClick.AddListener(delegate
		{
			SceneArea.current.sceneTransitionController.TransitionToPreviousScene();
		});
		nextSceneButton.onClick.AddListener(delegate
		{
			SceneArea.current.sceneTransitionController.TransitionToNextScene();
		});
		menuButton.onClick.AddListener(delegate
		{
			SceneArea.current.sceneTransitionController.TransitionToMenu();
		});
	}

	public override void OnVisibilityUpdated(bool previous, bool next, bool menu)
	{
		base.OnVisibilityUpdated(previous, next, menu);
		previousSceneButton.gameObject.SetActive(previous);
		nextSceneButton.gameObject.SetActive(next);
		menuButton.gameObject.SetActive(menu);
	}
}
}
