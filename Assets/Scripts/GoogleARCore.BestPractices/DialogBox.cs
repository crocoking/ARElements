using KeenTween;
using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class DialogBox : MonoBehaviour
{
	public float minWidth = 280f;

	public float maxWidth = 280f;

	public CanvasGroup canvasGroup;

	public RectTransform dialogContentTransform;

	public Button backgroundButton;

	public RectTransform buttonLayout;

	public Button buttonTemplate;

	public RectTransform titleLayout;

	public Text titleTextComponent;

	public Text bodyTextComponent;

	public LayoutElement scrollViewLayoutElement;

	private Tween closeTween;

	public string titleText
	{
		get
		{
			return titleTextComponent.text;
		}
		set
		{
			titleTextComponent.text = value;
			titleLayout.gameObject.SetActive(!string.IsNullOrEmpty(value));
		}
	}

	public string bodyText
	{
		get
		{
			return bodyTextComponent.text;
		}
		set
		{
			bodyTextComponent.text = value;
			UpdateLayout();
		}
	}

	private void Start()
	{
		backgroundButton.onClick.AddListener(Close);
		UpdateLayout();
		canvasGroup.alpha = 0f;
		dialogContentTransform.localScale = Vector3.one * 0.75f;
		new Tween(null, 0f, 1f, 0.25f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)canvasGroup && (bool)dialogContentTransform)
			{
				canvasGroup.alpha = t.currentValue;
				dialogContentTransform.localScale = Vector3.one * Mathf.Lerp(0.75f, 1f, t.currentValue);
			}
		});
	}

	public Button AddDismissButton(string text = "OK")
	{
		Button button = AddButton(text);
		button.onClick.AddListener(Close);
		return button;
	}

	public Button AddButton(string text)
	{
		text = text.ToUpper();
		Button button = Object.Instantiate(buttonTemplate, buttonLayout);
		Text componentInChildren = button.GetComponentInChildren<Text>();
		componentInChildren.text = text;
		button.gameObject.SetActive(value: true);
		return button;
	}

	public void Close()
	{
		if (closeTween != null)
		{
			return;
		}
		closeTween = new Tween(null, 1f, 0f, 0.25f, new CurveCubic(TweenCurveMode.In), delegate(Tween t)
		{
			if ((bool)canvasGroup && (bool)dialogContentTransform)
			{
				canvasGroup.alpha = t.currentValue;
				dialogContentTransform.localScale = Vector3.one * Mathf.Lerp(0.75f, 1f, t.currentValue);
			}
		});
		closeTween.onFinish += delegate
		{
			Object.Destroy(base.gameObject);
		};
	}

	public void UpdateLayout()
	{
		RectTransform rectTransform = bodyTextComponent.transform as RectTransform;
		RectTransform rectTransform2 = dialogContentTransform.parent as RectTransform;
		float value = rectTransform2.rect.width * 0.7f;
		value = Mathf.Clamp(value, minWidth, maxWidth);
		LayoutElement component = dialogContentTransform.gameObject.GetComponent<LayoutElement>();
		component.preferredWidth = value;
		scrollViewLayoutElement.preferredHeight = -1f;
		Canvas.ForceUpdateCanvases();
		float num = dialogContentTransform.rect.height - rectTransform.rect.height;
		float num2 = rectTransform2.rect.height - 50f;
		float num3 = num2 - num;
		if (rectTransform.rect.height > num3)
		{
			scrollViewLayoutElement.preferredHeight = num3;
		}
		else
		{
			scrollViewLayoutElement.preferredHeight = -1f;
		}
	}
}
}
