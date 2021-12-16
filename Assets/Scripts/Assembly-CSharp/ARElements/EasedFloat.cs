using UnityEngine;

namespace ARElements{

internal class EasedFloat : EasedValue<float>
{
	public EasedFloat(float initialValue, EasingFunction easingFunction = EasingFunction.EaseOutCubic)
		: base(initialValue, easingFunction)
	{
	}

	public override float Lerp(float startValue, float finalValue, float progress)
	{
		return Mathf.Lerp(startValue, finalValue, progress);
	}

	public override bool Approximately(float lhsValue, float rhsValue)
	{
		return Mathf.Approximately(lhsValue, rhsValue);
	}
}
}
