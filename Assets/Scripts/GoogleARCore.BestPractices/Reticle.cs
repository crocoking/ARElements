using KeenTween;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class Reticle : MonoBehaviour
{
	public enum VisibilityState
	{
		Always,
		OnScreen,
		OffScreen
	}

	public VisibilityState visibilityState;

	public Transform trackedTransform;

	public Image icon;

	public bool rotateTowardsCenter;

	public float additionalRotation;

	public bool clampPosition = true;

	public CanvasGroup canvasGroup;

	public bool fadeAlpha;

	public UnityEvent onBecomeVisible;

	private Camera mainCamera;

	private float scale;

	private Tween tween;

	private bool isDisabled;

	private void Start()
	{
		mainCamera = Camera.main;
	}

	private void LateUpdate()
	{
		if (!trackedTransform)
		{
			Disable();
			return;
		}
		Vector3 vector = trackedTransform.position;
		Plane plane = new Plane(mainCamera.transform.forward, mainCamera.transform.position + mainCamera.transform.forward * mainCamera.nearClipPlane);
		if (!plane.GetSide(vector))
		{
			vector = plane.ClosestPointOnPlane(vector);
		}
		Vector3 normalized = (vector - mainCamera.transform.position).normalized;
		Vector3 vector2 = mainCamera.WorldToViewportPoint(vector);
		bool flag = vector2.x > 0f && vector2.x < 1f && vector2.y > 0f && vector2.y < 1f;
		if (visibilityState == VisibilityState.Always)
		{
			Enable();
		}
		else if (visibilityState == VisibilityState.OnScreen)
		{
			if (flag)
			{
				Enable();
			}
			else
			{
				Disable();
			}
		}
		else if (visibilityState == VisibilityState.OffScreen)
		{
			if (flag)
			{
				Disable();
			}
			else
			{
				Enable();
			}
		}
		if (icon.enabled)
		{
			if (clampPosition)
			{
				vector2.x = Mathf.Clamp01(vector2.x);
				vector2.y = Mathf.Clamp01(vector2.y);
			}
			RectTransform component = base.gameObject.GetComponent<RectTransform>();
			component.anchorMin = vector2;
			component.anchorMax = vector2;
			if (rotateTowardsCenter)
			{
				base.transform.rotation = Quaternion.LookRotation(Vector3.forward, -base.transform.localPosition) * Quaternion.Euler(0f, 0f, additionalRotation);
			}
		}
	}

	private void Disable()
	{
		if (isDisabled)
		{
			return;
		}
		if (tween != null && !tween.isDone)
		{
			tween.Cancel();
		}
		tween = new Tween(null, scale, 0f, 0.5f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)base.transform)
			{
				scale = t.currentValue;
				base.transform.localScale = Vector3.one * scale;
				if (fadeAlpha && (bool)canvasGroup)
				{
					canvasGroup.alpha = t.currentValue;
				}
			}
		});
		tween.onFinish += delegate
		{
			if ((bool)icon)
			{
				icon.enabled = false;
			}
		};
		isDisabled = true;
	}

	private void Enable()
	{
		if (!isDisabled)
		{
			return;
		}
		icon.enabled = true;
		if (tween != null && !tween.isDone)
		{
			tween.Cancel();
		}
		tween = new Tween(null, scale, 1f, 1f, new CurveElastic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)base.gameObject)
			{
				scale = t.currentValue;
				base.gameObject.transform.localScale = Vector3.one * scale;
				if (fadeAlpha && (bool)canvasGroup)
				{
					canvasGroup.alpha = t.currentValue;
				}
			}
		});
		isDisabled = false;
		onBecomeVisible.Invoke();
	}
}
}
