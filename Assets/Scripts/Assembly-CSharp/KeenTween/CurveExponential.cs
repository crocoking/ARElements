using System;

namespace KeenTween
{

	public class CurveExponential : TweenCurve
	{
		public CurveExponential(TweenCurveMode easeMode)
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
			return (t != 0f) ? (c * (float)Math.Pow(2.0, 10f * (t / d - 1f)) + b) : b;
		}

		public static float EaseOut(float t, float b, float c, float d)
		{
			return (t != d) ? (c * (float)(0.0 - Math.Pow(2.0, -10f * t / d) + 1.0) + b) : (b + c);
		}

		public static float EaseInOut(float t, float b, float c, float d)
		{
			if (t == 0f)
			{
				return b;
			}
			if (t == d)
			{
				return b + c;
			}
			if ((t /= d / 2f) < 1f)
			{
				return c / 2f * (float)Math.Pow(2.0, 10f * (t - 1f)) + b;
			}
			return c / 2f * (float)(0.0 - Math.Pow(2.0, -10f * (t -= 1f)) + 2.0) + b;
		}
	}
}
