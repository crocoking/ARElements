using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public abstract class PolygonMeshHelper
{
	public static List<Vector3> WorldToLocalPoints(List<Vector3> worldPoints, Transform planeTransform)
	{
		List<Vector3> list = new List<Vector3>();
		foreach (Vector3 worldPoint in worldPoints)
		{
			list.Add(planeTransform.InverseTransformPoint(worldPoint));
		}
		return list;
	}

	public static void ClockwiseSortVerticies(List<Vector3> verts)
	{
		verts.Sort(delegate(Vector3 a, Vector3 b)
		{
			float num = MathUtilities.Atan2Positive(a.z, a.x);
			float num2 = MathUtilities.Atan2Positive(b.z, b.x);
			return (num <= num2) ? 1 : (-1);
		});
	}

	public static void UpdateMesh(Mesh m, List<Vector3> worldPolygon, Transform planeTransform)
	{
		UpdateMesh(m, WorldToLocalPoints(worldPolygon, planeTransform));
	}

	public static void UpdateMesh(Mesh m, List<Vector3> localPolygonPoints)
	{
		if (m == null)
		{
			Debug.LogError("Can't update null mesh.");
			return;
		}
		ClockwiseSortVerticies(localPolygonPoints);
		List<Vector3> list = new List<Vector3>();
		List<int> list2 = new List<int>();
		List<Vector2> list3 = new List<Vector2>();
		List<Color> list4 = new List<Color>();
		Vector3 zero = Vector3.zero;
		list.Add(zero);
		list4.Add(Color.black);
		list3.Add(Vector2.zero);
		foreach (Vector3 localPolygonPoint in localPolygonPoints)
		{
			list.Add(localPolygonPoint);
			list3.Add(Vector3.one);
			list4.Add(Color.white);
		}
		int item = 1;
		for (int i = 1; i <= localPolygonPoints.Count; i++)
		{
			int num = i + 1;
			if (i == localPolygonPoints.Count)
			{
				num = 1;
			}
			list2.Add(0);
			list2.Add(item);
			list2.Add(num);
			item = num;
		}
		m.Clear();
		m.vertices = list.ToArray();
		m.uv = list3.ToArray();
		m.colors = list4.ToArray();
		m.triangles = list2.ToArray();
		m.RecalculateBounds();
	}
}
}
