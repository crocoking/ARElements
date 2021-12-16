using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

[RequireComponent(typeof(RectTransform))]
public class SlidingDrawer : MonoBehaviour
{
	public ClickEventProxy button;

	public Animator slidingAnimator;

	public ScrollRect scrollRect;

	public float selfOpenDuration = 1.5f;

	private EasedFloat m_SelfOpen = new EasedFloat(1f);

	private bool m_SelfOpenIsRunning = true;

	private ScreenOrientation m_PrevScreenOrientation;

	private const float k_SelfOpenMaxVelocity = 40f;

	private const float k_Epsilon = 0.001f;

	private bool drawerIsMostlyOpen => drawerOpenProgress > 0.5f;

	private bool drawerIsCompletelyOpenOrClosed => drawerOpenProgress > 0.999f || drawerOpenProgress < 0.001f;

	private float drawerOpenProgress
	{
		get
		{
			return 1f - scrollRect.verticalNormalizedPosition;
		}
		set
		{
			Vector2 normalizedPosition = scrollRect.normalizedPosition;
			normalizedPosition.y = 1f - value;
			scrollRect.normalizedPosition = normalizedPosition;
		}
	}

	private bool isSelfOpening => m_SelfOpenIsRunning || (m_SelfOpen.IsValid() && !m_SelfOpen.IsCompleted(Time.time));

	public void ToggleDrawerOpen()
	{
		if (!drawerIsMostlyOpen)
		{
			OpenDrawer();
		}
		else
		{
			CloseDrawer();
		}
	}

	public bool IsPlayingOpenAnimation()
	{
		return !slidingAnimator.GetBool("Closing") && slidingAnimator.GetBool("Opening");
	}

	public void PlayAnimation(bool openAnimation)
	{
		if (IsPlayingOpenAnimation() != openAnimation)
		{
			slidingAnimator.SetBool("Opening", openAnimation);
			slidingAnimator.SetBool("Closing", !openAnimation);
		}
	}

	public void OpenDrawer()
	{
		m_SelfOpen.JumpTo(drawerOpenProgress);
		m_SelfOpen.FadeTo(1f, selfOpenDuration, Time.time);
		m_SelfOpenIsRunning = true;
		PlayAnimation(openAnimation: true);
	}

	public void CloseDrawer()
	{
		m_SelfOpen.JumpTo(drawerOpenProgress);
		m_SelfOpen.FadeTo(0f, selfOpenDuration, Time.time);
		m_SelfOpenIsRunning = true;
		PlayAnimation(openAnimation: false);
	}

	private void SelfOpenDrawer()
	{
		float b = drawerOpenProgress;
		float a = m_SelfOpen.ValueAtTime(Time.time);
		a = (drawerOpenProgress = ((!(m_SelfOpen.finalValue > 0.5f)) ? Mathf.Min(a, b) : Mathf.Max(a, b)));
		m_SelfOpenIsRunning = m_SelfOpen.IsValid() && !m_SelfOpen.IsCompleted(Time.time);
	}

	private void Start()
	{
		button.onClick.AddListener(ToggleDrawerOpen);
	}

	private void OnEnable()
	{
		m_SelfOpenIsRunning = true;
		m_SelfOpen.JumpTo(drawerOpenProgress);
	}

	private void Update()
	{
		if (Screen.orientation != m_PrevScreenOrientation)
		{
			m_PrevScreenOrientation = Screen.orientation;
			Canvas.ForceUpdateCanvases();
		}
		Rect rect = base.transform.parent.GetComponent<RectTransform>().rect;
		bool flag = Input.GetMouseButton(0);
		int num = 0;
		while (!flag && num < Input.touchCount)
		{
			flag = Input.touches[num].phase != TouchPhase.Ended;
			num++;
		}
		if (flag)
		{
			m_SelfOpenIsRunning = false;
			m_SelfOpen.JumpTo(drawerOpenProgress);
			if (drawerIsMostlyOpen == (double)scrollRect.velocity.y > 0.0)
			{
				PlayAnimation(drawerIsMostlyOpen);
			}
		}
		else if (!isSelfOpening)
		{
			if (drawerIsCompletelyOpenOrClosed)
			{
				if (drawerIsMostlyOpen != IsPlayingOpenAnimation())
				{
					PlayAnimation(drawerIsMostlyOpen);
				}
				return;
			}
			if (Mathf.Abs(scrollRect.velocity.y) > 40f)
			{
				PlayAnimation(scrollRect.velocity.y > 0f);
				return;
			}
			bool flag2 = drawerIsMostlyOpen;
			if (Mathf.Abs(scrollRect.velocity.y) > 0f)
			{
				flag2 = scrollRect.velocity.y > 0f;
			}
			if (flag2)
			{
				OpenDrawer();
			}
			else
			{
				CloseDrawer();
			}
		}
		else
		{
			SelfOpenDrawer();
		}
	}
}
}
