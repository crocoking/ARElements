using System;
using UnityEngine;

namespace KeenTween
{

	public class CurveElastic : TweenCurve
	{
		public CurveElastic(TweenCurveMode easeMode)
			: base(easeMode)
		{
		}

		public override float SampleIn(float position)
		{
			return EaseIn(position, 0f, 1f, 1f);
		}

		public override float SampleOut(float position)
		{
			return EaseOut(position, 0f, 1f, 1f);
		}

		public override float SampleInOut(float position)
		{
			return EaseInOut(position, 0f, 1f, 1f);
		}

		public static float EaseIn(float t, float b, float c, float d)
		{
			if (t == 0f)
			{
				return b;
			}
			if ((t /= d) == 1f)
			{
				return b + c;
			}
			float num = d * 0.3f;
			float num2 = num / 4f;
			return 0f - (float)((double)c * Math.Pow(2.0, 10f * (t -= 1f)) * Math.Sin((double)(t * d - num2) * (Math.PI * 2.0) / (double)num)) + b;
		}

		public static float EaseOut(float t, float b, float c, float d)
		{
			if (t == 0f)
			{
				return b;
			}
			if ((t /= d) == 1f)
			{
				return b + c;
			}
			float num = d * 0.3f;
			float num2 = num / 4f;
			return (float)((double)c * Math.Pow(2.0, -10f * t) * Math.Sin((double)(t * d - num2) * (Math.PI * 2.0) / (double)num) + (double)c + (double)b);
		}

		public static float EaseInOut(float t, float b, float c, float d)
		{
			if (t == 0f)
			{
				return b;
			}
			if ((t /= d / 2f) == 2f)
			{
				return b + c;
			}
			float num = d * 0.450000018f;
			float num2 = num / 4f;
			if (t < 1f)
			{
				return -0.5f * (float)((double)c * Math.Pow(2.0, 10f * (t -= 1f)) * Math.Sin((double)(t * d - num2) * (Math.PI * 2.0) / (double)num)) + b;
			}
			return (float)((double)c * Math.Pow(2.0, -10f * (t -= 1f)) * Math.Sin((double)(t * d - num2) * (Math.PI * 2.0) / (double)num) * 0.5 + (double)c + (double)b);
		}

		public static float Punch(float t, float b, float c, float d)
		{
			if (t == 0f)
			{
				return 0f;
			}
			if ((t /= d) == 1f)
			{
				return 0f;
			}
			return c * Mathf.Pow(2f, -10f * t) * Mathf.Sin(t * ((float)Math.PI * 2f) / 0.3f);
		}
	}
}
