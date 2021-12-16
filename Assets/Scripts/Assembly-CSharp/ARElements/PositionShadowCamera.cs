using UnityEngine;

namespace ARElements{

public class PositionShadowCamera : MonoBehaviour
{
	[Tooltip("Offset from the main camera to position the shadow camera at.")]
	public Vector3 shadowCameraOffset = new Vector3(0f, 2f, 3f);

	[Tooltip("Distance from the main camera that causes the shadow camera to reposition itself.")]
	public float shadowRepositionThreshold = 1f;

	private void Update()
	{
		if (!(Camera.main == null))
		{
			Transform transform = Camera.main.transform;
			Vector3 vector = transform.position + new Vector3(0f, shadowCameraOffset.y, 0f);
			vector += new Vector3(transform.forward.x, 0f, transform.forward.z) * shadowCameraOffset.z;
			if (!(Vector3.Distance(vector, base.transform.position) < shadowRepositionThreshold))
			{
				base.transform.position = vector;
				base.transform.rotation = transform.rotation;
				base.transform.forward = Vector3.down;
			}
		}
	}
}
}
