using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class EditorPlane : ITrackedPlane
{
	public Transform transform;

	public Mesh mesh;

	public Vector3 position => transform.position;

	public Quaternion rotation => transform.rotation;

	public Vector2 size => new Vector2(mesh.bounds.size.x, mesh.bounds.size.z);

	public bool isUpdated { get; set; }

	public PlaneState planeState { get; set; }

	public List<Vector3> boundaryPoints
	{
		get
		{
			List<Vector3> list = new List<Vector3>();
			Vector3[] vertices = mesh.vertices;
			foreach (Vector3 vector in vertices)
			{
				Vector3 item = transform.TransformPoint(vector);
				list.Add(item);
			}
			return list;
		}
	}

	public EditorPlane(Transform transform, Mesh mesh)
	{
		this.transform = transform;
		this.mesh = mesh;
		planeState = PlaneState.Valid;
	}
}
}