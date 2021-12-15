using UnityEngine;

namespace ARElements{

internal class EasedVector3 : EasedValue<Vector3>
{
	public EasedVector3()
		: base(Vector3.zero, EasingFunction.EaseOutCubic)
	{
	}

	public EasedVector3(Vector3 initialValue, EasingFunction easingFunction = EasingFunction.EaseOutCubic)
		: base(initialValue, easingFunction)
	{
	}

	public override Vector3 Lerp(Vector3 startValue, Vector3 finalValue, float progress)
	{
		return Vector3.Lerp(startValue, finalValue, progress);
	}

	public override bool Approximately(Vector3 lhsValue, Vector3 rhsValue)
	{
		return Mathf.Approximately(Vector3.SqrMagnitude(lhsValue - rhsValue), 0f);
	}
}
}
