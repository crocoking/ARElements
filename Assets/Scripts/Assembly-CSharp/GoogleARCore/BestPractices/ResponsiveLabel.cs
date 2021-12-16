using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ResponsiveLabel : MonoBehaviour
{
	public Transform overrideThresholdTransform;

	public float transitionDistance = 1f;

	public Transform scalingPivot;

	public float collapsedScaler = 1f;

	public Canvas expandedCanvas;

	public CanvasGroup expandedCanvasGroup;

	public bool autoDisableExpandedCanvasGroup = true;

	public CanvasGroup collapsedCanvasGroup;

	public bool autoDisableCollapsedCanvasGroup = true;

	public Transform expandedContentPivot;

	public Transform leftCap;

	public Transform rightCap;

	public Transform centerFill;

	private float expandedRatio;

	private float focusedRatio;

	private float enableTime;

	public bool isFocused { get; private set; }

	private void OnEnable()
	{
		ResponsiveLabelManager.current.Register(this);
		enableTime = Time.timeSinceLevelLoad;
	}

	private void OnDisable()
	{
		if ((bool)ResponsiveLabelManager.current)
		{
			ResponsiveLabelManager.current.Unregister(this);
		}
		isFocused = false;
	}

	private void Start()
	{
		if ((bool)expandedCanvasGroup && autoDisableExpandedCanvasGroup)
		{
			expandedCanvasGroup.gameObject.SetActive(value: false);
		}
		if ((bool)collapsedCanvasGroup && autoDisableCollapsedCanvasGroup)
		{
			collapsedCanvasGroup.gameObject.SetActive(value: false);
		}
	}

	private void Update()
	{
		float num = Vector3.Distance(((!overrideThresholdTransform) ? base.transform : overrideThresholdTransform).position, Camera.main.transform.position);
		bool flag = num < transitionDistance;
		if (Time.timeSinceLevelLoad - enableTime > 0.5f)
		{
			flag |= isFocused;
		}
		focusedRatio = Mathf.Lerp(focusedRatio, isFocused ? 1 : 0, 10f * Time.deltaTime);
		expandedRatio = Mathf.Lerp(expandedRatio, flag ? 1 : 0, 10f * Time.deltaTime);
		if (!flag && expandedRatio <= 0.01f)
		{
			expandedRatio = 0f;
		}
		else if (flag && expandedRatio >= 0.99f)
		{
			expandedRatio = 1f;
		}
		float num2 = Mathf.Clamp01(expandedRatio * 2f - 1f);
		float a = Mathf.Clamp01(expandedRatio * 2f);
		a = Mathf.Lerp(a, 0f, focusedRatio);
		if ((bool)expandedContentPivot)
		{
			expandedContentPivot.localScale = new Vector3(num2, 1f, 1f);
		}
		if ((bool)scalingPivot)
		{
			scalingPivot.localScale = Vector3.one * Mathf.Lerp(collapsedScaler, 1f, a);
		}
		RectTransform rectTransform = (RectTransform)expandedCanvas.transform;
		float num3 = rectTransform.rect.width * rectTransform.localScale.x;
		leftCap.localPosition = new Vector3((0f - num3) * num2 / 2f, 0f, 0f);
		rightCap.localPosition = new Vector3(num3 * num2 / 2f, 0f, 0f);
		centerFill.localScale = new Vector3(num3 * num2, 1f, 1f);
		if (expandedRatio <= 0f)
		{
			if (centerFill.gameObject.activeSelf)
			{
				centerFill.gameObject.SetActive(value: false);
			}
		}
		else if (!centerFill.gameObject.activeSelf)
		{
			centerFill.gameObject.SetActive(value: true);
		}
		if ((bool)expandedCanvasGroup)
		{
			expandedCanvasGroup.alpha = expandedRatio;
			if (autoDisableExpandedCanvasGroup)
			{
				if (expandedRatio <= 0f)
				{
					if (expandedCanvasGroup.gameObject.activeSelf)
					{
						expandedCanvasGroup.gameObject.SetActive(value: false);
					}
				}
				else if (!expandedCanvasGroup.gameObject.activeSelf)
				{
					expandedCanvasGroup.gameObject.SetActive(value: true);
				}
			}
		}
		if (!collapsedCanvasGroup)
		{
			return;
		}
		collapsedCanvasGroup.alpha = 1f - expandedRatio;
		if (!autoDisableCollapsedCanvasGroup)
		{
			return;
		}
		if (expandedRatio >= 1f)
		{
			if (collapsedCanvasGroup.gameObject.activeSelf)
			{
				collapsedCanvasGroup.gameObject.SetActive(value: false);
			}
		}
		else if (!collapsedCanvasGroup.gameObject.activeSelf)
		{
			collapsedCanvasGroup.gameObject.SetActive(value: true);
		}
	}

	public void MakeFocused()
	{
		isFocused = true;
	}

	public void MakeUnfocused()
	{
		isFocused = false;
	}
}
}
