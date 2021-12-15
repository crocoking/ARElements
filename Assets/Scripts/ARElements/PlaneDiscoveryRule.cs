using UnityEngine;

namespace ARElements{

public class PlaneDiscoveryRule : MonoBehaviour
{
	protected virtual void OnEnable()
	{
		if ((bool)ElementsSystem.instance && (bool)ElementsSystem.instance.planeDiscovery)
		{
			ElementsSystem.instance.planeDiscovery.RegisterPlaneDiscoveryRule(this);
		}
	}

	protected virtual void OnDisable()
	{
		if ((bool)ElementsSystem.instance && (bool)ElementsSystem.instance.planeDiscovery)
		{
			ElementsSystem.instance.planeDiscovery.UnregisterPlaneDiscoveryRule(this);
		}
	}

	public virtual bool GetPlaneDiscoveryState()
	{
		return false;
	}
}
}