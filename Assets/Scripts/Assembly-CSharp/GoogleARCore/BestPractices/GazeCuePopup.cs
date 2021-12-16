using System.Collections;
using KeenTween;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class GazeCuePopup : MonoBehaviour
{
	public float triggerOffset;

	public float popupDelay;

	public GameObject popup;

	public Animator animator;

	public UnityEvent onGazeQueTriggered = new UnityEvent();

	public UnityEvent onGazeQuePopupClosed = new UnityEvent();

	private bool seenStart;

	private float previousTime = float.PositiveInfinity;

	private Camera mainCamera;

	private bool hasShown;

	private void Start()
	{
		mainCamera = Camera.main;
		popup.SetActive(value: false);
	}

	private void Update()
	{
		AnimatorStateInfo currentAnimatorStateInfo = animator.GetCurrentAnimatorStateInfo(0);
		float length = currentAnimatorStateInfo.length;
		float t = Mathf.Repeat(currentAnimatorStateInfo.normalizedTime, 1f) * length;
		t = Mathf.Repeat(t, length - triggerOffset);
		Vector3 vector = mainCamera.WorldToViewportPoint(base.transform.position);
		if (vector.x >= 0f && vector.x < 1f && vector.y >= 0f && vector.y < 1f)
		{
			if (t < previousTime)
			{
				if (seenStart && !hasShown)
				{
					hasShown = true;
					StartCoroutine(ShowPopup(popupDelay));
				}
				seenStart = true;
			}
		}
		else
		{
			seenStart = false;
		}
		previousTime = t;
	}

	private IEnumerator ShowPopup(float delay)
	{
		yield return new WaitForSeconds(delay);
		onGazeQueTriggered.Invoke();
		popup.transform.localScale = Vector3.zero;
		popup.SetActive(value: true);
		new Tween(null, 0f, 1f, 1f, new CurveElastic(TweenCurveMode.Out), delegate(Tween t)
		{
			if ((bool)popup)
			{
				popup.transform.localScale = Vector3.one * t.currentValue;
			}
		});
		Button button = popup.GetComponentInChildren<Button>();
		if (!button)
		{
			yield break;
		}
		button.onClick.AddListener(delegate
		{
			button.onClick.RemoveAllListeners();
			Tween tween = new Tween(null, 1f, 0f, 0.3f, new CurveCubic(TweenCurveMode.In), delegate(Tween t)
			{
				popup.transform.localScale = Vector3.one * t.currentValue;
			});
			tween.onFinish += delegate
			{
				popup.SetActive(value: false);
				onGazeQuePopupClosed.Invoke();
			};
		});
	}
}
}
