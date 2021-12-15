using KeenTween;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class TargetingPopup : MonoBehaviour
{
	public Transform popupParent;

	public TargetingButton targetingButton;

	public GameObject buttonInactiveGraphics;

	public GameObject buttonActiveGraphics;

	public UnityEvent onShowPopup;

	public UnityEvent onHidePopup;

	private GameObject popupInstance;

	private void Start()
	{
		buttonInactiveGraphics.SetActive(value: true);
		buttonActiveGraphics.SetActive(value: false);
		targetingButton.onTestHit = OnTestHit;
		targetingButton.onButtonDown = OnButtonDown;
	}

	private bool OnTestHit(RaycastHit hit)
	{
		if ((bool)popupInstance)
		{
			return true;
		}
		TargetingPopupTarget targetingPopupTarget = hit.collider?.gameObject.GetComponentInParent<TargetingPopupTarget>();
		return targetingPopupTarget;
	}

	private void OnButtonDown(RaycastHit hit)
	{
		if ((bool)popupInstance)
		{
			CanvasGroup canvasGroup = popupInstance.GetComponent<CanvasGroup>();
			if ((bool)canvasGroup)
			{
				new Tween(null, canvasGroup.alpha, 0f, 0.25f, new CurveCubic(TweenCurveMode.In), delegate(Tween t)
				{
					if ((bool)canvasGroup)
					{
						canvasGroup.alpha = t.currentValue;
					}
				}).onFinish += delegate
				{
					if ((bool)canvasGroup)
					{
						Object.DestroyImmediate(canvasGroup.gameObject);
					}
				};
			}
			else
			{
				Object.DestroyImmediate(popupInstance);
			}
			buttonInactiveGraphics.SetActive(value: true);
			buttonActiveGraphics.SetActive(value: false);
			onHidePopup.Invoke();
		}
		else
		{
			if (!hit.collider)
			{
				return;
			}
			TargetingPopupTarget componentInParent = hit.collider.gameObject.GetComponentInParent<TargetingPopupTarget>();
			if (!componentInParent)
			{
				return;
			}
			popupInstance = Object.Instantiate(componentInParent.popupTemplate, popupParent);
			popupInstance.SetActive(value: true);
			buttonInactiveGraphics.SetActive(value: false);
			buttonActiveGraphics.SetActive(value: true);
			CanvasGroup canvasGroup2 = popupInstance.GetComponent<CanvasGroup>();
			if ((bool)canvasGroup2)
			{
				canvasGroup2.alpha = 0f;
				new Tween(null, 0f, 1f, 0.25f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
				{
					if ((bool)canvasGroup2)
					{
						canvasGroup2.alpha = t.currentValue;
					}
				});
			}
			onShowPopup.Invoke();
		}
	}
}
}
