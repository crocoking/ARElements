using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ChartIndicatorController : MonoBehaviour
{
	public CanvasGroup canvasGroup;

	public float maxViewAngle = 0.85f;

	public List<Transform> anchorRoot = new List<Transform>();

	private Transform currentAnchor;

	private void Start()
	{
		Transform closestAnchor = GetClosestAnchor();
		if ((bool)closestAnchor)
		{
			currentAnchor = closestAnchor;
			base.transform.position = currentAnchor.position;
		}
		if ((bool)canvasGroup)
		{
			canvasGroup.alpha = 0f;
		}
	}

	private void LateUpdate()
	{
		Camera main = Camera.main;
		Vector3 position = main.transform.position;
		Transform closestAnchor = GetClosestAnchor();
		if ((bool)currentAnchor)
		{
			float num = Vector3.Distance(closestAnchor.position, position);
			float num2 = Vector3.Distance(currentAnchor.position, position);
			if (num * 1.1f < num2)
			{
				currentAnchor = closestAnchor;
			}
		}
		else
		{
			currentAnchor = closestAnchor;
		}
		if ((bool)currentAnchor)
		{
			base.transform.position = Vector3.Lerp(base.transform.position, currentAnchor.position, 10f * Time.deltaTime);
		}
		Vector3 vector = position - base.transform.position;
		if ((bool)base.transform.parent)
		{
			vector = base.transform.parent.InverseTransformDirection(vector);
		}
		vector.Normalize();
		float num3 = Mathf.Clamp01(Vector3.Dot(vector, Vector3.up));
		vector.y = 0f;
		vector.Normalize();
		base.transform.localRotation = Quaternion.LookRotation(-vector);
		if ((bool)canvasGroup)
		{
			float target = ((!(num3 > maxViewAngle)) ? 1 : 0);
			float num4 = Mathf.MoveTowards(canvasGroup.alpha, target, 5f * Time.deltaTime);
			if (num4 != canvasGroup.alpha)
			{
				canvasGroup.alpha = num4;
			}
		}
	}

	private Transform GetClosestAnchor()
	{
		Camera main = Camera.main;
		Transform result = null;
		float num = float.PositiveInfinity;
		foreach (Transform item in anchorRoot)
		{
			float num2 = Vector3.Distance(item.position, main.transform.position);
			if (num2 < num)
			{
				result = item;
				num = num2;
			}
		}
		return result;
	}
}
}
