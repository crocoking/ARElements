using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class LowestGroundPlaneCollision : MonoBehaviour
{
	public bool limitToLocalZero = true;

	private void FixedUpdate()
	{
		PlaneManager planeManager = ElementsSystem.instance.planeManager;
		if (planeManager == null)
		{
			return;
		}
		if (planeManager.planeStacks.Count <= 0)
		{
			SetYPosition((!base.transform.parent) ? 0f : base.transform.parent.position.y);
			return;
		}
		float num = float.PositiveInfinity;
		foreach (PlaneStack planeStack in planeManager.planeStacks)
		{
			foreach (Vector3 boundaryPoint in planeStack.plane.boundaryPoints)
			{
				num = Mathf.Min(num, boundaryPoint.y);
			}
		}
		SetYPosition(num);
	}

	private void SetYPosition(float yPosition)
	{
		if (limitToLocalZero)
		{
			yPosition = ((!base.transform.parent) ? Mathf.Min(yPosition, 0f) : Mathf.Min(yPosition, base.transform.parent.position.y));
		}
		Vector3 position = new Vector3(0f, yPosition, 0f);
		if ((bool)base.transform.parent)
		{
			position = base.transform.parent.position;
			position.y = yPosition;
		}
		Rigidbody component = base.gameObject.GetComponent<Rigidbody>();
		if ((bool)component)
		{
			component.position = position;
		}
		else
		{
			base.transform.position = position;
		}
	}
}
}
