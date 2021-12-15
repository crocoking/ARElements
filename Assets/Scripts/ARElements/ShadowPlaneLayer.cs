namespace ARElements{

public class ShadowPlaneLayer : PlaneLayer
{
	public override string layerType => "ShadowPlaneLayer";

	public override bool shouldRender => (bool)ElementsSystem.instance.shadowController && ElementsSystem.instance.shadowController.isActiveAndEnabled;
}
}
