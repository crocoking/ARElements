using UnityEngine;

namespace ARElements{

public class IntersectionAvoiderSphere : IntersectionAvoiderShape
{
	public float radius = 0.5f;

	private float scaledRadius
	{
		get
		{
			Vector3 lossyScale = base.transform.lossyScale;
			float num = Mathf.Max(Mathf.Max(lossyScale.x, lossyScale.y), lossyScale.z);
			return radius * num;
		}
	}

	public override int GetOverlapCount(Vector3 position)
	{
		return Physics.OverlapSphereNonAlloc(position, scaledRadius, IntersectionAvoiderShape.colliderCache, layerMask, QueryTriggerInteraction.Ignore);
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.DrawWireSphere(base.transform.position, scaledRadius);
	}
}
}
