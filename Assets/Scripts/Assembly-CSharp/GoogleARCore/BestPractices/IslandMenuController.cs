using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using KeenTween;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace GoogleARCore.BestPractices{

public class IslandMenuController : MonoBehaviour
{
	public enum PlayIntroMode
	{
		Once,
		Always,
		Never
	}

	private static IslandMenuController _current;

	private static int lastIslandIndex = -1;

	[Header("Intro and Timelines")]
	public PlayIntroMode playIntroMode;

	public bool neverPlayIntroInEditor = true;

	public PlayableDirector playableDirector;

	public TimelineAsset timelineWithIntro;

	public TimelineAsset timelineWithoutIntro;

	public TimelineAsset timelineOut;

	public PlayableDirector islandsPlayableDirector;

	public TimelineAsset islandsTimelineOut;

	public PlayableDirector oceanPlayableDirector;

	public TimelineAsset oceanTimelineOut;

	[Header("Islands")]
	public List<Island> islands = new List<Island>();

	public Transform focusedIslandTarget;

	public float focusedIslandScale = 1.75f;

	public bool returnToPreviouslySelectedIsland = true;

	[Header("Audio")]
	public AudioEvent onFocusAudioEvent;

	private Coroutine focusCoroutine;

	private Island focusedIsland;

	public static IslandMenuController current
	{
		[CompilerGenerated]
		get
		{
			return _current ? _current : (_current = Object.FindObjectOfType<IslandMenuController>());
		}
	}

	public static bool hasPlayedIntro { get; private set; }

	private void Start()
	{
		bool flag = playIntroMode == PlayIntroMode.Always;
		if (!flag && playIntroMode == PlayIntroMode.Once)
		{
			flag = !hasPlayedIntro;
		}
		if (neverPlayIntroInEditor && Application.isEditor)
		{
			flag = false;
		}
		if (flag)
		{
			hasPlayedIntro = true;
			playableDirector.playableAsset = timelineWithIntro;
		}
		else
		{
			playableDirector.playableAsset = timelineWithoutIntro;
		}
		playableDirector.Play();
		foreach (Island island in islands)
		{
			island.button.onClick.AddListener(delegate
			{
				OnClickIsland(island);
			});
		}
		if (!flag && returnToPreviouslySelectedIsland && lastIslandIndex >= 0)
		{
			StartCoroutine(FocusLastIsland());
		}
	}

	private IEnumerator FocusLastIsland()
	{
		while (playableDirector.playableGraph.IsValid() && playableDirector.playableGraph.IsPlaying())
		{
			yield return null;
		}
		OnClickIsland(islands[lastIslandIndex]);
	}

	public void OnClickIsland(Island island)
	{
		if (focusCoroutine == null && !(island == focusedIsland))
		{
			if ((bool)focusedIsland)
			{
				focusCoroutine = StartCoroutine(ChangeFocusedIsland(island));
			}
			else
			{
				focusCoroutine = StartCoroutine(FocusIsland(island));
			}
		}
	}

	private IEnumerator FocusIsland(Island islandToFocus)
	{
		focusedIsland = islandToFocus;
		foreach (Island island in islands)
		{
			if (island == focusedIsland)
			{
				continue;
			}
			new Tween(null, 0f, 1f, 0.5f, new CurveCubic(TweenCurveMode.InOut), delegate(Tween t)
			{
				if ((bool)island)
				{
					island.transform.parent.position = island.initialPath.SamplePosition(t.currentValue * island.initialPath.length);
				}
			});
		}
		new Tween(null, 0f, 1f, 0.5f, new CurveCubic(TweenCurveMode.InOut), delegate(Tween t)
		{
			if ((bool)focusedIsland)
			{
				focusedIsland.transform.parent.localPosition = Vector3.Lerp(focusedIsland.parentStartLocalPosition, focusedIslandTarget.localPosition, t.currentValue);
				focusedIsland.transform.localScale = Vector3.Lerp(Vector3.one, Vector3.one * focusedIslandScale, t.currentValue);
			}
		});
		focusedIsland.button.gameObject.SetActive(value: false);
		if ((object)onFocusAudioEvent != null)
		{
			onFocusAudioEvent.PlayAtPoint(focusedIslandTarget.position);
		}
		yield return new WaitForSeconds(0.5f);
		focusedIsland.OnFocus();
		focusCoroutine = null;
	}

	private IEnumerator ChangeFocusedIsland(Island islandToFocusNext)
	{
		Island previousFocusedIsland = focusedIsland;
		previousFocusedIsland.OnUnfocus();
		new Tween(null, 0f, 1f, 0.5f, new CurveCubic(TweenCurveMode.InOut), delegate(Tween t)
		{
			if ((bool)previousFocusedIsland)
			{
				Vector3 position2 = previousFocusedIsland.focusedPath.SamplePosition(t.currentValue * previousFocusedIsland.focusedPath.length);
				position2 = previousFocusedIsland.transform.parent.parent.InverseTransformPoint(position2);
				previousFocusedIsland.transform.parent.localPosition = position2;
				previousFocusedIsland.transform.localScale = Vector3.Lerp(Vector3.one * focusedIslandScale, Vector3.one, t.currentValue);
			}
		});
		previousFocusedIsland.button.gameObject.SetActive(value: true);
		focusedIsland = islandToFocusNext;
		focusedIsland.button.gameObject.SetActive(value: false);
		Vector3 nextStartPos = focusedIsland.transform.parent.localPosition;
		new Tween(null, 0f, 1f, 0.5f, new CurveCubic(TweenCurveMode.InOut), delegate(Tween t)
		{
			if ((bool)focusedIsland)
			{
				Vector3 position = focusedIsland.focusedPath.SamplePosition(focusedIsland.focusedPath.length - t.currentValue * focusedIsland.focusedPath.length);
				position = focusedIsland.transform.parent.parent.InverseTransformPoint(position);
				focusedIsland.transform.parent.localPosition = position;
				focusedIsland.transform.localScale = Vector3.Lerp(Vector3.one, Vector3.one * focusedIslandScale, t.currentValue);
			}
		});
		if ((object)onFocusAudioEvent != null)
		{
			onFocusAudioEvent.PlayAtPoint(focusedIslandTarget.position);
		}
		yield return new WaitForSeconds(0.5f);
		focusedIsland.OnFocus();
		focusCoroutine = null;
	}

	public void OnSelectedScene(string sceneName)
	{
		StartCoroutine(OnSelectedSceneAsync(sceneName));
	}

	private IEnumerator OnSelectedSceneAsync(string sceneName)
	{
		yield return new WaitForSeconds(0.5f);
		oceanPlayableDirector.playableAsset = oceanTimelineOut;
		islandsPlayableDirector.playableAsset = islandsTimelineOut;
		playableDirector.playableAsset = timelineOut;
		playableDirector.extrapolationMode = DirectorWrapMode.None;
		playableDirector.Play();
		while (playableDirector.playableGraph.IsValid() && playableDirector.playableGraph.IsPlaying())
		{
			yield return null;
		}
		lastIslandIndex = islands.IndexOf(focusedIsland);
		SceneArea.current.sceneTransitionController.TransitionToScene(sceneName);
	}
}
}
