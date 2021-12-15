using UnityEngine;

[ExecuteInEditMode]
public class TurnOnDepthTexture : MonoBehaviour
{
	private void Awake()
	{
		if (Camera.main != null)
		{
			Camera.main.depthTextureMode |= DepthTextureMode.Depth;
		}
	}
}
