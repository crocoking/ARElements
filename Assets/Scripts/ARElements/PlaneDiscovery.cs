using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

namespace ARElements{

public class PlaneDiscovery : MonoBehaviour
{
	[Serializable]
	public struct VisualComponent
	{
		[Tooltip("The root GameObject for this component.")]
		public GameObject gameObject;

		[Tooltip("Optional CanvasGroup reference to control fading.")]
		public CanvasGroup canvasGroup;

		[Tooltip("How long to wait before the visual component shows up after determining it should be show.")]
		public float showDelay;

		[Tooltip("How long to wait before the visual component is hidden. 0 to never hide.")]
		public float hideDelay;

		public void OnStart()
		{
			gameObject.SetActive(value: false);
			if ((bool)canvasGroup)
			{
				canvasGroup.alpha = 0f;
			}
		}

		public void UpdateVisibility(PlaneDiscovery planeDiscovery)
		{
			if (planeDiscovery.isShowing)
			{
				bool flag = Time.time - planeDiscovery.showStartTime >= showDelay;
				if (flag && hideDelay > 0f && Time.time - planeDiscovery.showStartTime >= hideDelay)
				{
					flag = false;
				}
				UpdateFade(flag);
			}
			else
			{
				UpdateFade(isShowing: false);
			}
		}

		private void UpdateFade(bool isShowing)
		{
			if (isShowing && !gameObject.activeSelf)
			{
				gameObject.SetActive(value: true);
			}
			if ((bool)canvasGroup)
			{
				float num = (isShowing ? 1 : (-1));
				float num2 = Mathf.Clamp01(canvasGroup.alpha + 2f * num * Time.deltaTime);
				if (canvasGroup.alpha != num2)
				{
					canvasGroup.alpha = num2;
				}
				if (!isShowing && num2 <= 0f && gameObject.activeSelf)
				{
					gameObject.SetActive(value: false);
				}
			}
			else if (!isShowing && gameObject.activeSelf)
			{
				gameObject.SetActive(value: false);
			}
		}
	}

	[Tooltip("The gameobject that provides feature points visualization.")]
	public GameObject featurePoints;

	[Tooltip("The video player for the hand animation.")]
	public VideoPlayer handAnimationVideoPlayer;

	[Tooltip("Settings for the hand animation.")]
	public VisualComponent handComponent;

	[Tooltip("Settings for the snackbar.")]
	public VisualComponent snackBarComponent;

	[Tooltip("Settings for the \"Need Help?\" snackbar.")]
	public VisualComponent needHelpSnackBarComponent;

	private HashSet<PlaneDiscoveryRule> planeDiscoveryRules = new HashSet<PlaneDiscoveryRule>();

	private float showStartTime = float.NegativeInfinity;

	private bool handVideoIsReady;

	private bool isShowing => showStartTime != float.NegativeInfinity;

	private void Start()
	{
		handComponent.OnStart();
		snackBarComponent.OnStart();
		needHelpSnackBarComponent.OnStart();
	}

	private void Update()
	{
		bool flag = false;
		foreach (PlaneDiscoveryRule planeDiscoveryRule in planeDiscoveryRules)
		{
			if (planeDiscoveryRule == null || !planeDiscoveryRule.GetPlaneDiscoveryState())
			{
				continue;
			}
			flag = true;
			break;
		}
		if (flag)
		{
			if (showStartTime == float.NegativeInfinity)
			{
				showStartTime = Time.time;
			}
		}
		else
		{
			showStartTime = float.NegativeInfinity;
		}
		if (handVideoIsReady)
		{
			handComponent.UpdateVisibility(this);
			if (handComponent.gameObject.activeSelf)
			{
				if (!handAnimationVideoPlayer.isPlaying)
				{
					handAnimationVideoPlayer.Play();
				}
			}
			else if (handAnimationVideoPlayer.isPlaying)
			{
				handAnimationVideoPlayer.Pause();
			}
		}
		snackBarComponent.UpdateVisibility(this);
		needHelpSnackBarComponent.UpdateVisibility(this);
		if (!handVideoIsReady && handAnimationVideoPlayer.isPrepared)
		{
			handVideoIsReady = true;
			handAnimationVideoPlayer.Pause();
		}
	}

	public void RegisterPlaneDiscoveryRule(PlaneDiscoveryRule planeDiscoveryRule)
	{
		planeDiscoveryRules.Add(planeDiscoveryRule);
	}

	public void UnregisterPlaneDiscoveryRule(PlaneDiscoveryRule planeDiscoveryRule)
	{
		planeDiscoveryRules.Remove(planeDiscoveryRule);
	}
}
}
