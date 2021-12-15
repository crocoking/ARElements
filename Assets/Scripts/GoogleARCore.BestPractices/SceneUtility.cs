using UnityEngine;

namespace GoogleARCore.BestPractices{

public static class SceneUtility
{
	public static float GetBottomOfGameObjectColliders(GameObject gameObject)
	{
		Collider[] componentsInChildren = gameObject.GetComponentsInChildren<Collider>();
		float num = float.PositiveInfinity;
		Collider[] array = componentsInChildren;
		foreach (Collider collider in array)
		{
			if (!collider.isTrigger)
			{
				float magnitude = collider.bounds.extents.magnitude;
				float b = collider.ClosestPointOnBounds(collider.bounds.center + Vector3.down * magnitude * 2f).y - gameObject.transform.position.y;
				num = Mathf.Min(num, b);
			}
		}
		if (num != float.PositiveInfinity)
		{
			return num;
		}
		return 0f;
	}
}
}
