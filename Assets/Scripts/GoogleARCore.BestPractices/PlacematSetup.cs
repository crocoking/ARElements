using ARElements;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class PlacematSetup : MonoBehaviour
{
	public SceneArea sceneAreaTemplate;

	public AnchorPlacemat anchorPlacematTemplate;

	public AutoTable autoTableTemplate;

	public UnityEvent onCommitted = new UnityEvent();

	public Texture2D dynamicGridMask;

	public float dynamicGridRange = 2f;

	public float desiredDistance = 1.5f;

	private static SceneArea sceneArea;

	private float dynamicGridMatrixScale = 1E-05f;

	private PlaneFocusPoint lastFocusPoint;

	private PlaneManagerRaycastHit lastBestFocusHit;

	public AnchorPlacemat anchorPlacemat { get; private set; }

	public AutoTable autoTable { get; private set; }

	public GameObject sceneRoot { get; set; }

	private void Awake()
	{
		anchorPlacemat = Object.Instantiate(anchorPlacematTemplate);
		anchorPlacemat.onCreateScene.AddListener(CommitPlacemat);
		autoTable = Object.Instantiate(autoTableTemplate);
		autoTable.gameObject.SetActive(value: false);
		autoTable.transform.SetParent(anchorPlacemat.transform);
	}

	private void Start()
	{
		if ((bool)sceneRoot && (bool)HologramRenderer.current)
		{
			HologramRenderer.current.AppendSceneRoot(sceneRoot);
			HologramRenderer.current.AppendSceneRoot(autoTable.gameObject);
		}
		ElementsSystem.instance.planeManager.EnableLayerType("DynamicGridPlaneLayer");
		GroundPlaneRangeOverride.SetOverride(dynamicGridRange);
		Shader.EnableKeyword("USE_DYNAMIC_GRID_EXPLICIT_MASK");
		Matrix4x4 value = Matrix4x4.Scale(Vector3.one / dynamicGridMatrixScale) * anchorPlacemat.transform.worldToLocalMatrix;
		Shader.SetGlobalMatrix("_DynamicGridExplicitMaskMatrix", value);
		Shader.SetGlobalTexture("_DynamicGridExplicitMask", dynamicGridMask);
	}

	private void OnDestroy()
	{
		Shader.DisableKeyword("USE_DYNAMIC_GRID_EXPLICIT_MASK");
	}

	private void LateUpdate()
	{
		if (!anchorPlacemat || (bool)sceneArea)
		{
			return;
		}
		if (!StableTrackingManager.current.isStableTracking)
		{
			if ((bool)anchorPlacemat)
			{
				anchorPlacemat.gameObject.SetActive(value: false);
			}
			return;
		}
		bool completeFit = false;
		if (!anchorPlacemat.isPlaced)
		{
			ElementsSystem.instance.planeFocusController.ClearFocusPoints();
			PlaneManagerRaycastHit planeManagerRaycastHit = FindBestFocusPoint();
			if (planeManagerRaycastHit.plane != null)
			{
				PlaneFocusPoint focusPoint = new PlaneFocusPoint(planeManagerRaycastHit.plane, planeManagerRaycastHit.point);
				ElementsSystem.instance.planeFocusController.AddFocusPoint(focusPoint);
			}
			PlaneFocusController planeFocusController = ElementsSystem.instance.planeFocusController;
			if (planeFocusController.focusPoints.Count > 0)
			{
				lastFocusPoint = planeFocusController.focusPoints[0];
				Vector3 forward = lastFocusPoint.worldPoint - Camera.main.transform.position;
				forward.y = 0f;
				Quaternion rotation = Quaternion.LookRotation(forward);
				anchorPlacemat.transform.localScale = Vector3.one;
				float num = 0f;
				if (lastFocusPoint.plane != null && lastFocusPoint.plane.planeState == PlaneState.Valid)
				{
					num = anchorPlacemat.TestCornerExtents(lastFocusPoint.plane, anchorPlacemat.transform.position);
				}
				completeFit = num >= anchorPlacemat.minScaleFactor;
				anchorPlacemat.transform.position = lastFocusPoint.worldPoint;
				anchorPlacemat.transform.rotation = rotation;
				anchorPlacemat.transform.localScale = Vector3.one * Mathf.Max(num, anchorPlacemat.minScaleFactor);
				anchorPlacemat.gameObject.SetActive(value: true);
			}
			else
			{
				anchorPlacemat.gameObject.SetActive(value: false);
			}
		}
		if (anchorPlacemat.gameObject.activeSelf)
		{
			UpdateHologramAndAutoTable(completeFit);
		}
		float b = ((!anchorPlacemat || !anchorPlacemat.gameObject.activeSelf) ? 1E-05f : 1f);
		dynamicGridMatrixScale = Mathf.Lerp(dynamicGridMatrixScale, b, 10f * Time.deltaTime);
		Matrix4x4 value = Matrix4x4.Scale(Vector3.one / dynamicGridMatrixScale) * anchorPlacemat.transform.worldToLocalMatrix;
		Shader.SetGlobalMatrix("_DynamicGridExplicitMaskMatrix", value);
	}

	private PlaneManagerRaycastHit FindBestFocusPoint()
	{
		Camera main = Camera.main;
		PlaneManager planeManager = ElementsSystem.instance.planeManager;
		float num = Mathf.PingPong(Vector3.Dot(main.transform.forward, Vector3.down), 0.5f) * 2f;
		Ray ray = new Ray(main.transform.position, (main.transform.forward + Vector3.down * 0.4f * (1f - num)).normalized);
		Vector3 vector = ray.origin + ray.direction * desiredDistance;
		bool flag = false;
		if (planeManager.Raycast(ray, out var hit))
		{
			float num2 = Vector3.Distance(ray.origin, hit.point);
			if (num2 < desiredDistance)
			{
				flag = true;
				vector = hit.point;
			}
		}
		if (!flag)
		{
			Ray ray2 = new Ray(vector + Vector3.up * 1E-05f, Vector3.down);
			planeManager.Raycast(ray2, out hit);
		}
		return hit;
	}

	private void UpdateHologramAndAutoTable(bool completeFit)
	{
		autoTable.UpdateHologram(!anchorPlacemat.isPlaced, completeFit);
		sceneRoot.transform.position = Vector3.Lerp(anchorPlacemat.holoScenePivot.position, autoTable.contentsPivot.position, autoTable.interpolationRatio);
		sceneRoot.transform.rotation = Quaternion.Slerp(anchorPlacemat.holoScenePivot.rotation, autoTable.contentsPivot.rotation, autoTable.interpolationRatio);
		sceneRoot.transform.localScale = anchorPlacemat.transform.localScale;
	}

	private void CommitPlacemat()
	{
		Transform transform = null;
		if (lastFocusPoint.plane is EditorPlane)
		{
			transform = new GameObject("Anchor").transform;
			transform.localPosition = anchorPlacemat.transform.position;
			transform.localRotation = anchorPlacemat.transform.rotation;
		}
		else if (lastFocusPoint.plane is AndroidPlane)
		{
			DetectedPlane trackedPlane = (lastFocusPoint.plane as AndroidPlane).trackedPlane;
			Anchor anchor = trackedPlane.CreateAnchor(new Pose(anchorPlacemat.transform.position, anchorPlacemat.transform.rotation));
			transform = anchor.transform;
		}
		if ((bool)sceneRoot && (bool)HologramRenderer.current)
		{
			HologramRenderer.current.ClearSceneRoots();
		}
		if (autoTable.hasAutoTable)
		{
			autoTable.transform.SetParent(transform, worldPositionStays: false);
			autoTable.transform.localPosition = Vector3.zero;
			autoTable.transform.localRotation = Quaternion.identity;
			autoTable.transform.localScale = anchorPlacemat.transform.localScale;
			autoTable.gameObject.SetActive(value: true);
			autoTable.Commit();
			sceneArea = Object.Instantiate(sceneAreaTemplate, autoTable.contentsPivot, worldPositionStays: false);
		}
		else
		{
			Object.Destroy(autoTable.gameObject);
			sceneArea = Object.Instantiate(sceneAreaTemplate, transform, worldPositionStays: false);
			sceneArea.transform.localScale = anchorPlacemat.transform.localScale;
		}
		anchorPlacemat.transform.SetParent(transform, worldPositionStays: false);
		anchorPlacemat.transform.localPosition = Vector3.zero;
		anchorPlacemat.transform.localRotation = Quaternion.identity;
		anchorPlacemat.transform.localScale = Vector3.one;
		sceneArea.sceneTransitionController.Fade(fadeIn: true);
		onCommitted.Invoke();
		SceneDescription sceneDescription = Object.FindObjectOfType<SceneDescription>();
		if (!sceneDescription || !sceneDescription.showGroundPlane)
		{
			ElementsSystem.instance.planeManager.DisableLayerType("DynamicGridPlaneLayer");
		}
		GroundPlaneRangeOverride.ClearOverride();
		Shader.DisableKeyword("USE_DYNAMIC_GRID_EXPLICIT_MASK");
		Object.Destroy(base.gameObject);
	}
}
}
