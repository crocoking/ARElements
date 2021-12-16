using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(MeshRenderer))]
public class SimplePlaneFocusLayer : PlaneLayer
{
	private PlaneFocusController m_FocusController;

	public override string layerType => "SimplePlaneFocusLayer";

	public override bool shouldRender => m_FocusController.focusPoints.Count > 0;

	private void Start()
	{
		m_FocusController = ElementsSystem.instance.planeFocusController;
	}

	private void Update()
	{
		if (!m_FocusController)
		{
			base.enabled = false;
		}
		else if (m_FocusController.focusPoints.Count != 0)
		{
			PlaneFocusPoint planeFocusPoint = m_FocusController.focusPoints[0];
			Vector3 vector = base.transform.InverseTransformPoint(planeFocusPoint.worldPoint);
			base.meshRenderer.material.SetVector("_FocusPoint", new Vector4(vector.x, vector.y, vector.z, 0f));
		}
	}
}
}
