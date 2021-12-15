using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class TargetingButton : MonoBehaviour
{
	public delegate void OnButtonDownDelegate(RaycastHit raycastHit);

	public delegate void OnButtonUpDelegate();

	public delegate bool OnTestHitDelegate(RaycastHit raycastHit);

	public Image reticleImage;

	public float reticleNormalAlpha = 0.25f;

	public float reticleHoverAlpha = 1f;

	public float reticleActiveAlpha;

	public float reticleHoverActiveSize = 1.25f;

	public List<HoldButton> buttons = new List<HoldButton>();

	public BackgroundPressDetection backgroundPressDetection;

	public CanvasGroup buttonCanvasGroup;

	public OnButtonDownDelegate onButtonDown;

	public OnButtonUpDelegate onButtonUp;

	public OnTestHitDelegate onTestHit;

	private Camera mainCamera;

	private bool cachedHitTestResult;

	private void Start()
	{
		mainCamera = Camera.main;
		foreach (HoldButton button in buttons)
		{
			button.onPressed.AddListener(OnButtonPress);
			button.onReleased.AddListener(OnButtonRelease);
		}
		backgroundPressDetection.onPress.AddListener(OnButtonPress);
		backgroundPressDetection.onRelease.AddListener(OnButtonRelease);
		backgroundPressDetection.AddCondition(() => cachedHitTestResult);
		if ((bool)buttonCanvasGroup)
		{
			buttonCanvasGroup.alpha = 0f;
			buttonCanvasGroup.blocksRaycasts = false;
		}
		Color color = reticleImage.color;
		color.a = 0f;
		reticleImage.color = color;
		reticleImage.enabled = true;
	}

	private void Update()
	{
		Ray ray = new Ray(mainCamera.transform.position, mainCamera.transform.forward);
		Physics.Raycast(ray, out var hitInfo);
		cachedHitTestResult = hitInfo.collider;
		if (onTestHit != null)
		{
			cachedHitTestResult = onTestHit(hitInfo);
		}
		float maxDelta = Time.deltaTime * 4f;
		Color color = reticleImage.color;
		float num = 1f;
		if (backgroundPressDetection.isPressing || buttons.Any((HoldButton v) => v.isPressed))
		{
			color.a = Mathf.MoveTowards(color.a, reticleActiveAlpha, maxDelta);
			num = reticleHoverActiveSize;
		}
		else
		{
			float target = ((!cachedHitTestResult) ? reticleNormalAlpha : reticleHoverAlpha);
			num = ((!cachedHitTestResult) ? 1f : reticleHoverActiveSize);
			if ((bool)hitInfo.collider && (bool)hitInfo.collider.gameObject.GetComponentInParent<TargetingReticleHider>())
			{
				target = 0f;
				num = 1f;
			}
			color.a = Mathf.MoveTowards(color.a, target, maxDelta);
		}
		reticleImage.color = color;
		reticleImage.transform.localScale = Vector3.one * Mathf.MoveTowards(reticleImage.transform.localScale.x, num, maxDelta);
		if ((bool)buttonCanvasGroup)
		{
			float target2 = (cachedHitTestResult ? 1 : 0);
			if (backgroundPressDetection.isPressing || buttons.Any((HoldButton v) => v.isPressed && (buttonCanvasGroup.gameObject == v.gameObject || v.transform.IsChildOf(buttonCanvasGroup.transform))))
			{
				target2 = 1f;
			}
			buttonCanvasGroup.alpha = Mathf.MoveTowards(buttonCanvasGroup.alpha, target2, maxDelta);
			buttonCanvasGroup.blocksRaycasts = buttonCanvasGroup.alpha > 0.5f;
		}
	}

	private void OnButtonPress()
	{
		Ray ray = new Ray(mainCamera.transform.position, mainCamera.transform.forward);
		Physics.Raycast(ray, out var hitInfo);
		if (onButtonDown != null)
		{
			onButtonDown(hitInfo);
		}
	}

	private void OnButtonRelease()
	{
		if (onButtonUp != null)
		{
			onButtonUp();
		}
	}
}
}
