using System.Linq;
using UnityEngine;

namespace ARElements{

public class IntersectionAvoiderShape : MonoBehaviour
{
	public LayerMask layerMask = -1;

	protected static Collider[] colliderCache = new Collider[1024];

	public virtual int GetOverlapCount(Vector3 position)
	{
		return 0;
	}

	public bool TestOverlap(IntersectionAvoider avoider, Vector3 position)
	{
		return FilterCount(avoider, GetOverlapCount(position)) > 0;
	}

	private int FilterCount(IntersectionAvoider avoider, int count)
	{
		return (from v in colliderCache.Take(count)
			where !v.transform.IsChildOf(avoider.transform) && v.gameObject != avoider.gameObject
			select v).Count();
	}
}
}
