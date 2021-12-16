using System;
using System.Collections.Generic;
using System.Linq;
using IslandsDotty;
using KeenTween;
using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class Island : MonoBehaviour
{
	public Button button;

	public List<GameObject> sceneIslands = new List<GameObject>();

	public LocomotionController dottyTemplate;

	private LocomotionController dotty;

	public LocomotionWaypoint startingWaypoint;

	public BezierCurve initialPath;

	public BezierCurve focusedPath;

	private Tween[] sceneIslandTweens;

	public AudioEvent stingerAudioEvent;

	public AudioEvent sceneStingerAudioEvent;

	public string ambientAudioName;

	public int groupID;

	public Transform labelPivot;

	public GameObject labelTemplate;

	public string title = string.Empty;

	private bool isFocused;

	public Vector3 parentStartLocalPosition { get; private set; }

	private void Start()
	{
		parentStartLocalPosition = base.transform.parent.localPosition;
		sceneIslandTweens = new Tween[sceneIslands.Count];
		SceneInfoCollection.SceneInfo[] array = SceneArea.current.sceneInfoCollection.sceneInfos.Where((SceneInfoCollection.SceneInfo v) => v.islandGroup == groupID && !v.unlisted).ToArray();
		if (array.Length != sceneIslands.Count)
		{
			throw new Exception($"Number of listed scenes in group {groupID} ({array.Length}) is not equal number of island waypoints ({sceneIslands.Count}).");
		}
		for (int i = 0; i < sceneIslands.Count; i++)
		{
			GameObject gameObject = sceneIslands[i];
			SceneInfoCollection.SceneInfo sceneInfo = array[i];
			gameObject.SetActive(value: false);
			gameObject.transform.localScale = Vector3.zero;
			LocomotionWaypoint componentInChildren = gameObject.GetComponentInChildren<LocomotionWaypoint>();
			componentInChildren.onClick.AddListener(OnClickSceneIsland);
			componentInChildren.sceneInfo = sceneInfo;
			SceneIslandLabel[] componentsInChildren = gameObject.GetComponentsInChildren<SceneIslandLabel>();
			foreach (SceneIslandLabel sceneIslandLabel in componentsInChildren)
			{
				sceneIslandLabel.SetContent(sceneInfo.icon, sceneInfo.title);
				sceneIslandLabel.responsiveLabel.transitionDistance *= SceneArea.current.scaleFactor;
				sceneIslandLabel.responsiveLabel.overrideThresholdTransform = base.transform;
			}
		}
		GameObject gameObject2 = UnityEngine.Object.Instantiate(labelTemplate, labelPivot);
		Text componentInChildren2 = gameObject2.GetComponentInChildren<Text>();
		componentInChildren2.text = title;
	}

	private void OnEnable()
	{
		if (isFocused && !dotty)
		{
			SpawnDotty();
		}
	}

	public void OnFocus()
	{
		isFocused = true;
		SetSceneIslandStates();
		if ((object)stingerAudioEvent != null)
		{
			stingerAudioEvent.Play2D();
		}
	}

	public void OnUnfocus()
	{
		isFocused = false;
		SetSceneIslandStates();
	}

	private void SetSceneIslandStates()
	{
		Tween[] array = sceneIslandTweens;
		foreach (Tween tween in array)
		{
			if (tween != null && !tween.isDone)
			{
				tween.Cancel();
			}
		}
		if (!isFocused)
		{
			if ((bool)dotty)
			{
				UnityEngine.Object.DestroyImmediate(dotty.gameObject);
			}
		}
		else
		{
			AmbientAudioLoopManager.current.SetEntry(ambientAudioName);
		}
		float to = (isFocused ? 1 : 0);
		CurveCubic curve = ((!isFocused) ? new CurveCubic(TweenCurveMode.In) : new CurveCubic(TweenCurveMode.Out));
		for (int j = 0; j < sceneIslands.Count; j++)
		{
			GameObject sceneIsland = sceneIslands[j];
			if (isFocused == sceneIsland.gameObject.activeSelf)
			{
				continue;
			}
			if (isFocused)
			{
				sceneIsland.gameObject.SetActive(value: true);
				sceneIsland.transform.localScale = Vector3.zero;
			}
			Tween tween2 = new Tween(null, sceneIsland.transform.localScale.x, to, 0.25f, curve, delegate(Tween t)
			{
				if ((bool)sceneIsland)
				{
					sceneIsland.transform.localScale = Vector3.one * t.currentValue;
				}
			});
			tween2.delay = (float)j * 0.15f;
			sceneIslandTweens[j] = tween2;
			if (isFocused)
			{
				continue;
			}
			tween2.onFinish += delegate
			{
				if ((bool)sceneIsland)
				{
					sceneIsland.gameObject.SetActive(value: false);
				}
			};
		}
		if (isFocused)
		{
			SpawnDotty();
		}
	}

	private void SpawnDotty()
	{
		if ((bool)dotty)
		{
			UnityEngine.Object.DestroyImmediate(dotty.gameObject);
		}
		dotty = UnityEngine.Object.Instantiate(dottyTemplate, base.transform);
		dotty.jumpSpeed *= SceneArea.current.scaleFactor;
		dotty.walkSpeed *= SceneArea.current.scaleFactor;
		dotty.StartingWaypoint = startingWaypoint;
		dotty.onLanded.AddListener(OnDottyLanded);
		foreach (GameObject sceneIsland in sceneIslands)
		{
			LocomotionWaypoint componentInChildren = sceneIsland.GetComponentInChildren<LocomotionWaypoint>();
			componentInChildren.locomotionController = dotty;
			componentInChildren.sphereCollider.enabled = true;
		}
	}

	private void OnClickSceneIsland()
	{
		foreach (Island island in IslandMenuController.current.islands)
		{
			island.button.gameObject.SetActive(value: false);
		}
	}

	private void OnDottyLanded(LocomotionWaypoint waypoint)
	{
		if ((object)sceneStingerAudioEvent != null)
		{
			sceneStingerAudioEvent.Play2D();
		}
		foreach (GameObject sceneIsland in sceneIslands)
		{
			LocomotionWaypoint componentInChildren = sceneIsland.GetComponentInChildren<LocomotionWaypoint>();
			componentInChildren.sphereCollider.enabled = false;
		}
		IslandMenuController.current.OnSelectedScene(waypoint.sceneInfo.name);
	}
}
}
