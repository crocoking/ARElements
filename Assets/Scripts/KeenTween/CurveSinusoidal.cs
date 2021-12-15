using System;

namespace KeenTween
{

	public class CurveSinusoidal : TweenCurve
	{
		public CurveSinusoidal(TweenCurveMode easeMode)
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
			return (0f - c) * (float)Math.Cos((double)(t / d) * (Math.PI / 2.0)) + c + b;
		}

		public static float EaseOut(float t, float b, float c, float d)
		{
			return c * (float)Math.Sin((double)(t / d) * (Math.PI / 2.0)) + b;
		}

		public static float EaseInOut(float t, float b, float c, float d)
		{
			return (0f - c) / 2f * ((float)Math.Cos(Math.PI * (double)t / (double)d) - 1f) + b;
		}
	}
}
