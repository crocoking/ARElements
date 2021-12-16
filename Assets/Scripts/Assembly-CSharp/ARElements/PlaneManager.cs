using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class PlaneManager : MonoBehaviour
{
	[Tooltip("Array of plane layers that will be stacked above the AR planes found in the scene.")]
	public List<PlaneLayer> planeLayerPrefabs = new List<PlaneLayer>();

	private List<ITrackingService> trackingServices = new List<ITrackingService>();

	public List<PlaneStack> planeStacks = new List<PlaneStack>();

	public int planeLayer;

	private List<ITrackedPlane> m_NewPlanes = new List<ITrackedPlane>();

	private List<ITrackedPlane> m_UpdatedPlanes = new List<ITrackedPlane>();

	private List<string> m_DisabledLayers = new List<string>();

	private List<PlaneStack> m_StacksToRemove = new List<PlaneStack>();

	private Dictionary<ITrackedPlane, PlaneStack> m_PlaneToStack = new Dictionary<ITrackedPlane, PlaneStack>();

	private void Awake()
	{
		ITrackingService[] components = base.gameObject.GetComponents<ITrackingService>();
		foreach (ITrackingService trackingService in components)
		{
			if (trackingService.enabledOnPlatform)
			{
				trackingServices.Add(trackingService);
			}
		}
		if (trackingServices.Count <= 0)
		{
			base.enabled = false;
			throw new UnityException("No tracking services found for current platform.");
		}
	}

	public PlaneStack GetPlaneStack(ITrackedPlane plane)
	{
		if (!m_PlaneToStack.ContainsKey(plane))
		{
			return null;
		}
		return m_PlaneToStack[plane];
	}

	public void EnableLayerType(string layerType)
	{
		if (!m_DisabledLayers.Contains(layerType))
		{
			return;
		}
		m_DisabledLayers.Remove(layerType);
		foreach (PlaneStack planeStack in planeStacks)
		{
			planeStack.EnableLayerType(layerType);
		}
	}

	public void DisableLayerType(string layerType)
	{
		if (m_DisabledLayers.Contains(layerType))
		{
			return;
		}
		m_DisabledLayers.Add(layerType);
		foreach (PlaneStack planeStack in planeStacks)
		{
			planeStack.DisableLayerType(layerType);
		}
	}

	private void Update()
	{
		CheckForRemovedPlanes();
		CheckForAddedPlanes();
		CheckForUpdatedPlanes();
	}

	private void CheckForAddedPlanes()
	{
		m_NewPlanes.Clear();
		foreach (ITrackingService trackingService in trackingServices)
		{
			if (trackingService.trackingState == SessionStatus.Tracking)
			{
				trackingService.GetNewPlanes(ref m_NewPlanes);
			}
		}
		HandleNewPlanes(m_NewPlanes);
	}

	public void HandleNewPlanes(List<ITrackedPlane> newPlanes)
	{
		foreach (ITrackedPlane newPlane in newPlanes)
		{
			GameObject gameObject = new GameObject();
			gameObject.layer = planeLayer;
			gameObject.name = "PlaneStack";
			gameObject.AddComponent<PlaneStack>();
			gameObject.transform.parent = base.transform;
			gameObject.transform.position = newPlane.position;
			gameObject.AddComponent<MeshCollider>();
			PlaneStack component = gameObject.GetComponent<PlaneStack>();
			if (component == null)
			{
				Debug.LogError("Plane prefab must contain a PlaneStack component or subclass.");
				continue;
			}
			component.transform.localScale = Vector3.one;
			component.transform.position = newPlane.position;
			component.transform.rotation = newPlane.rotation;
			planeStacks.Add(component);
			m_PlaneToStack.Add(newPlane, component);
			component.CreatePlaneLayers(newPlane, planeLayerPrefabs, m_DisabledLayers);
		}
	}

	private void CheckForRemovedPlanes()
	{
		m_StacksToRemove.Clear();
		foreach (PlaneStack planeStack in planeStacks)
		{
			if (planeStack.shouldDestroy)
			{
				m_StacksToRemove.Add(planeStack);
			}
		}
		foreach (PlaneStack item in m_StacksToRemove)
		{
			planeStacks.Remove(item);
			if (m_PlaneToStack.ContainsKey(item.plane))
			{
				m_PlaneToStack.Remove(item.plane);
			}
			Object.Destroy(item.gameObject);
		}
	}

	private void CheckForUpdatedPlanes()
	{
		m_UpdatedPlanes.Clear();
		foreach (ITrackingService trackingService in trackingServices)
		{
			if (trackingService.trackingState == SessionStatus.Tracking)
			{
				trackingService.GetUpdatedPlanes(ref m_UpdatedPlanes);
			}
		}
		foreach (ITrackedPlane updatedPlane in m_UpdatedPlanes)
		{
			foreach (PlaneStack planeStack in planeStacks)
			{
				if (planeStack.plane == updatedPlane)
				{
					planeStack.RebuildPlaneMesh();
				}
			}
		}
	}

	public bool Raycast(Ray ray, out PlaneManagerRaycastHit hit)
	{
		hit = default(PlaneManagerRaycastHit);
		float num = float.PositiveInfinity;
		foreach (PlaneStack planeStack in planeStacks)
		{
			if (planeStack.GetComponent<Collider>().Raycast(ray, out var hitInfo, 100f) && hitInfo.distance < num)
			{
				hit.plane = hitInfo.collider.GetComponent<PlaneStack>().plane;
				hit.point = hitInfo.point;
				num = hitInfo.distance;
			}
		}
		return num != float.PositiveInfinity;
	}
}
}
