namespace KeenTween
{

	public class CurveLinear : TweenCurve
	{
		public CurveLinear(TweenCurveMode easeMode)
			: base(easeMode)
		{
		}

		public override float SampleIn(float position)
		{
			return position;
		}

		public override float SampleOut(float position)
		{
			return position;
		}

		public override float SampleInOut(float position)
		{
			return position;
		}
	}
}
