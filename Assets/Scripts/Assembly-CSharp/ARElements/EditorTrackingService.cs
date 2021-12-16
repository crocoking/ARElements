using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class EditorTrackingService : MonoBehaviour, ITrackingService
{
	[Tooltip("List of mesh filters in the scene to use as simulated AR planes inside the editor.")]
	public List<MeshFilter> meshPlanes = new List<MeshFilter>();

	private List<EditorPlane> m_EditorPlanes = new List<EditorPlane>();

	private List<EditorPlane> m_AnnouncedPlanes = new List<EditorPlane>();

	public SessionStatus trackingState => SessionStatus.Tracking;

	public bool enabledOnPlatform => Application.isEditor;

	private void Start()
	{
		if (!Application.isEditor)
		{
			base.enabled = false;
			return;
		}
		foreach (MeshFilter meshPlane in meshPlanes)
		{
			EditorPlane item = new EditorPlane(meshPlane.transform, meshPlane.mesh);
			m_EditorPlanes.Add(item);
		}
	}

	public void AddPlane(EditorPlane plane)
	{
		if (plane == null)
		{
			Debug.LogError("Can't add null editor plane");
		}
		else
		{
			m_EditorPlanes.Add(plane);
		}
	}

	public void RemovePlane(EditorPlane plane)
	{
		if (plane == null)
		{
			Debug.LogError("Can't remove null plane");
		}
		else if (m_EditorPlanes.Contains(plane))
		{
			m_EditorPlanes.Add(plane);
		}
	}

	public void GetNewPlanes(ref List<ITrackedPlane> planes)
	{
		if (planes == null)
		{
			planes = new List<ITrackedPlane>();
		}
		foreach (EditorPlane editorPlane in m_EditorPlanes)
		{
			if (!m_AnnouncedPlanes.Contains(editorPlane))
			{
				planes.Add(editorPlane);
				m_AnnouncedPlanes.Add(editorPlane);
			}
		}
	}

	public void GetUpdatedPlanes(ref List<ITrackedPlane> planes)
	{
		if (m_AnnouncedPlanes.Count != 0)
		{
			int index = Mathf.RoundToInt(Random.value * (float)m_AnnouncedPlanes.Count) % m_AnnouncedPlanes.Count;
			planes.Add(m_AnnouncedPlanes[index]);
		}
	}
}
}
