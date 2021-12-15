using System.Collections.Generic;
using KeenTween;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class OrientationRotator : MonoBehaviour
{
	private static Dictionary<DeviceOrientation, int> deviceOrientationToRotationDegrees = new Dictionary<DeviceOrientation, int>
	{
		{
			DeviceOrientation.Unknown,
			0
		},
		{
			DeviceOrientation.Portrait,
			90
		},
		{
			DeviceOrientation.PortraitUpsideDown,
			90
		},
		{
			DeviceOrientation.LandscapeLeft,
			0
		},
		{
			DeviceOrientation.LandscapeRight,
			180
		},
		{
			DeviceOrientation.FaceUp,
			0
		},
		{
			DeviceOrientation.FaceDown,
			0
		}
	};

	public bool immediateTransition;

	public bool useOrientationPivots;

	public List<Vector2> orientationPivots = new List<Vector2>();

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
		float angle = deviceOrientationToRotationDegrees[deviceOrientation];
		Quaternion targetRotation = Quaternion.AngleAxis(angle, Vector3.forward);
		Quaternion baseRotation = base.transform.localRotation;
		float totalAngleChange = Quaternion.Angle(baseRotation, targetRotation);
		RectTransform rectTransform = base.transform as RectTransform;
		bool usePivot = useOrientationPivots && orientationPivots.Count >= 4 && (bool)rectTransform;
		Vector2 basePivot = Vector2.zero;
		Vector2 targetPivot = Vector2.zero;
		if (usePivot)
		{
			basePivot = rectTransform.pivot;
			targetPivot = orientationPivots[OrientationToIndex(deviceOrientation)];
		}
		if (tween != null && !tween.isDone)
		{
			tween.Cancel();
		}
		tween = new Tween(null, 0f, 1f, 0.25f, new CurveQuadratic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)base.gameObject)
			{
				base.transform.localRotation = Quaternion.RotateTowards(baseRotation, targetRotation, totalAngleChange * t.currentValue);
				if (usePivot)
				{
					rectTransform.pivot = Vector2.Lerp(basePivot, targetPivot, t.currentValue);
				}
			}
		});
	}

	private void UpdateOrientationImmediate(DeviceOrientation deviceOrientation)
	{
		float angle = deviceOrientationToRotationDegrees[deviceOrientation];
		Quaternion localRotation = Quaternion.AngleAxis(angle, Vector3.forward);
		base.transform.localRotation = localRotation;
		if (useOrientationPivots && orientationPivots.Count >= 4 && base.transform is RectTransform)
		{
			int index = OrientationToIndex(deviceOrientation);
			RectTransform rectTransform = (RectTransform)base.transform;
			rectTransform.pivot = orientationPivots[index];
		}
	}

	private static int OrientationToIndex(DeviceOrientation deviceOrientation)
	{
		switch(deviceOrientation)
		{
			case DeviceOrientation.Portrait : return 1; 
			case DeviceOrientation.PortraitUpsideDown  : return 3; 
			case DeviceOrientation.LandscapeLeft  : return 0;
			case DeviceOrientation.LandscapeRight  : return 2;
				default: return 0; 
		};
	}
}
}
