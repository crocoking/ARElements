using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public static class ScreenOrientationToDeviceOrientation
{
	private static Quaternion m_Rotation = Quaternion.identity;

	private static DeviceOrientation m_PrevDeviceOrientation;

	private static ScreenOrientation m_PrevScreenOrientation;

	private static readonly Dictionary<DeviceOrientation, int> k_DeviceOrientationToAngle = new Dictionary<DeviceOrientation, int>
	{
		{
			DeviceOrientation.LandscapeLeft,
			0
		},
		{
			DeviceOrientation.Portrait,
			90
		},
		{
			DeviceOrientation.LandscapeRight,
			180
		},
		{
			DeviceOrientation.PortraitUpsideDown,
			270
		}
	};

	private static readonly Dictionary<ScreenOrientation, int> k_ScreenOrientationToAngle = new Dictionary<ScreenOrientation, int>
	{
		{
			ScreenOrientation.LandscapeLeft,
			0
		},
		{
			ScreenOrientation.Portrait,
			90
		},
		{
			ScreenOrientation.LandscapeRight,
			180
		},
		{
			ScreenOrientation.PortraitUpsideDown,
			270
		}
	};

	public static Quaternion GetRotation()
	{
		SyncOrientation();
		return m_Rotation;
	}

	public static Vector2 Rotate(Vector2 directionOnScreen)
	{
		SyncOrientation();
		return m_Rotation * directionOnScreen;
	}

	private static void SyncOrientation()
	{
		if (m_PrevDeviceOrientation == Input.deviceOrientation && m_PrevScreenOrientation == Screen.orientation)
		{
			return;
		}
		m_PrevScreenOrientation = Screen.orientation;
		int value = 0;
		if (k_ScreenOrientationToAngle.TryGetValue(m_PrevScreenOrientation, out value))
		{
			m_PrevDeviceOrientation = Input.deviceOrientation;
			if (k_DeviceOrientationToAngle.TryGetValue(m_PrevDeviceOrientation, out var value2))
			{
				m_Rotation = Quaternion.AngleAxis(value2 - value, Vector3.forward);
			}
		}
	}
}
}
