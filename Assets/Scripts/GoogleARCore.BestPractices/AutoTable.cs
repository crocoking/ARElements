using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class AutoTable : MonoBehaviour
{
	public float surfaceExtensionHeight = 0.02f;

	public float heightThreshold = 1f;

	public float heightOffset = -0.25f;

	public Transform contentsPivot;

	public AutoTableGeometry geometry;

	private float lastActiveHeight;

	public bool committed { get; private set; }

	public float autoTableHeight { get; private set; }

	public bool hasAutoTable
	{
		[CompilerGenerated]
		get
		{
			return autoTableHeight > 0f;
		}
	}

	public float interpolationRatio { get; private set; }

	public float CalculateHeight(Vector3 cameraPosition, Vector3 cameraForward, Vector3 basePosition)
	{
		float result = 0f;
		Ray ray = new Ray(cameraPosition, cameraForward);
		Vector3 inNormal = cameraPosition - basePosition;
		inNormal.y = 0f;
		inNormal.Normalize();
		new Plane(inNormal, basePosition).Raycast(ray, out var enter);
		Vector3 point = ray.GetPoint(enter);
		point.y = Mathf.Min(point.y, cameraPosition.y);
		float num = point.y - basePosition.y;
		if (num >= heightThreshold)
		{
			result = num + heightOffset;
		}
		return result;
	}

	public void Commit()
	{
		committed = true;
		interpolationRatio = (hasAutoTable ? 1 : 0);
		UpdatePosition(autoTableHeight);
		geometry.gameObject.SetActive(value: true);
	}

	private void UpdateResponsiveHeight(bool completeFit)
	{
		float num = CalculateHeight(Camera.main.transform.position, Camera.main.transform.forward, base.transform.position);
		if (num <= 0f && !completeFit)
		{
			num = surfaceExtensionHeight;
		}
		autoTableHeight = num;
		if (num > 0f)
		{
			lastActiveHeight = autoTableHeight;
		}
	}

	public void UpdateHologram(bool updateResponsiveHeight, bool completeFit)
	{
		if (updateResponsiveHeight)
		{
			UpdateResponsiveHeight(completeFit);
		}
		UpdateSmoothHeight();
		float height = interpolationRatio * lastActiveHeight;
		UpdatePosition(height);
	}

	private void UpdateSmoothHeight()
	{
		interpolationRatio = Mathf.Lerp(interpolationRatio, hasAutoTable ? 1 : 0, 10f * Time.deltaTime);
		if (!hasAutoTable && interpolationRatio <= 0.001f)
		{
			interpolationRatio = 0f;
		}
		else if (hasAutoTable && interpolationRatio >= 0.999f)
		{
			interpolationRatio = 1f;
		}
	}

	private void UpdatePosition(float height)
	{
		if (height > 0f)
		{
			geometry.gameObject.SetActive(value: true);
		}
		else
		{
			geometry.gameObject.SetActive(value: false);
		}
		Vector3 forward = base.transform.forward;
		forward.y = 0f;
		forward.Normalize();
		base.transform.rotation = Quaternion.LookRotation(forward);
		contentsPivot.position = base.transform.position + new Vector3(0f, height, 0f);
		geometry.UpdateGeometry(height);
	}
}
}
