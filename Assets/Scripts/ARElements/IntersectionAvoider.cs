using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class IntersectionAvoider : MonoBehaviour
{
	private List<IntersectionAvoiderShape> shapeCache = new List<IntersectionAvoiderShape>();

	public bool TestOverlap(Vector3 position)
	{
		bool result = false;
		base.gameObject.GetComponentsInChildren(shapeCache);
		foreach (IntersectionAvoiderShape item in shapeCache)
		{
			Vector3 vector = base.transform.InverseTransformPoint(item.transform.position);
			Vector3 position2 = vector + position;
			if (item.TestOverlap(this, position2))
			{
				result = true;
				break;
			}
		}
		shapeCache.Clear();
		return result;
	}
}
}
