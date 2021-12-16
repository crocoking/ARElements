using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class FakePointCloud : MonoBehaviour
{
	public int pointCount = 1000;

	private List<Vector3> points;

	private void Start()
	{
		InitializePointCloud();
	}

	private void InitializePointCloud()
	{
		points = new List<Vector3>();
		for (int i = 0; i < pointCount; i++)
		{
			points.Add(new Vector3(Random.Range(-1f, 1f), Random.Range(-1f, 1f), Random.Range(-1f, 1f)));
		}
	}

	public Vector3 GetPoint(int i)
	{
		return points[i];
	}
}
}
