using UnityEngine;
using UnityEngine.SceneManagement;

namespace GoogleARCore.BestPractices{

public class DestroyOnSceneChange : MonoBehaviour
{
	private void Start()
	{
		SceneManager.activeSceneChanged += OnSceneChanged;
	}

	private void OnDestroy()
	{
		SceneManager.activeSceneChanged -= OnSceneChanged;
	}

	private void OnSceneChanged(Scene arg0, Scene arg1)
	{
		Object.DestroyImmediate(base.gameObject);
	}
}
}
