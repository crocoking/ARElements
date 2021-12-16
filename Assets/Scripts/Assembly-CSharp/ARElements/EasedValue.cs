using UnityEngine;

namespace ARElements{

public abstract class EasedValue<T>
{
	private float m_StartTime;

	private T m_StartValue;

	private T m_FinalValue;

	private float m_Duration;

	public EasingFunction easingFunction { get; set; }

	public float duration => m_Duration;

	public T finalValue => m_FinalValue;

	public T startValue => m_StartValue;

	protected EasedValue(T initialValue, EasingFunction easingFunction = EasingFunction.EaseOutCubic)
	{
		m_Duration = 0f;
		m_FinalValue = initialValue;
		m_StartValue = initialValue;
		m_StartTime = 0f;
		this.easingFunction = easingFunction;
	}

	public abstract bool Approximately(T lhsValue, T rhsValue);

	public abstract T Lerp(T startValue, T finalValue, float progress);

	public void JumpTo(T finalValue)
	{
		m_FinalValue = finalValue;
		m_Duration = 0f;
	}

	public void FadeFromTo(T startValue, T finalValue, float duration, float startTime)
	{
		if (!Approximately(m_FinalValue, finalValue) || !Mathf.Approximately(m_Duration, duration))
		{
			m_StartValue = startValue;
			m_StartTime = startTime;
			m_FinalValue = finalValue;
			m_Duration = duration;
		}
	}

	public void FadeTo(T finalValue, float duration, float startTime)
	{
		FadeFromTo(ValueAtTime(startTime), finalValue, duration, startTime);
	}

	public void ShortenedFadeTo(T finalValue, float maximumDuration, float startTime)
	{
		if (!Approximately(m_FinalValue, finalValue))
		{
			float num = Mathf.Max(0f, m_Duration + m_StartTime - startTime);
			float num2 = Mathf.Max(0f, maximumDuration - num);
			FadeFromTo(ValueAtTime(startTime), finalValue, num2, startTime);
		}
	}

	public T ValueAtTime(float atTime)
	{
		float progress = GetProgress(atTime);
		switch (easingFunction)
		{
				case EasingFunction.Linear: return Lerp(m_StartValue, m_FinalValue, progress);
				case EasingFunction.ElasticEaseOut: return ElasticEaseOut(m_StartValue, m_FinalValue, progress);
				case EasingFunction.EaseOutBounce: return BounceEaseOut(m_StartValue, m_FinalValue, progress);
				case EasingFunction.EaseOutSmallBounce: return SmallBounceEaseOut(m_StartValue, m_FinalValue, progress);
				default: return CubicEaseOut(m_StartValue, m_FinalValue, progress); 
		};
	}

	public T CubicEaseOut(T initialValue, T finalValue, float progress)
	{
		return Lerp(initialValue, finalValue, Mathf.Pow(Mathf.Clamp01(progress) - 1f, 3f) + 1f);
	}

	public T ElasticEaseOut(T initialValue, T finalValue, float progress)
	{
		progress = Mathf.Clamp01(progress);
		if (Mathf.Approximately(progress, 0f))
		{
			return initialValue;
		}
		if (Mathf.Approximately(progress, 1f))
		{
			return finalValue;
		}
		float progress2 = Mathf.Pow(2f, -10f * progress) * Mathf.Sin(progress - 0.075f) * 20.94395f;
		return Lerp(initialValue, finalValue, progress2);
	}

	private T BounceEaseOut(T initialValue, T finalValue, float progress)
	{
		if (progress < 0.363636374f)
		{
			progress = 7.5625f * progress * progress;
		}
		else if (progress < 0.727272749f)
		{
			progress -= 0.545454562f;
			progress = 7.5625f * progress * progress + 0.75f;
		}
		else if (progress < 0.909090936f)
		{
			progress -= 0.8181818f;
			progress = 7.5625f * progress * progress + 0.9375f;
		}
		else
		{
			progress -= 21f / 22f;
			progress = 7.5625f * progress * progress + 63f / 64f;
		}
		return Lerp(initialValue, finalValue, progress);
	}

	private T SmallBounceEaseOut(T initialValue, T finalValue, float progress)
	{
		if (progress < 0.363636374f)
		{
			progress = 7.5625f * progress * progress;
		}
		else
		{
			progress -= 0.545454562f;
			progress = 7.5625f * progress * progress + 0.85f;
		}
		return Lerp(initialValue, finalValue, progress);
	}

	public float GetProgress(float atTime)
	{
		if (!(atTime > m_StartTime))
		{
			return 0f;
		}
		if (atTime - m_StartTime > m_Duration)
		{
			return 1f;
		}
		return Mathf.Clamp01((atTime - m_StartTime) / m_Duration);
	}

	public bool IsCompleted(float atTime)
	{
		return m_Duration > 0f && atTime > m_StartTime + m_Duration;
	}

	public bool IsStarted(float atTime)
	{
		return m_Duration > 0f && atTime > m_StartTime;
	}

	public bool IsValid()
	{
		return m_Duration > 0f;
	}
}
}
