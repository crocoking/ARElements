using System.Collections.Generic;
using System.Runtime.CompilerServices;
using ARElements;
using KeenTween;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace GoogleARCore.BestPractices{

public class SceneArea : MonoBehaviour
{
	private static SceneArea _current;

	public float baseGravity = -9.81f;

	public SceneInfoCollection sceneInfoCollection;

	public SceneTransitionController sceneTransitionController;

	public NavButtonController navButtonController;

	public InfoCard infoCard;

	public Transform sceneSelectionPivot;

	public Transform scenePivot;

	public GameObject pedestal;

	public Transform pedestalContentPivot;

	public Transform instructionCardPivot;

	public AudioEvent onSceneLoadedAudioEvent;

	public List<string> sceneNameHistory = new List<string>();

	private bool destroyOnUnload;

	public static SceneArea current => _current ? _current : (_current = Object.FindObjectOfType<SceneArea>());

	public float scaleFactor
	{
		[CompilerGenerated]
		get
		{
			return base.transform.lossyScale.x;
		}
	}

	public Tween sceneTransitionTween { get; private set; }

	public bool isSceneTransition
	{
		[CompilerGenerated]
		get
		{
			return sceneTransitionTween != null;
		}
	}

	private void Awake()
	{
		Object.DontDestroyOnLoad(base.transform.root.gameObject);
		pedestal.gameObject.SetActive(value: false);
	}

	private void Start()
	{
		SceneManager.sceneLoaded += OnSceneLoaded;
		SceneManager.sceneUnloaded += OnSceneUnloaded;
		ElementsSystem.instance.planeManager.DisableLayerType("DynamicGridPlaneLayer");
		Physics.gravity = new Vector3(0f, baseGravity * scaleFactor, 0f);
		OnSceneLoaded(SceneManager.GetActiveScene(), LoadSceneMode.Single);
		sceneTransitionController.NotifyButtonVisibility();
	}

	private void OnDisable()
	{
		if (!Application.isEditor)
		{
			EnterReanchorMode();
		}
	}

	private void OnDestroy()
	{
		SceneManager.sceneLoaded -= OnSceneLoaded;
		SceneManager.sceneUnloaded -= OnSceneUnloaded;
	}

	private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
	{
		Debug.Log($"Loaded Scene \"{scene.name}\"");
		sceneNameHistory.Add(scene.name);
		while (sceneNameHistory.Count > 3)
		{
			sceneNameHistory.RemoveAt(0);
		}
		instructionCardPivot.gameObject.SetActive(value: true);
		SceneDescription sceneDescription = Object.FindObjectOfType<SceneDescription>();
		if ((bool)sceneDescription)
		{
			string title = sceneInfoCollection.GetSceneInfo(scene.name)?.title;
			string text = sceneDescription.instructionText;
			if (string.IsNullOrEmpty(text))
			{
				text = sceneDescription.shortInstructionText;
			}
			infoCard.SetContent(title, sceneDescription.shortInstructionText, text);
			if (sceneDescription.infoCardMaxExpandPositionOverride >= 0f)
			{
				infoCard.SetMaxExpandPositionOverride(sceneDescription.infoCardMaxExpandPositionOverride);
			}
			if (sceneDescription.showGroundPlane)
			{
				ElementsSystem.instance.planeManager.EnableLayerType("DynamicGridPlaneLayer");
			}
			if (!sceneDescription.autoGazeFocusPoint)
			{
				ElementsSystem.instance.planeFocusController.deselectFocusMode = FocusMode.None;
			}
			if (!sceneDescription.useShadows)
			{
				ElementsSystem.instance.planeManager.DisableLayerType("ShadowPlaneLayer");
				ElementsSystem.instance.shadowController.gameObject.SetActive(value: false);
			}
			if ((bool)AmbientAudioLoopManager.current && sceneDescription.islandAmbientOverrideVolume >= 0f)
			{
				AmbientAudioLoopManager.current.SetCurrentVolumeScale(sceneDescription.islandAmbientOverrideVolume);
			}
		}
		if ((object)onSceneLoadedAudioEvent != null)
		{
			onSceneLoadedAudioEvent.PlayAtPoint(base.transform.position);
		}
		Resources.UnloadUnusedAssets();
	}

	private void OnSceneUnloaded(Scene scene)
	{
		while (pedestalContentPivot.childCount > 0)
		{
			Object.DestroyImmediate(pedestalContentPivot.GetChild(0).gameObject);
		}
		while (scenePivot.childCount > 0)
		{
			Object.DestroyImmediate(scenePivot.GetChild(0).gameObject);
		}
		GameObject gameObject = ElementsSystem.instance.GetCoordinatorContext().gameObject;
		if ((bool)gameObject)
		{
			List<GameObject> list = new List<GameObject>();
			foreach (Transform item in gameObject.transform)
			{
				if (item.gameObject.activeSelf && item.gameObject.name != "Gestures")
				{
					list.Add(item.gameObject);
				}
			}
			foreach (GameObject item2 in list)
			{
				Object.DestroyImmediate(item2);
			}
		}
		infoCard.SetContent(string.Empty, string.Empty, string.Empty);
		infoCard.Collapse();
		pedestal.gameObject.SetActive(value: false);
		ElementsSystem.instance.planeManager.DisableLayerType("DynamicGridPlaneLayer");
		ElementsSystem.instance.planeManager.EnableLayerType("ShadowPlaneLayer");
		ElementsSystem.instance.shadowController.gameObject.SetActive(value: true);
		ElementsSystem.instance.planeFocusController.deselectFocusMode = FocusMode.Gaze;
		ElementsSystem.instance.planeFocusController.focusMode = FocusMode.Gaze;
		if ((bool)AmbientAudioLoopManager.current)
		{
			AmbientAudioLoopManager.current.SetCurrentOverrideTargetVolume();
			AmbientAudioLoopManager.current.SetCurrentOverrideTransitionRate();
			AmbientAudioLoopManager.current.SetCurrentVolumeScale();
		}
		if (destroyOnUnload)
		{
			Object.DestroyImmediate(base.transform.root.gameObject);
		}
	}

	public void EnterReanchorMode()
	{
		destroyOnUnload = true;
		SceneManager.LoadScene(SceneManager.GetActiveScene().name);
	}

	public void SetPhysicalUIVisibility(bool visibility)
	{
		instructionCardPivot.gameObject.SetActive(visibility);
		navButtonController.contentTransform.gameObject.SetActive(visibility);
		pedestal.SetActive(visibility);
	}
}
}
