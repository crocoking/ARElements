using ARElements;
using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class FrogSceneController : MonoBehaviour
{
	public LayerMask reticleHideLayerMask;

	public JumpingFrog jumpingFrog;

	public BackgroundPressDetection backgroundPressDetection;

	public VolumetricTargetingReticle targetingReticle;

	public RaycastGrabberLine line;

	public Button jumpButton;

	public CanvasGroup jumpButtonCanvasGroup;

	public Button reticleTapButton;

	private bool isInPlacementMode = true;

	private bool canPlaceLocator;

	private static Collider[] overlapCache = new Collider[1];

	private void Start()
	{
		backgroundPressDetection.onPress.AddListener(OnPress);
		jumpButton.onClick.AddListener(OnPressButton);
		reticleTapButton.onClick.AddListener(OnPressButton);
		if ((bool)jumpButtonCanvasGroup)
		{
			jumpButtonCanvasGroup.alpha = 0f;
			jumpButtonCanvasGroup.blocksRaycasts = false;
		}
		targetingReticle.visible = true;
	}

	private void LateUpdate()
	{
		PlaneFocusPoint focusPoint = GetFocusPoint();
		canPlaceLocator = isInPlacementMode && focusPoint?.plane != null && (bool)jumpingFrog.currentLocator;
		if (canPlaceLocator)
		{
			float num = 0.15f * SceneArea.current.transform.localScale.x;
			num *= 0.8f;
			canPlaceLocator = Physics.OverlapBoxNonAlloc(focusPoint.worldPoint + new Vector3(0f, num / 2f * 1.25f, 0f), new Vector3(num, num / 2f, num), overlapCache, Quaternion.identity, reticleHideLayerMask) <= 0;
		}
		if (canPlaceLocator)
		{
			line.gameObject.SetActive(value: true);
			targetingReticle.visible = true;
			Vector3 vector = focusPoint.plane.rotation * Vector3.up;
			Vector3 forward = Vector3.ProjectOnPlane(focusPoint.worldPoint - Camera.main.transform.position, vector);
			targetingReticle.transform.position = focusPoint.worldPoint;
			targetingReticle.transform.rotation = Quaternion.LookRotation(forward, vector);
			line.startPosition = jumpingFrog.transform.position;
			line.endPosition = targetingReticle.transform.position;
			line.controlPosition = JumpingFrog.GetJumpApex(line.startPosition, line.endPosition);
			line.UpdateLineRenderer();
		}
		else
		{
			line.gameObject.SetActive(value: false);
			targetingReticle.visible = false;
		}
		if ((bool)jumpButtonCanvasGroup)
		{
			float target = (canPlaceLocator ? 1 : 0);
			float maxDelta = Time.deltaTime * 4f;
			jumpButtonCanvasGroup.alpha = Mathf.MoveTowards(jumpButtonCanvasGroup.alpha, target, maxDelta);
			jumpButtonCanvasGroup.blocksRaycasts = jumpButtonCanvasGroup.alpha > 0.5f;
		}
	}

	public void OnPress()
	{
		if (!isInPlacementMode)
		{
			isInPlacementMode = true;
			jumpingFrog.waitForNextLocator = true;
			ElementsSystem.instance.planeManager.EnableLayerType("DynamicGridPlaneLayer");
		}
	}

	private void OnPressButton()
	{
		if (!isInPlacementMode || !canPlaceLocator)
		{
			return;
		}
		PlaneFocusPoint focusPoint = GetFocusPoint();
		if (focusPoint.plane != null)
		{
			Transform transform = null;
			Vector3 upwards = focusPoint.plane.rotation * Vector3.up;
			Vector3 forward = focusPoint.plane.rotation * Vector3.forward;
			Quaternion quaternion = Quaternion.LookRotation(forward, upwards);
			quaternion *= Quaternion.AngleAxis(Random.Range(-180f, 180f), Vector3.up);
			if (focusPoint.plane is AndroidPlane)
			{
				DetectedPlane trackedPlane = (focusPoint.plane as AndroidPlane).trackedPlane;
				transform = trackedPlane.CreateAnchor(new Pose(focusPoint.worldPoint, quaternion)).transform;
			}
			else if (focusPoint.plane is VirtualPlane)
			{
				transform = new GameObject("VirtualAnchor").transform;
				transform.SetParent(base.transform, worldPositionStays: false);
				transform.position = focusPoint.worldPoint;
				transform.rotation = quaternion;
			}
			else if (focusPoint.plane is EditorPlane)
			{
				transform = new GameObject("EditorAnchor").transform;
				transform.localPosition = focusPoint.worldPoint;
				transform.localRotation = quaternion;
			}
			jumpingFrog.SetNextLocator(transform);
			jumpingFrog.waitForNextLocator = false;
			isInPlacementMode = false;
			ElementsSystem.instance.planeManager.DisableLayerType("DynamicGridPlaneLayer");
		}
	}

	private PlaneFocusPoint GetFocusPoint()
	{
		PlaneFocusController planeFocusController = ElementsSystem.instance.planeFocusController;
		if (planeFocusController.focusPoints.Count > 0)
		{
			return planeFocusController.focusPoints[0];
		}
		return null;
	}
}
}
