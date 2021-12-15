using KeenTween;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class OverflowMenu : Selectable
{
	public VerticalLayoutGroup layout;

	public GameObject itemTemplate;

	public GameObject dividerTemplate;

	public CanvasGroup canvasGroup;

	public CanvasGroup layoutCanvasGroup;

	private Tween animationTween;

	private bool isClosing;

	protected override void Start()
	{
		base.Start();
		EventSystem.current.SetSelectedGameObject(base.gameObject);
		canvasGroup.alpha = 0f;
		layoutCanvasGroup.blocksRaycasts = false;
		animationTween = new Tween(null, 0f, 1f, 0.25f, new CurveCubic(TweenCurveMode.Out), UpdateTween);
		animationTween.onFinish += delegate
		{
			if ((bool)base.gameObject)
			{
				layoutCanvasGroup.blocksRaycasts = true;
			}
		};
	}

	private void Update()
	{
		if (Application.isPlaying && !isClosing)
		{
			GameObject currentSelectedGameObject = EventSystem.current.currentSelectedGameObject;
			if (currentSelectedGameObject != this && (!currentSelectedGameObject || !currentSelectedGameObject.transform.IsChildOf(base.transform)))
			{
				Close();
			}
		}
	}

	public GameObject AddDivider()
	{
		GameObject result = Object.Instantiate(dividerTemplate, layout.transform);
		LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)base.transform);
		return result;
	}

	public GameObject AddItem(string caption, UnityAction onClick)
	{
		GameObject gameObject = Object.Instantiate(itemTemplate, layout.transform);
		Button componentInChildren = gameObject.GetComponentInChildren<Button>();
		Text componentInChildren2 = gameObject.GetComponentInChildren<Text>();
		componentInChildren.onClick.AddListener(Close);
		if (onClick != null)
		{
			componentInChildren.onClick.AddListener(onClick);
		}
		componentInChildren2.text = caption;
		LayoutRebuilder.ForceRebuildLayoutImmediate((RectTransform)base.transform);
		return gameObject;
	}

	private void Close()
	{
		isClosing = true;
		canvasGroup.blocksRaycasts = false;
		if (animationTween != null && !animationTween.isDone)
		{
			animationTween.Cancel();
		}
		animationTween = new Tween(null, 1f, 0f, 0.15f, new CurveCubic(TweenCurveMode.Out), UpdateTween);
		animationTween.onFinish += delegate
		{
			if ((bool)this)
			{
				Object.DestroyImmediate(base.gameObject);
			}
		};
	}

	private void UpdateTween(Tween tween)
	{
		if ((bool)this)
		{
			canvasGroup.alpha = tween.currentValue;
		}
	}
}
