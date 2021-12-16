using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class PlaneStack : MonoBehaviour
{
	[Tooltip("The padding between the vertical plane layers.")]
	public float layerPadding = 0.001f;

	[HideInInspector]
	public List<PlaneLayer> planeLayers = new List<PlaneLayer>();

	private Mesh m_Mesh;

	private HashSet<string> m_DisabledLayers = new HashSet<string>();

	public ITrackedPlane plane { get; private set; }

	public bool shouldDestroy { get; private set; }

	public bool isValid { get; private set; }

	public void CreatePlaneLayers(ITrackedPlane plane, List<PlaneLayer> planeLayerPrefabs, List<string> disabledLayers)
	{
		this.plane = plane;
		m_DisabledLayers.Clear();
		foreach (string disabledLayer in disabledLayers)
		{
			m_DisabledLayers.Add(disabledLayer);
		}
		for (int i = 0; i < planeLayerPrefabs.Count; i++)
		{
			PlaneLayer original = planeLayerPrefabs[i];
			PlaneLayer planeLayer = Object.Instantiate(original, base.transform);
			if (planeLayer == null)
			{
				Debug.LogError("Invalid plane layer prefab, it must contain a PlaneLayer component or subclass.");
				continue;
			}
			planeLayer.plane = plane;
			planeLayer.transform.localPosition = new Vector3(0f, (float)(i + 1) * layerPadding, 0f);
			planeLayer.transform.localRotation = Quaternion.identity;
			planeLayers.Add(planeLayer);
		}
		RebuildPlaneMesh();
		isValid = true;
		shouldDestroy = false;
	}

	private void Update()
	{
		if (plane == null)
		{
			return;
		}
		if (plane.planeState == PlaneState.Replaced)
		{
			shouldDestroy = true;
		}
		else if (plane.planeState == PlaneState.Invalid)
		{
			if (isValid)
			{
				isValid = false;
			}
		}
		else if (!isValid)
		{
			isValid = true;
		}
	}

	public void EnableLayerType(string layerType)
	{
		if (layerType == null)
		{
			Debug.LogError("Can't enable layer with null type.");
		}
		else if (m_DisabledLayers.Contains(layerType))
		{
			m_DisabledLayers.Remove(layerType);
		}
	}

	public void DisableLayerType(string layerType)
	{
		if (layerType == null)
		{
			Debug.LogError("Can't disable layer with null type");
		}
		else if (!m_DisabledLayers.Contains(layerType))
		{
			m_DisabledLayers.Add(layerType);
		}
	}

	public void RebuildPlaneMesh()
	{
		List<Vector3> boundaryPoints = plane.boundaryPoints;
		RebuildMesh(boundaryPoints);
	}

	private void RebuildMesh(List<Vector3> worldPolygon)
	{
		base.transform.position = plane.position;
		base.transform.rotation = plane.rotation;
		if (m_Mesh == null)
		{
			m_Mesh = new Mesh();
			m_Mesh.MarkDynamic();
		}
		PolygonMeshHelper.UpdateMesh(m_Mesh, worldPolygon, base.transform);
		MeshCollider component = GetComponent<MeshCollider>();
		if (component != null)
		{
			component.sharedMesh = m_Mesh;
		}
		foreach (PlaneLayer planeLayer in planeLayers)
		{
			planeLayer.UpdateMesh(m_Mesh);
		}
	}

	public PlaneLayer GetLayer(string type)
	{
		foreach (PlaneLayer planeLayer in planeLayers)
		{
			if (planeLayer.layerType == type)
			{
				return planeLayer;
			}
		}
		return null;
	}

	public PlaneLayer GetLayer<T>()
	{
		foreach (PlaneLayer planeLayer in planeLayers)
		{
			if (planeLayer is T)
			{
				return planeLayer;
			}
		}
		return null;
	}

	public bool IsLayerTypeDisabled(string layerType)
	{
		return m_DisabledLayers.Contains(layerType);
	}
}
}
