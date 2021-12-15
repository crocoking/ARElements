using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SpatialTracking;

namespace ARElements{

[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public class FeaturePointLineVisualizer : MonoBehaviour
{
	[Tooltip("Width of the lines.")]
	public float lineWidth = 0.001f;

	[Tooltip("Length of the animated lines.")]
	public float lineLength = 1f;

	[Tooltip("Speed of the animated lines.")]
	public float lineSpeed = 1f;

	[Tooltip("Number of lines to show at the same time.")]
	public int lineNum = 3;

	[Tooltip("Color of the lines.")]
	public Color lineColor;

	private Color m_CachedColor;

	private Mesh m_LineMesh;

	private MeshRenderer m_LineMeshRenderer;

	private MaterialPropertyBlock m_PropertyBlock;

	private List<AnimatedFeaturePointLine> m_Lines;

	private List<Vector3> m_CachedPoints;

	private LinkedList<Vector3> m_UnvisitedPoints;

	private Camera m_ARCoreCamera;

	public void SetWidth(float width)
	{
		lineWidth = width;
	}

	public void SetLength(float length)
	{
		if (m_Lines == null)
		{
			return;
		}
		foreach (AnimatedFeaturePointLine line in m_Lines)
		{
			line.SetLength(length);
		}
	}

	public void SetSpeed(float speed)
	{
		if (m_Lines == null)
		{
			return;
		}
		foreach (AnimatedFeaturePointLine line in m_Lines)
		{
			line.SetSpeed(speed);
		}
	}

	public void SetNum(int num)
	{
		if (m_Lines == null)
		{
			m_Lines = new List<AnimatedFeaturePointLine>();
		}
		m_Lines.Clear();
		for (int i = 0; i < num; i++)
		{
			m_Lines.Add(new AnimatedFeaturePointLine(lineLength, lineSpeed, m_CachedPoints, m_UnvisitedPoints, m_ARCoreCamera));
		}
	}

	private void Start()
	{
		Camera[] allCameras = Camera.allCameras;
		foreach (Camera camera in allCameras)
		{
			if (camera.GetComponent<TrackedPoseDriver>() != null)
			{
				m_ARCoreCamera = camera;
				break;
			}
		}
		m_LineMeshRenderer = GetComponent<MeshRenderer>();
		m_LineMesh = GetComponent<MeshFilter>().mesh;
		if (m_LineMesh == null)
		{
			m_LineMesh = new Mesh();
		}
		m_LineMesh.Clear();
		m_PropertyBlock = new MaterialPropertyBlock();
		m_CachedColor = lineColor;
		m_LineMeshRenderer.GetPropertyBlock(m_PropertyBlock);
		m_PropertyBlock.SetColor("_Color", m_CachedColor);
		m_LineMeshRenderer.SetPropertyBlock(m_PropertyBlock);
	}

	private void OnDisable()
	{
		m_LineMesh.Clear();
		m_Lines.Clear();
	}

	private void UpdateMeshWithWidth()
	{
		List<Vector3> list = new List<Vector3>();
		List<int> list2 = new List<int>();
		Vector3 lhs = Vector3.up;
		if (m_ARCoreCamera != null)
		{
			lhs = -1f * m_ARCoreCamera.transform.forward;
		}
		for (int i = 0; i < m_Lines.Count; i++)
		{
			List<Vector3> points = m_Lines[i].GetPoints();
			for (int j = 0; j < points.Count - 1; j++)
			{
				Vector3 vector = points[j];
				Vector3 vector2 = points[j + 1];
				Vector3 normalized = Vector3.Cross(lhs, vector2 - vector).normalized;
				list.Add(vector + normalized * lineWidth / 2f);
				list.Add(vector - normalized * lineWidth / 2f);
				list.Add(vector2 + normalized * lineWidth / 2f);
				list.Add(vector2 - normalized * lineWidth / 2f);
			}
		}
		int num = 0;
		int num2 = 0;
		while (num < list.Count)
		{
			list2.Add(num2 * 4);
			list2.Add(num2 * 4 + 1);
			list2.Add(num2 * 4 + 2);
			list2.Add(num2 * 4 + 1);
			list2.Add(num2 * 4 + 3);
			list2.Add(num2 * 4 + 2);
			num += 4;
			num2++;
		}
		m_LineMesh.Clear();
		m_LineMesh.vertices = list.ToArray();
		m_LineMesh.triangles = list2.ToArray();
		if (m_CachedColor != lineColor)
		{
			m_CachedColor = lineColor;
			m_LineMeshRenderer.GetPropertyBlock(m_PropertyBlock);
			m_PropertyBlock.SetColor("_Color", m_CachedColor);
			m_LineMeshRenderer.SetPropertyBlock(m_PropertyBlock);
		}
	}

	private void UpdateMeshWithoutWidth()
	{
		List<Vector3> list = new List<Vector3>();
		List<int> list2 = new List<int>();
		for (int i = 0; i < m_Lines.Count; i++)
		{
			List<Vector3> points = m_Lines[i].GetPoints();
			list.AddRange(points);
			for (int j = 0; j < points.Count - 1; j++)
			{
				list2.Add(list.Count - 1 - j);
				list2.Add(list.Count - 2 - j);
			}
		}
		m_LineMesh.Clear();
		m_LineMesh.vertices = list.ToArray();
		m_LineMesh.SetIndices(list2.ToArray(), MeshTopology.Lines, 0);
		if (m_CachedColor != lineColor)
		{
			m_CachedColor = lineColor;
			m_LineMeshRenderer.GetPropertyBlock(m_PropertyBlock);
			m_PropertyBlock.SetColor("_Color", m_CachedColor);
			m_LineMeshRenderer.SetPropertyBlock(m_PropertyBlock);
		}
	}

	public void UpdateLines(List<Vector3> points, LinkedList<Vector3> unvisited)
	{
		if (m_CachedPoints == null)
		{
			m_CachedPoints = points;
		}
		if (m_UnvisitedPoints == null)
		{
			m_UnvisitedPoints = unvisited;
		}
		if (m_Lines == null)
		{
			m_Lines = new List<AnimatedFeaturePointLine>();
		}
		if (m_Lines.Count != lineNum)
		{
			m_Lines.Clear();
			for (int i = 0; i < lineNum; i++)
			{
				m_Lines.Add(new AnimatedFeaturePointLine(lineLength, lineSpeed, m_CachedPoints, m_UnvisitedPoints, m_ARCoreCamera));
			}
		}
		for (int j = 0; j < m_Lines.Count; j++)
		{
			m_Lines[j].UpdateLine();
		}
		UpdateMeshWithoutWidth();
	}
}
}
