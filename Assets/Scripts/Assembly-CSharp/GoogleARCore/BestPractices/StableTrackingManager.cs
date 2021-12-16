using System.Collections;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class StableTrackingManager : MonoBehaviour
{
	private static StableTrackingManager _current;

	public static StableTrackingManager current => _current ? _current : (_current = Object.FindObjectOfType<StableTrackingManager>());

	protected float timeSinceStartedTracking { get; private set; }

	public bool isTracking
	{
		get
		{
			if (Application.isEditor)
			{
				return true;
			}
			return Session.Status == SessionStatus.Tracking;
		}
	}

	public bool isStableTracking => isTracking && timeSinceStartedTracking >= 1f;

	protected virtual void Update()
	{
		StartCoroutine(EndOfFrame());
		UpdateSleep();
	}

	private IEnumerator EndOfFrame()
	{
		yield return new WaitForEndOfFrame();
		if (isTracking)
		{
			timeSinceStartedTracking += Time.deltaTime;
		}
		else
		{
			timeSinceStartedTracking = 0f;
		}
	}

	private void UpdateSleep()
	{
		Screen.sleepTimeout = ((!isStableTracking) ? (-2) : (-1));
	}
}
}
