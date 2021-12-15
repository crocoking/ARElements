using ARElements;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class RaycastGrabbable : MonoBehaviour
{
	public UnityEvent onGrab = new UnityEvent();

	public UnityEvent onRelease = new UnityEvent();

	private bool isGrabbed;

	private PlaneFocusPoint activePlaneFocusPoint;

	public void Grab()
	{
		if (onGrab != null)
		{
			onGrab.Invoke();
		}
		isGrabbed = true;
		ElementsSystem.instance.planeFocusController.TriggerFocusStart();
	}

	public void Release()
	{
		if (onRelease != null)
		{
			onRelease.Invoke();
		}
		isGrabbed = false;
		if (activePlaneFocusPoint != null)
		{
			ElementsSystem.instance.planeFocusController.RemoveFocusPoint(activePlaneFocusPoint);
			activePlaneFocusPoint = null;
		}
		PlaneVisualizationController[] componentsInChildren = ElementsSystem.instance.gameObject.GetComponentsInChildren<PlaneVisualizationController>();
		foreach (PlaneVisualizationController planeVisualizationController in componentsInChildren)
		{
			planeVisualizationController.isActive = false;
			DynamicGridController component = planeVisualizationController.GetComponent<DynamicGridController>();
			component.HideFocalPoint();
		}
		ElementsSystem.instance.planeFocusController.ClearFocusPoints();
		ElementsSystem.instance.planeFocusController.TriggerFocusEnd();
		ElementsSystem.instance.planeFocusController.focusMode = ElementsSystem.instance.planeFocusController.deselectFocusMode;
	}

	private void Update()
	{
		if (!isGrabbed)
		{
			return;
		}
		ElementsSystem.instance.planeManager.Raycast(new Ray(base.transform.position, Vector3.down), out var hit);
		if (hit.plane != null)
		{
			PlaneFocusController planeFocusController = ElementsSystem.instance.planeFocusController;
			if (activePlaneFocusPoint != null)
			{
				planeFocusController.RemoveFocusPoint(activePlaneFocusPoint);
			}
			activePlaneFocusPoint = new PlaneFocusPoint(hit.plane, base.transform.position);
			planeFocusController.AddFocusPoint(activePlaneFocusPoint);
			planeFocusController.focusMode = FocusMode.Selection;
		}
	}
}
}
