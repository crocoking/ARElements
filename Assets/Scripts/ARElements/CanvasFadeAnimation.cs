using UnityEngine;

namespace ARElements{

public class CanvasFadeAnimation
{
	public enum FadeState
	{
		None,
		FadingOut,
		FadingIn,
		Done
	}

	private CanvasGroup m_FadeOutCanvas;

	private CanvasGroup m_FadeInCanvas;

	private float m_AnimationSpeed;

	private const float k_PrettyMuchZero = 0.01f;

	private const float k_PrettyMuchOne = 0.99f;

	public FadeState state { get; protected set; }

	public CanvasFadeAnimation(CanvasGroup fadeOutCavnas, CanvasGroup fadeInCanvas, float speed)
	{
		m_FadeOutCanvas = fadeOutCavnas;
		m_FadeInCanvas = fadeInCanvas;
		m_AnimationSpeed = speed;
		state = FadeState.FadingOut;
	}

	public void ContinueFadeAnimation()
	{
		if (state == FadeState.None || state == FadeState.Done)
		{
			return;
		}
		if (state == FadeState.FadingOut)
		{
			ContinueFadeOut();
		}
		else if (state == FadeState.FadingIn)
		{
			ContinueFadeIn();
			if (state == FadeState.Done)
			{
				CompleteAnimation();
			}
		}
	}

	public void CompleteAnimation()
	{
		state = FadeState.Done;
		if ((bool)m_FadeOutCanvas)
		{
			m_FadeOutCanvas.alpha = 0f;
			m_FadeOutCanvas.gameObject.SetActive(value: false);
		}
		if ((bool)m_FadeInCanvas)
		{
			m_FadeInCanvas.alpha = 1f;
			m_FadeInCanvas.gameObject.SetActive(value: true);
		}
	}

	private void ContinueFadeOut()
	{
		if (m_FadeOutCanvas == null)
		{
			state = FadeState.FadingIn;
			return;
		}
		m_FadeOutCanvas.alpha = Mathf.MoveTowards(m_FadeOutCanvas.alpha, 0f, m_AnimationSpeed * Time.deltaTime);
		if (!m_FadeOutCanvas.gameObject.activeSelf)
		{
			m_FadeOutCanvas.gameObject.SetActive(value: true);
		}
		if (m_FadeOutCanvas.alpha <= 0.01f)
		{
			m_FadeOutCanvas.alpha = 0f;
			state = FadeState.FadingIn;
		}
	}

	private void ContinueFadeIn()
	{
		if (m_FadeInCanvas == null)
		{
			state = FadeState.Done;
			return;
		}
		if (!m_FadeInCanvas.gameObject.activeSelf)
		{
			m_FadeInCanvas.gameObject.SetActive(value: true);
		}
		m_FadeInCanvas.alpha = Mathf.MoveTowards(m_FadeInCanvas.alpha, 1f, m_AnimationSpeed * Time.deltaTime);
		if (m_FadeInCanvas.alpha > 0.99f)
		{
			m_FadeInCanvas.alpha = 1f;
			state = FadeState.Done;
		}
	}
}
}
