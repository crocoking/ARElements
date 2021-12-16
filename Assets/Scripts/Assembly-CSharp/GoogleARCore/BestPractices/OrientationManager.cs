using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class OrientationManager : MonoBehaviour
{
	private static OrientationManager _current;

	public DeviceOrientation defaultOrientation;

	public UnityEvent onDeviceOrientationChanged;

	public static OrientationManager current
	{
		[CompilerGenerated]
		get
		{
			return _current ? _current : (_current = Object.FindObjectOfType<OrientationManager>());
		}
	}

	public DeviceOrientation deviceOrientation { get; private set; }

	private void Awake()
	{
		deviceOrientation = defaultOrientation;
		Object.DontDestroyOnLoad(base.gameObject);
	}

	private void Update()
	{
		DeviceOrientation deviceOrientation = Input.deviceOrientation;
		if ((Application.isEditor || (deviceOrientation != 0 && deviceOrientation != DeviceOrientation.FaceDown && deviceOrientation != DeviceOrientation.FaceUp)) && this.deviceOrientation != deviceOrientation)
		{
			this.deviceOrientation = deviceOrientation;
			if (onDeviceOrientationChanged != null)
			{
				onDeviceOrientationChanged.Invoke();
			}
		}
	}
}
}
