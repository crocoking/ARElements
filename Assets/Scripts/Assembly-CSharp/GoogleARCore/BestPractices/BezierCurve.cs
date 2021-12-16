using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class BezierCurve : MonoBehaviour
{
	public float length
	{
		[CompilerGenerated]
		get
		{
			return Mathf.Max(base.transform.childCount - 1, 0);
		}
	}

	public void Sample(float samplePosition, out Vector3 position, out Vector3 tangent)
	{
		float num = length;
		if (num <= 0f)
		{
			position = base.transform.position;
			tangent = base.transform.forward;
			return;
		}
		samplePosition = Mathf.Clamp(samplePosition, 0f, num);
		int num2 = Mathf.FloorToInt(samplePosition);
		float ratio = samplePosition - (float)num2;
		Transform child = base.transform.GetChild(num2);
		if (samplePosition <= 0f)
		{
			position = child.position;
			tangent = child.forward;
			return;
		}
		int index = Mathf.Min(num2 + 1, base.transform.childCount - 1);
		Transform child2 = base.transform.GetChild(index);
		if (samplePosition >= num)
		{
			position = child2.position;
			tangent = child2.forward;
			return;
		}
		float num3 = (child2.position - child.position).magnitude / 3f;
		Vector3 b = child.position + child.forward * num3 * child.localScale.z;
		Vector3 c = child2.position - child2.forward * num3 * child2.localScale.z;
		position = BezierUtility.BezierCubic(child.position, b, c, child2.position, ratio);
		tangent = BezierUtility.BezierCubicTangent(child.position, b, c, child2.position, ratio);
	}

	public Vector3 SamplePosition(float samplePosition)
	{
		Sample(samplePosition, out var position, out var _);
		return position;
	}

	public Vector3 SampleTangent(float samplePosition)
	{
		Sample(samplePosition, out var _, out var tangent);
		return tangent;
	}
}
}
