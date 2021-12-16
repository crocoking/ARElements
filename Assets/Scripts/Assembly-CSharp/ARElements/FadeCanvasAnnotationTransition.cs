using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

[ExecuteInEditMode]
public class FadeCanvasAnnotationTransition : BaseCanvasAnnotationTransition
{
	[Tooltip("Speed at which the cavas will fade in/out at when changing card sizes.")]
	public float cardCanvasFadeSpeed = 1.7f;

	[Header("Small Size Content")]
	[Tooltip("Canvas used for the small UI")]
	public CanvasGroup smallContentGroup;

	public Image smallIconImage;

	[Header("Medium Size Content")]
	[Tooltip("Canvas used for the medium UI")]
	public CanvasGroup mediumContentGroup;

	public Image mediumIconImage;

	public Text mediumTitle;

	[Header("Large Size Content")]
	[Tooltip("Canvas used for the large UI")]
	public CanvasGroup largeContentGroup;

	public Image largeIconImage;

	public Text largeTitleText;

	public Text largeDetailText;

	private CanvasGroup m_CurrentCanvasUI;

	private CanvasFadeAnimation m_CurrentCanvasFade;

	private void Start()
	{
		HideAllCanvasGroups();
	}

	public override void TransitionToViewSize(AnnotationData annotationData, AnnotationViewSize nextAnnotationViewSize)
	{
		CanvasGroup canvasGroup = CanvasForViewMode(nextAnnotationViewSize);
		if (m_CurrentCanvasFade != null)
		{
			m_CurrentCanvasFade.CompleteAnimation();
		}
		PopulateCanvasForViewSize(nextAnnotationViewSize, annotationData);
		m_CurrentCanvasFade = new CanvasFadeAnimation(m_CurrentCanvasUI, canvasGroup, cardCanvasFadeSpeed);
		m_CurrentCanvasUI = canvasGroup;
	}

	private void Update()
	{
		ContinueCanvasAnimation();
	}

	private void ContinueCanvasAnimation()
	{
		if (m_CurrentCanvasFade != null)
		{
			m_CurrentCanvasFade.ContinueFadeAnimation();
			if (m_CurrentCanvasFade.state == CanvasFadeAnimation.FadeState.Done)
			{
				m_CurrentCanvasFade = null;
			}
		}
	}

	private CanvasGroup CanvasForViewMode(AnnotationViewSize size)
	{
		 switch (size)
		{
			case AnnotationViewSize.Small : return smallContentGroup;
			case AnnotationViewSize.Medium : return mediumContentGroup;
			case AnnotationViewSize.Large : return largeContentGroup;
				default: return null; 
		};
	}

	private void PopulateCanvasForViewSize(AnnotationViewSize size, AnnotationData annotationData)
	{
		switch (size)
		{
		case AnnotationViewSize.Small:
			PopulateSmallUI(annotationData);
			break;
		case AnnotationViewSize.Medium:
			PopulateMediumUI(annotationData);
			break;
		case AnnotationViewSize.Large:
			PopulateLargeUI(annotationData);
			break;
		}
	}

	private void PopulateSmallUI(AnnotationData annotationData)
	{
		if (!(annotationData == null) && smallIconImage != null)
		{
			smallIconImage.sprite = annotationData.icon;
		}
	}

	private void PopulateMediumUI(AnnotationData annotationData)
	{
		if (!(annotationData == null))
		{
			if (mediumIconImage != null)
			{
				mediumIconImage.sprite = annotationData.icon;
			}
			if (mediumTitle != null)
			{
				mediumTitle.text = annotationData.title;
			}
		}
	}

	private void PopulateLargeUI(AnnotationData annotationData)
	{
		if (!(annotationData == null))
		{
			if (largeIconImage != null)
			{
				largeIconImage.sprite = annotationData.icon;
			}
			if (largeTitleText != null)
			{
				largeTitleText.text = annotationData.title;
			}
			if (largeDetailText != null)
			{
				largeDetailText.text = annotationData.summary;
			}
		}
	}

	private void HideAllCanvasGroups()
	{
		if (smallContentGroup != null)
		{
			smallContentGroup.alpha = 0f;
		}
		if (mediumContentGroup != null)
		{
			mediumContentGroup.alpha = 0f;
		}
		if (largeContentGroup != null)
		{
			largeContentGroup.alpha = 0f;
		}
	}
}
}
