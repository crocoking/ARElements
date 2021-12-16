using ARElements;

namespace GoogleARCore.BestPractices{

public class PlacematPlaneDiscoveryRule : PlaneDiscoveryRule
{
	public PlacematSetup placematSetup;

	public override bool GetPlaneDiscoveryState()
	{
		return !placematSetup.anchorPlacemat.gameObject.activeSelf;
	}
}
}
