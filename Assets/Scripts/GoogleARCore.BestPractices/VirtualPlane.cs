using System.Collections.Generic;
using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class VirtualPlane : MonoBehaviour, ITrackedPlane
{
	public List<Transform> points = new List<Transform>();

	private List<Vector3> worldPoints = new List<Vector3>();

	private Vector3 lastWorldPointPosition;

	private Quaternion lastWorldPointRotation;

	private Vector3 lastWorldPointScale;

	private Vector2 cachedSize;

	public Vector3 position => base.transform.position;

	public Quaternion rotation => base.transform.rotation;

	public Vector2 size
	{
		get
		{
			if (!this)
			{
				return Vector2.zero;
			}
			UpdateWorldPointsIfNeeded();
			return cachedSize;
		}
	}

	public bool isUpdated { get; set; }

	public PlaneState planeState { get; private set; }

	public List<Vector3> boundaryPoints
	{
		get
		{
			if (!this)
			{
				return worldPoints;
			}
			UpdateWorldPointsIfNeeded();
			return worldPoints;
		}
	}

	private void OnEnable()
	{
		VirtualPlaneTrackingService virtualPlaneTrackingService = (((object)ElementsSystem.instance != null) ? ElementsSystem.instance.planeManager.gameObject.GetComponent<VirtualPlaneTrackingService>() : null);
		if ((bool)virtualPlaneTrackingService)
		{
			virtualPlaneTrackingService.AddPlane(this);
		}
		else
		{
			Debug.LogWarning(string.Format("Could not register {0} because {1} was not found.", "VirtualPlane", "VirtualPlaneTrackingService"));
		}
		planeState = PlaneState.Valid;
	}

	private void OnDisable()
	{
		VirtualPlaneTrackingService virtualPlaneTrackingService = (((object)ElementsSystem.instance != null) ? ElementsSystem.instance.planeManager.gameObject.GetComponent<VirtualPlaneTrackingService>() : null);
		if ((bool)virtualPlaneTrackingService)
		{
			virtualPlaneTrackingService.RemovePlane(this);
		}
		else
		{
			Debug.LogWarning(string.Format("Could not unregister {0} because {1} was not found.", "VirtualPlane", "VirtualPlaneTrackingService"));
		}
		planeState = PlaneState.Replaced;
	}

	private void LateUpdate()
	{
		PlaneManager planeManager = (((object)ElementsSystem.instance != null) ? ElementsSystem.instance.planeManager : null);
		if (!planeManager)
		{
			return;
		}
		PlaneStack planeStack = planeManager.GetPlaneStack(this);
		if (!planeStack)
		{
			return;
		}
		bool flag = false;
		if (planeStack.transform.position != base.transform.position)
		{
			planeStack.transform.position = base.transform.position;
			flag = true;
		}
		if (planeStack.transform.rotation != base.transform.rotation)
		{
			planeStack.transform.rotation = base.transform.rotation;
			flag = true;
		}
		if (!flag)
		{
			return;
		}
		foreach (PlaneLayer planeLayer in planeStack.planeLayers)
		{
			planeLayer.UpdateMesh(planeLayer.mesh);
		}
	}

	private void UpdateWorldPointsIfNeeded()
	{
		UpdatePositionCache();
		if (worldPoints.Count == points.Count)
		{
			return;
		}
		UpdateWorldPoints();
		cachedSize = Vector2.zero;
		if (worldPoints.Count > 0)
		{
			Bounds bounds = new Bounds(worldPoints[0], Vector3.zero);
			for (int i = 1; i < worldPoints.Count; i++)
			{
				bounds.Encapsulate(worldPoints[i]);
			}
			cachedSize = new Vector2(bounds.size.x, bounds.size.z);
		}
	}

	private void UpdateWorldPoints()
	{
		worldPoints.Clear();
		foreach (Transform point in points)
		{
			worldPoints.Add(point.position);
		}
	}

	private void UpdatePositionCache()
	{
		if (base.transform.position != lastWorldPointPosition || base.transform.rotation != lastWorldPointRotation || base.transform.lossyScale != lastWorldPointScale)
		{
			lastWorldPointPosition = base.transform.position;
			lastWorldPointRotation = base.transform.rotation;
			lastWorldPointScale = base.transform.lossyScale;
			worldPoints.Clear();
		}
	}

	public void MakePointsDirty()
	{
		worldPoints.Clear();
		isUpdated = true;
	}
}
}
