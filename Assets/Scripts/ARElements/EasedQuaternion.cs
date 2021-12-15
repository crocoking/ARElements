using UnityEngine;

namespace ARElements{

internal class EasedQuaternion : EasedValue<Quaternion>
{
	public EasedQuaternion()
		: base(Quaternion.identity, EasingFunction.EaseOutCubic)
	{
	}

	public EasedQuaternion(Quaternion initialValue, EasingFunction easingFunction = EasingFunction.EaseOutCubic)
		: base(initialValue, easingFunction)
	{
	}

	public override Quaternion Lerp(Quaternion startValue, Quaternion finalValue, float progress)
	{
		return Quaternion.Slerp(startValue, finalValue, progress);
	}

	public override bool Approximately(Quaternion lhsValue, Quaternion rhsValue)
	{
		return Mathf.Approximately(Quaternion.Angle(lhsValue, rhsValue), 0f);
	}
}
}
