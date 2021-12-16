using UnityEngine;

namespace ARElements{

public class ScaleController : BaseTransformationController<PinchGesture>
{
	[Range(0.1f, 10f)]
	public float minScale = 0.75f;

	[Range(0.1f, 10f)]
	public float maxScale = 1.75f;

	[Range(0.1f, 10f)]
	public float sensitivity = 0.75f;

	[Range(0f, 1f)]
	public float elasticity = 0.15f;

	private float m_CurrentScaleRatio;

	private EasedFloat m_scaleAnimation = new EasedFloat(0f);

	private const float k_ElasticRatioLimit = 0.8f;

	private const float k_AnimationDuration = 0.35f;

	private float ScaleDelta
	{
		get
		{
			if (minScale > maxScale)
			{
				Debug.LogError("minScale must be smaller than maxScale.");
				return 0f;
			}
			return maxScale - minScale;
		}
	}

	private float ClampedScaleRatio => Mathf.Clamp01(m_CurrentScaleRatio);

	private float CurrentScale
	{
		get
		{
			float num = ClampedScaleRatio + ElasticDelta();
			float num2 = minScale + num * ScaleDelta;
			return num2 * m_scaleAnimation.ValueAtTime(Time.time);
		}
	}

	protected override void Awake()
	{
		base.Awake();
		m_CurrentScaleRatio = (base.transform.localScale.x - minScale) / ScaleDelta;
		m_scaleAnimation.FadeTo(1f, 0.35f, Time.time);
	}

	protected override void OnContinueTransformation(PinchGesture gesture)
	{
		m_CurrentScaleRatio += sensitivity * GestureTouches.PixelsToInches(gesture.gapDelta);
		float currentScale = CurrentScale;
		base.transform.localScale = new Vector3(currentScale, currentScale, currentScale);
		if (m_CurrentScaleRatio < -0.8f || m_CurrentScaleRatio > 1.8f)
		{
			base.ActiveGesture.Cancel();
		}
	}

	private float ElasticDelta()
	{
		float num = 0f;
		if (m_CurrentScaleRatio > 1f)
		{
			num = m_CurrentScaleRatio - 1f;
		}
		else
		{
			if (!(m_CurrentScaleRatio < 0f))
			{
				return 0f;
			}
			num = m_CurrentScaleRatio;
		}
		return (1f - 1f / (Mathf.Abs(num) * elasticity + 1f)) * Mathf.Sign(num);
	}

	private void LateUpdate()
	{
		if (base.ActiveGesture == null)
		{
			m_CurrentScaleRatio = Mathf.Lerp(m_CurrentScaleRatio, ClampedScaleRatio, Time.deltaTime * 8f);
			float currentScale = CurrentScale;
			base.transform.localScale = new Vector3(currentScale, currentScale, currentScale);
		}
	}
}
}
