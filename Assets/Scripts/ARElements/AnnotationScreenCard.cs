using System;
using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

public class AnnotationScreenCard : MonoBehaviour
{
	public enum ScreenCardState
	{
		Unknown,
		Hidden,
		Visible,
		AnimatingIn,
		AnimatingOut
	}

	[Tooltip("Sensitivity threshold for push to dismiss card.")]
	[Range(1f, 1.2f)]
	public float dismissPushThreshold = 1.15f;

	[Range(0f, 1f)]
	[Tooltip("Speed of the card show/hide animation.")]
	public float animationSpeed = 0.1f;

	[Tooltip("Scroll view used to slide card into view.")]
	public ScrollRect scrollRect;

	[Tooltip("Content layout group managing card.")]
	public VerticalLayoutGroup contentLayoutGroup;

	[Tooltip("Icon for the annotation card.")]
	public Image icon;

	[Tooltip("Title of the annotation card.")]
	public Text title;

	[Tooltip("Long form detail text on the annotation card.")]
	public Text detailText;

	[Tooltip("Card image used for applying tint color on.")]
	public Image cardImage;

	public Action<ScreenCardState> onCardStateChanged;

	private float m_AnimationProgress;

	public ScreenCardState cardState { get; protected set; }

	private void Awake()
	{
		if (scrollRect == null)
		{
			Debug.LogError("Can't show annoation without scroll rect.");
		}
		else if (scrollRect.viewport == null)
		{
			Debug.LogError("Can't show annotation without scroll view viewport.");
		}
		else
		{
			HideCardImmediate();
		}
	}

	private void OnEnable()
	{
		scrollRect.onValueChanged.AddListener(ScrollVerticalPositionChanged);
	}

	private void OnDisable()
	{
		scrollRect.onValueChanged.RemoveListener(ScrollVerticalPositionChanged);
	}

	private void Update()
	{
		if (cardState == ScreenCardState.AnimatingIn)
		{
			ContinueShowCardAnimation();
		}
		else if (cardState == ScreenCardState.AnimatingOut)
		{
			ContinueHideCardAnimation();
		}
	}

	private void ScrollVerticalPositionChanged(Vector2 scrollPosition)
	{
		if (cardState == ScreenCardState.Visible && scrollRect.normalizedPosition.y > dismissPushThreshold)
		{
			HideCard();
		}
	}

	public void ShowCard(AnnotationData annotationData)
	{
		cardState = ScreenCardState.AnimatingIn;
		NotifyStateChanged();
		PopulateScreenCard(annotationData);
		m_AnimationProgress = 0f;
	}

	public void HideCard()
	{
		cardState = ScreenCardState.AnimatingOut;
		NotifyStateChanged();
	}

	private void HideCardImmediate()
	{
		cardState = ScreenCardState.Hidden;
		contentLayoutGroup.padding.top = (int)scrollRect.viewport.rect.height;
	}

	private void ContinueShowCardAnimation()
	{
		float num = animationSpeed;
		m_AnimationProgress = Mathf.Clamp01(m_AnimationProgress + num);
		float num2 = EaseOutBounceCurve(m_AnimationProgress);
		float num3 = scrollRect.viewport.rect.height * (1f - num2);
		contentLayoutGroup.padding.top = (int)num3;
		if (m_AnimationProgress >= 1f)
		{
			contentLayoutGroup.padding.top = 0;
			cardState = ScreenCardState.Visible;
			NotifyStateChanged();
		}
	}

	private void ContinueHideCardAnimation()
	{
		float num = 1.25f;
		float num2 = animationSpeed;
		float num3 = scrollRect.verticalNormalizedPosition + num2;
		scrollRect.verticalNormalizedPosition = num3;
		if (num3 >= num)
		{
			cardState = ScreenCardState.Hidden;
			NotifyStateChanged();
		}
	}

	private void NotifyStateChanged()
	{
		if (onCardStateChanged != null)
		{
			onCardStateChanged(cardState);
		}
	}

	protected virtual void PopulateScreenCard(AnnotationData data)
	{
		if (!data)
		{
			Debug.LogError("Can't populate card with null annotation data");
			return;
		}
		if (icon != null)
		{
			icon.sprite = data.icon;
		}
		if (title != null)
		{
			title.text = data.title;
		}
		if (detailText != null)
		{
			detailText.text = data.detail;
		}
		if (cardImage != null)
		{
			cardImage.color = data.cardColor;
		}
	}

	private float EaseOutBounceCurve(float t)
	{
		return 1f + (t -= 1f) * t * (2.70158f * t + 1.70158f);
	}
}
}
