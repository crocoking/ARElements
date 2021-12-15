using System.Collections;
using KeenTween;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class InitScreen : MonoBehaviour
{
	public CanvasGroup canvasGroup;

	public CanvasGroup contentCanvasGroup;

	public CanvasGroup splashCanvasGroup;

	public Button giveAccessButton;

	public Text giveAccessButtonText;

	public DialogBox dialogTemplate;

	private bool infoScreenWasShown;

	private void Start()
	{
		Object.DontDestroyOnLoad(base.gameObject);
		giveAccessButton.onClick.AddListener(OnClickGiveAccessButton);
		SceneManager.sceneLoaded += OnSceneLoaded;
		contentCanvasGroup.alpha = 0f;
		contentCanvasGroup.blocksRaycasts = false;
		if (Application.isEditor || !AndroidPermissionsManager.IsPermissionGranted("android.permission.CAMERA"))
		{
			infoScreenWasShown = true;
			contentCanvasGroup.blocksRaycasts = true;
			Tween parent = new Tween(null, 1f, 0f, 1f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
			{
				if ((bool)base.gameObject)
				{
					splashCanvasGroup.alpha = t.currentValue;
				}
			});
			new Tween(parent, 0f, 1f, 1f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
			{
				if ((bool)base.gameObject)
				{
					contentCanvasGroup.alpha = t.currentValue;
				}
			});
		}
		else
		{
			StartCoroutine(OnPermissionGranted());
		}
	}

	private void OnClickGiveAccessButton()
	{
		contentCanvasGroup.blocksRaycasts = false;
		if (Application.isEditor)
		{
			StartCoroutine(OnPermissionGranted());
			return;
		}
		switch (AndroidRuntimePermissions.RequestPermission("android.permission.CAMERA"))
		{
		case AndroidRuntimePermissions.Permission.Granted:
			StartCoroutine(OnPermissionGranted());
			break;
		case AndroidRuntimePermissions.Permission.Denied:
		{
			contentCanvasGroup.blocksRaycasts = true;
			DialogBox dialogBox = Object.Instantiate(dialogTemplate);
			dialogBox.titleText = "Permissions required";
			dialogBox.bodyText = "Camera permission is required to use this app.";
			Button button = dialogBox.AddDismissButton("open system permissions");
			button.onClick.AddListener(delegate
			{
				AndroidUtility.OpenAppInfo();
			});
			break;
		}
		case AndroidRuntimePermissions.Permission.ShouldAsk:
			contentCanvasGroup.blocksRaycasts = true;
			break;
		}
	}

	private IEnumerator OnPermissionGranted()
	{
		giveAccessButton.interactable = false;
		giveAccessButtonText.text = "Loading...";
		yield return new WaitForSeconds(0.1f);
		SceneManager.LoadScene("Menu");
	}

	private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
	{
		SceneManager.sceneLoaded -= OnSceneLoaded;
		Tween parent = null;
		if (infoScreenWasShown)
		{
			parent = new Tween(null, 1f, 0f, 0.5f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
			{
				if ((bool)base.gameObject)
				{
					contentCanvasGroup.alpha = t.currentValue;
				}
			});
		}
		Tween tween = new Tween(parent, 1f, 0f, 1f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)base.gameObject)
			{
				canvasGroup.alpha = t.currentValue;
			}
		});
		tween.onFinish += delegate
		{
			Object.DestroyImmediate(base.gameObject);
		};
		tween.delay = 0.5f;
	}
}
}
