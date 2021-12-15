using System;
using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ARCoreDeviceSpawner : MonoBehaviour
{
	public GameObject arCoreDeviceTemplate;

	public ElementsSystem elementsSystemTemplate;

	public GameObject editorFloorTestTemplate;

	public Canvas topBarCanvasTemplate;

	private static bool hasPlacedEditorFloorTest;

	private void Awake()
	{
		if (!UnityEngine.Object.FindObjectOfType<ARCoreSession>())
		{
			GameObject gameObject = UnityEngine.Object.Instantiate(arCoreDeviceTemplate);
			if (Application.isEditor)
			{
				gameObject.GetComponent<ARCoreSession>().enabled = false;
				gameObject.transform.Translate(0f, 0.75f, 0f);
				gameObject.transform.Rotate(16f, 0f, 0f);
				Camera component = gameObject.transform.Find("3DCamera/BackgroundCamera").gameObject.GetComponent<Camera>();
				ARCoreBackgroundRenderer component2 = component.gameObject.GetComponent<ARCoreBackgroundRenderer>();
				component2.enabled = false;
				component.clearFlags = CameraClearFlags.Skybox;
			}
			UnityEngine.Object.DontDestroyOnLoad(gameObject);
		}
		UnityEngine.Object.Instantiate(topBarCanvasTemplate);
		if ((bool)elementsSystemTemplate)
		{
			if (!ElementsSystem.instance)
			{
				UnityEngine.Object.Instantiate(elementsSystemTemplate);
				UnityEngine.Object.DontDestroyOnLoad(ElementsSystem.instance);
			}
		}
		else
		{
			Debug.LogWarning(string.Format("{0} was not specified in {1}.", "elementsSystemTemplate", "ARCoreDeviceSpawner"));
		}
		if (Application.isEditor && !hasPlacedEditorFloorTest)
		{
			GameObject gameObject2 = UnityEngine.Object.Instantiate(editorFloorTestTemplate);
			gameObject2.name = editorFloorTestTemplate.name;
			UnityEngine.Object.DontDestroyOnLoad(gameObject2);
			EditorTrackingService component3 = ElementsSystem.instance.planeManager.gameObject.GetComponent<EditorTrackingService>();
			component3.meshPlanes.Clear();
			component3.meshPlanes.AddRange(gameObject2.GetComponentsInChildren<MeshFilter>());
			hasPlacedEditorFloorTest = true;
		}
	}

	private void Start()
	{
		if (Application.platform == RuntimePlatform.Android)
		{
			SetRotationAnimation();
		}
	}

	private void SetRotationAnimation()
	{
		AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
		AndroidJavaObject unityActivity = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
		unityActivity.Call("runOnUiThread", (AndroidJavaRunnable)delegate
		{
			AndroidJavaClass androidJavaClass2 = new AndroidJavaClass("android.view.WindowManager$LayoutParams");
			AndroidJavaObject androidJavaObject = unityActivity.Call<AndroidJavaObject>("getWindow", Array.Empty<object>());
			AndroidJavaObject androidJavaObject2 = androidJavaObject.Call<AndroidJavaObject>("getAttributes", Array.Empty<object>());
			androidJavaObject2.Set("rotationAnimation", androidJavaClass2.GetStatic<int>("ROTATION_ANIMATION_CROSSFADE"));
			androidJavaObject.Call("setAttributes", androidJavaObject2);
		});
	}
}
}
