using System;
using UnityEngine;

namespace ARElements{

public static class MathUtilities
{
	public static int PositiveModulo(int i, int n)
	{
		return (n + i % n) % n;
	}

	public static float Atan2Positive(float y, float x)
	{
		float num = Mathf.Atan2(y, x);
		if (num >= 0f)
		{
			return num;
		}
		return (float)Math.PI * 2f + num;
	}
}
}
