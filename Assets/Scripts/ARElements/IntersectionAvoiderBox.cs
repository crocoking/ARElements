using UnityEngine;

namespace ARElements{

public class IntersectionAvoiderBox : IntersectionAvoiderShape
{
	public Vector3 size = Vector3.one;

	public override int GetOverlapCount(Vector3 position)
	{
		Vector3 vector = Vector3.Scale(size, base.transform.lossyScale);
		return Physics.OverlapBoxNonAlloc(position, vector / 2f, IntersectionAvoiderShape.colliderCache, base.transform.rotation, layerMask, QueryTriggerInteraction.Ignore);
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.matrix = Matrix4x4.TRS(base.transform.position, base.transform.rotation, Vector3.one);
		Vector3 vector = Vector3.Scale(size, base.transform.lossyScale);
		Gizmos.DrawWireCube(Vector3.zero, vector);
	}
}
}
