using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ObjectSpawner : MonoBehaviour
{
	public GameObject objectTemplate;

	public float spawnTime = 1f;

	public float overlapRadius = 0.25f;

	public int maxInstanceCount = -1;

	private HashSet<GameObject> instances = new HashSet<GameObject>();

	private float lastOccupiedTime = float.NegativeInfinity;

	private static Collider[] overlapCache = new Collider[1024];

	private void Update()
	{
		instances.RemoveWhere((GameObject v) => !v);
		bool flag = false;
		int num = Physics.OverlapSphereNonAlloc(base.transform.position, overlapRadius, overlapCache);
		for (int i = 0; i < num; i++)
		{
			Collider collider = overlapCache[i];
			foreach (GameObject instance in instances)
			{
				if (collider.gameObject == instance || collider.transform.IsChildOf(instance.transform))
				{
					flag = true;
					break;
				}
			}
			if (flag)
			{
				break;
			}
		}
		if (flag)
		{
			lastOccupiedTime = Time.timeSinceLevelLoad;
		}
		if (Time.timeSinceLevelLoad - lastOccupiedTime > spawnTime && (maxInstanceCount < 0 || instances.Count < maxInstanceCount))
		{
			Spawn();
		}
	}

	private void Spawn()
	{
		GameObject gameObject = Object.Instantiate(objectTemplate, base.transform.position, Quaternion.identity, base.transform.parent);
		gameObject.transform.localRotation = base.transform.localRotation * objectTemplate.transform.localRotation;
		gameObject.SetActive(value: true);
		instances.Add(gameObject);
		lastOccupiedTime = Time.timeSinceLevelLoad;
	}

	private void OnDrawGizmos()
	{
		Gizmos.DrawWireSphere(base.transform.position, overlapRadius);
	}
}
}
