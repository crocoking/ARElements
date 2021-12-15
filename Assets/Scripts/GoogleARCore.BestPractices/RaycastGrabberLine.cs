using KeenTween;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RaycastGrabberLine : MonoBehaviour
{
	public LineRenderer lineRenderer;

	public bool autoUpdate;

	public Vector3 startPosition;

	public Vector3 controlPosition;

	public Vector3 endPosition;

	public Transform contactDot;

	private Tween dotTween;

	private void LateUpdate()
	{
		if (autoUpdate)
		{
			UpdateLineRenderer();
		}
		if (lineRenderer.enabled)
		{
			if (!contactDot)
			{
				return;
			}
			if (!contactDot.gameObject.activeSelf)
			{
				contactDot.gameObject.SetActive(value: true);
				contactDot.localScale = Vector3.zero;
				if (dotTween != null && dotTween.isDone)
				{
					dotTween.Cancel();
				}
				dotTween = new Tween(null, 0f, 1f, 1f, new CurveElastic(TweenCurveMode.Out), delegate(Tween t)
				{
					if ((bool)contactDot)
					{
						contactDot.localScale = Vector3.one * t.currentValue;
					}
				});
			}
			contactDot.position = endPosition;
			contactDot.LookAt(Camera.main.transform.position);
			float num = Vector3.Distance(contactDot.transform.position, Camera.main.transform.position);
			float num2 = num * 1f;
			contactDot.transform.GetChild(0).localScale = Vector3.one * num2;
		}
		else if ((bool)contactDot)
		{
			contactDot.gameObject.SetActive(value: false);
		}
	}

	public void UpdateLineRenderer()
	{
		if (lineRenderer.enabled)
		{
			for (int i = 0; i < lineRenderer.positionCount; i++)
			{
				float ratio = (float)i / (float)(lineRenderer.positionCount - 1);
				Vector3 position = BezierUtility.Bezier(startPosition, controlPosition, endPosition, ratio);
				lineRenderer.SetPosition(i, position);
			}
		}
	}
}
}
