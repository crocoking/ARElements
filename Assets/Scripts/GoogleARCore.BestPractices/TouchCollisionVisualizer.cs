using UnityEngine;

namespace GoogleARCore.BestPractices{

public class TouchCollisionVisualizer : MonoBehaviour
{
	public Reticle reticle;

	public CollisionScaler collisionScaler;

	public float scaleFactor = 1f;

	private void Update()
	{
		collisionScaler.CalculateScaledRadius(out var viewRadius, out var _);
		Vector3 lossyScale = collisionScaler.sphereCollider.transform.lossyScale;
		float num = Mathf.Max(lossyScale.x, lossyScale.y, lossyScale.z);
		base.transform.localScale = Vector3.one * scaleFactor * viewRadius * num;
	}
}
}
