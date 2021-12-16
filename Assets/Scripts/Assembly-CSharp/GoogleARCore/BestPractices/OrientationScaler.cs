using System.Collections.Generic;
using KeenTween;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class OrientationScaler : MonoBehaviour
{
	private static Dictionary<DeviceOrientation, bool> deviceOrientationToSwapState = new Dictionary<DeviceOrientation, bool>
	{
		{
			DeviceOrientation.Unknown,
			false
		},
		{
			DeviceOrientation.Portrait,
			true
		},
		{
			DeviceOrientation.PortraitUpsideDown,
			true
		},
		{
			DeviceOrientation.LandscapeLeft,
			false
		},
		{
			DeviceOrientation.LandscapeRight,
			false
		},
		{
			DeviceOrientation.FaceUp,
			false
		},
		{
			DeviceOrientation.FaceDown,
			false
		}
	};

	public bool immediateTransition;

	public UnityEvent onScaleChanged;

	private Tween tween;

	private void Start()
	{
		UpdateOrientationImmediate(OrientationManager.current.deviceOrientation);
	}

	private void OnEnable()
	{
		OrientationManager.current?.onDeviceOrientationChanged.AddListener(OnDeviceOrientationChanged);
	}

	private void OnDisable()
	{
		OrientationManager.current?.onDeviceOrientationChanged.AddListener(OnDeviceOrientationChanged);
	}

	private void OnDeviceOrientationChanged()
	{
		if (immediateTransition)
		{
			UpdateOrientationImmediate(OrientationManager.current.deviceOrientation);
		}
		else
		{
			UpdateOrientation(OrientationManager.current.deviceOrientation);
		}
	}

	private void UpdateOrientation(DeviceOrientation deviceOrientation)
	{
		RectTransform rt = base.transform as RectTransform;
		RectTransform rectTransform = base.transform.parent as RectTransform;
		bool flag = deviceOrientationToSwapState[deviceOrientation];
		Vector2 targetSize = rectTransform.rect.size;
		if (flag)
		{
			float x = targetSize.x;
			targetSize.x = targetSize.y;
			targetSize.y = x;
		}
		Vector2 baseSize = rt.sizeDelta;
		if (tween != null && !tween.isDone)
		{
			tween.Cancel();
		}
		tween = new Tween(null, 0f, 1f, 0.25f, new CurveQuadratic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)base.gameObject)
			{
				rt.sizeDelta = Vector2.Lerp(baseSize, targetSize, t.currentValue);
			}
		});
		tween.onFinish += delegate
		{
			if ((bool)base.gameObject && onScaleChanged != null)
			{
				onScaleChanged.Invoke();
			}
		};
	}

	private void UpdateOrientationImmediate(DeviceOrientation deviceOrientation)
	{
		RectTransform rectTransform = base.transform as RectTransform;
		RectTransform rectTransform2 = base.transform.parent as RectTransform;
		bool flag = deviceOrientationToSwapState[deviceOrientation];
		Vector2 size = rectTransform2.rect.size;
		if (flag)
		{
			float x = size.x;
			size.x = size.y;
			size.y = x;
		}
		rectTransform.sizeDelta = size;
		if (onScaleChanged != null)
		{
			onScaleChanged.Invoke();
		}
	}
}
}
