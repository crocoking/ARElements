using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class FeaturePointsVisualizer : MonoBehaviour
{
	public Color pointColor;

	public int maxPointCount = 1000;

	public float interval = 0.3f;

	private int defaultSize = 10;

	private int popSize = 50;

	private Mesh m_Mesh;

	private MeshRenderer m_MeshRenderer;

	[SerializeField]
	private FeaturePointLineVisualizer m_LineVisualizer;

	private MaterialPropertyBlock m_PropertyBlock;

	private double m_LastPointCloudTimestamp;

	private float m_LastUpdated;

	private List<Vector3> m_CachedPoints;

	private LinkedList<Vector3> m_UnvisitedPoints;

	private List<Vector2> m_CachedSizes;

	private List<int> m_CachedIndices;

	private Resolution m_CachedResolution;

	private Color m_CachedColor;

	private int m_MinPointCountForLineAnimation = 10;

	private FakePointCloud m_EditorPointCloud;

	private void Start()
	{
		m_MeshRenderer = GetComponent<MeshRenderer>();
		m_Mesh = GetComponent<MeshFilter>().mesh;
		if (m_Mesh == null)
		{
			m_Mesh = new Mesh();
		}
		m_Mesh.Clear();
		m_CachedResolution = Screen.currentResolution;
		m_CachedColor = pointColor;
		m_PropertyBlock = new MaterialPropertyBlock();
		m_MeshRenderer.GetPropertyBlock(m_PropertyBlock);
		m_PropertyBlock.SetColor("_Color", m_CachedColor);
		m_MeshRenderer.SetPropertyBlock(m_PropertyBlock);
		m_CachedPoints = new List<Vector3>();
		m_UnvisitedPoints = new LinkedList<Vector3>();
		m_CachedSizes = new List<Vector2>();
		m_CachedIndices = new List<int>();
		m_EditorPointCloud = Object.FindObjectOfType<FakePointCloud>();
	}

	private void OnDisable()
	{
		m_CachedPoints.Clear();
		m_UnvisitedPoints.Clear();
		m_CachedSizes.Clear();
		m_CachedIndices.Clear();
		m_Mesh.Clear();
	}

	private void UpdateResolution()
	{
		m_CachedResolution = Screen.currentResolution;
		if (m_MeshRenderer != null)
		{
			m_MeshRenderer.GetPropertyBlock(m_PropertyBlock);
			m_PropertyBlock.SetFloat("_ScreenWidth", m_CachedResolution.width);
			m_PropertyBlock.SetFloat("_ScreenHeight", m_CachedResolution.height);
			m_MeshRenderer.SetPropertyBlock(m_PropertyBlock);
		}
	}

	private void ShowPointsIncrementally()
	{
		if (Session.Status == SessionStatus.Tracking)
		{
			int count = m_CachedPoints.Count;
			if (count < maxPointCount && !(Time.time - m_LastUpdated < interval) && Frame.PointCloud.PointCount > count && Frame.PointCloud.IsUpdatedThisFrame)
			{
				Vector3 vector = Frame.PointCloud.GetPoint(Random.Range(0, Frame.PointCloud.PointCount - 1));
				m_CachedPoints.Add(vector);
				m_UnvisitedPoints.AddLast(vector);
				m_CachedIndices.Add(m_CachedIndices.Count);
				m_CachedSizes.Add(new Vector2(defaultSize, defaultSize));
				m_Mesh.Clear();
				m_Mesh.vertices = m_CachedPoints.ToArray();
				m_Mesh.uv = m_CachedSizes.ToArray();
				m_Mesh.SetIndices(m_CachedIndices.ToArray(), MeshTopology.Points, 0);
				m_LastUpdated = Time.time;
			}
		}
	}

	private void UpdatePointSize()
	{
		if (m_CachedSizes.Count > 0)
		{
			float num = (Time.time - m_LastUpdated) / interval;
			float num2 = 0f;
			num2 = ((!((double)num < 0.5)) ? Mathf.Lerp(popSize, defaultSize, (num - 0.5f) * 2f) : Mathf.Lerp(defaultSize, popSize, num * 2f));
			m_CachedSizes[m_CachedSizes.Count - 1] = new Vector2(num2, num2);
			m_Mesh.Clear();
			m_Mesh.vertices = m_CachedPoints.ToArray();
			m_Mesh.uv = m_CachedSizes.ToArray();
			m_Mesh.SetIndices(m_CachedIndices.ToArray(), MeshTopology.Points, 0);
		}
	}

	private void Update()
	{
		if (Screen.currentResolution.height != m_CachedResolution.height || Screen.currentResolution.width != m_CachedResolution.width)
		{
			UpdateResolution();
		}
		if (m_CachedColor != pointColor)
		{
			m_CachedColor = pointColor;
			m_MeshRenderer.GetPropertyBlock(m_PropertyBlock);
			m_PropertyBlock.SetColor("_Color", m_CachedColor);
			m_MeshRenderer.SetPropertyBlock(m_PropertyBlock);
		}
		UpdatePointSize();
		ShowPointsIncrementally();
		if (m_CachedPoints.Count > m_MinPointCountForLineAnimation)
		{
			m_LineVisualizer.UpdateLines(m_CachedPoints, m_UnvisitedPoints);
		}
	}
}
}
