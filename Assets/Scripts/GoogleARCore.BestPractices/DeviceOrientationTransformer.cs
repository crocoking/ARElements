using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class DeviceOrientationTransformer : MonoBehaviour
{
	[Serializable]
	public class Entry
	{
		public DeviceOrientation orientation;

		public Vector3 rotation;
	}

	private DeviceOrientation lastOrientation;

	public List<Entry> entires = new List<Entry>();

	private void LateUpdate()
	{
		DeviceOrientation deviceOrientation = OrientationManager.current.deviceOrientation;
		if (deviceOrientation != lastOrientation)
		{
			Entry entry = FindEntry(deviceOrientation);
			if (entry != null)
			{
				base.transform.localEulerAngles = entry.rotation;
			}
			else
			{
				base.transform.localEulerAngles = Vector3.zero;
			}
			lastOrientation = deviceOrientation;
		}
	}

	private Entry FindEntry(DeviceOrientation orientation)
	{
		foreach (Entry entire in entires)
		{
			if (entire.orientation == orientation)
			{
				return entire;
			}
		}
		return null;
	}
}
}
