using UnityEngine;

namespace GoogleARCore.BestPractices{

[ExecuteInEditMode]
public class RenderDepth : MonoBehaviour
{
	private void OnPreCull()
	{
		Camera component = base.gameObject.GetComponent<Camera>();
		if ((bool)component)
		{
			component.depthTextureMode |= DepthTextureMode.Depth;
		}
	}
}
}
