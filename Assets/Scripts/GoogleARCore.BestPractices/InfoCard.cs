using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class InfoCard : MonoBehaviour
{
	public class OnExpandChangedEvent : UnityEvent<bool>
	{
	}

	public Transform cardPivot;

	public DialogBox dialogBoxTemplate;

	public Button infoButton;

	public Text textComponent;

	public Text expandedTextComponent;

	public Text expandedTitleText;

	public RectTransform expandedContent;

	public MeshRenderer buttonMeshRenderer;

	public Material infoButtonMaterial;

	public Material minimizeButtonMaterial;

	public int maxPreviewTextLength = 30;

	public float middleScaleFactor = 200f;

	public Transform sheetTopTransform;

	public Transform sheetMiddleTransform;

	public Canvas contentCanvas;

	public float maxExpandedPosition = 3f;

	public float expandedCameraHeightScaler = 0.8f;

	public float expandedZOffset;

	public OnExpandChangedEvent onExpandChanged = new OnExpandChangedEvent();

	private float textHeight;

	private Vector3 targetCardScale;

	private Vector3 targetCardInvisibleScale = new Vector3(0f, 1f, 0f);

	private bool isExpanded;

	private float expandedRatio;

	private float collapsedCanvasHeight;

	private float maxExpandPositionOverride = -1f;

	private void Start()
	{
		buttonMeshRenderer.sharedMaterial = infoButtonMaterial;
		textComponent.text = string.Empty;
		expandedTextComponent.text = string.Empty;
		expandedTitleText.text = string.Empty;
		expandedContent.gameObject.SetActive(value: false);
		cardPivot.localScale = targetCardInvisibleScale;
		cardPivot.gameObject.SetActive(value: false);
		infoButton.onClick.AddListener(OnClickInfoButton);
		sheetMiddleTransform.gameObject.SetActive(value: false);
		collapsedCanvasHeight = ((RectTransform)contentCanvas.transform).sizeDelta.y;
	}

	private void LateUpdate()
	{
		cardPivot.localRotation = Quaternion.identity;
		Camera main = Camera.main;
		Vector3 normalized = (cardPivot.position - main.transform.position).normalized;
		Vector3 forward = base.transform.InverseTransformDirection(normalized);
		forward.x = 0f;
		forward.z = Mathf.Abs(forward.z);
		forward.Normalize();
		Quaternion a = Quaternion.LookRotation(forward);
		a = Quaternion.Slerp(a, Quaternion.identity, expandedRatio);
		cardPivot.localRotation = a;
		targetCardScale = Vector3.one;
		if (string.IsNullOrEmpty(textComponent.text))
		{
			targetCardScale = targetCardInvisibleScale;
		}
		cardPivot.localScale = Vector3.Lerp(cardPivot.localScale, targetCardScale, 25f * Time.deltaTime);
		if (targetCardScale.x == 0f && cardPivot.localScale.x < 0.001f)
		{
			cardPivot.localScale = targetCardInvisibleScale;
			if (cardPivot.gameObject.activeSelf)
			{
				cardPivot.gameObject.SetActive(value: false);
			}
		}
		else if (!cardPivot.gameObject.activeSelf)
		{
			cardPivot.gameObject.SetActive(value: true);
		}
		float num = expandedRatio;
		expandedRatio = Mathf.Lerp(expandedRatio, isExpanded ? 1 : 0, 10f * Time.deltaTime);
		if (isExpanded)
		{
			if (!sheetMiddleTransform.gameObject.activeSelf)
			{
				sheetMiddleTransform.gameObject.SetActive(value: true);
			}
			if (expandedRatio >= 0.999f)
			{
				expandedRatio = 1f;
			}
		}
		else if (expandedRatio <= 0.001f)
		{
			expandedRatio = 0f;
			if (sheetMiddleTransform.gameObject.activeSelf)
			{
				sheetMiddleTransform.gameObject.SetActive(value: false);
			}
		}
		if (num != expandedRatio)
		{
			float num2 = expandedContent.rect.height * contentCanvas.transform.localScale.y;
			Vector3 localScale = sheetMiddleTransform.localScale;
			localScale.z = middleScaleFactor * num2 * expandedRatio;
			sheetMiddleTransform.localScale = localScale;
			sheetTopTransform.localPosition = new Vector3(0f, num2 * expandedRatio, 0f);
			Vector3 localPosition = contentCanvas.transform.localPosition;
			localPosition.y = sheetTopTransform.localPosition.y / 2f;
			contentCanvas.transform.localPosition = localPosition;
			RectTransform rectTransform = (RectTransform)contentCanvas.transform;
			rectTransform.SetSizeWithCurrentAnchors(RectTransform.Axis.Vertical, Mathf.Lerp(collapsedCanvasHeight, expandedContent.rect.height, expandedRatio));
		}
		Vector3 b = Vector3.zero;
		if (isExpanded)
		{
			b = main.transform.position;
			b = base.transform.InverseTransformPoint(b);
			b.x = 0f;
			b.z = expandedZOffset;
			float max = ((!(maxExpandPositionOverride >= 0f)) ? maxExpandedPosition : maxExpandPositionOverride);
			b.y = Mathf.Clamp(b.y * expandedCameraHeightScaler, 0f, max);
		}
		cardPivot.localPosition = Vector3.Lerp(cardPivot.localPosition, b, 10f * Time.deltaTime);
	}

	private void OnClickInfoButton()
	{
		isExpanded = !isExpanded;
		OnExpandChanged();
	}

	public void Expand()
	{
		if (!isExpanded)
		{
			isExpanded = true;
			OnExpandChanged();
		}
	}

	public void Collapse()
	{
		if (isExpanded)
		{
			isExpanded = false;
			OnExpandChanged();
		}
	}

	public void SetShortText(string shortBody)
	{
		textComponent.text = shortBody;
	}

	public void SetContent(string title, string shortBody, string body)
	{
		title = title ?? string.Empty;
		body = body ?? string.Empty;
		expandedTitleText.text = title;
		expandedTextComponent.text = body;
		SetShortText(shortBody);
		SetMaxExpandPositionOverride();
	}

	public void SetMaxExpandPositionOverride(float maxExpandPositionOverride = -1f)
	{
		this.maxExpandPositionOverride = maxExpandPositionOverride;
	}

	private void OnExpandChanged()
	{
		textComponent.gameObject.SetActive(!isExpanded);
		expandedContent.gameObject.SetActive(isExpanded);
		buttonMeshRenderer.sharedMaterial = ((!isExpanded) ? infoButtonMaterial : minimizeButtonMaterial);
		Canvas.ForceUpdateCanvases();
		if (onExpandChanged != null)
		{
			onExpandChanged.Invoke(isExpanded);
		}
	}
}
}
