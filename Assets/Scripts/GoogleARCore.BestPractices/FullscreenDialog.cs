using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class FullscreenDialog : MonoBehaviour
{
	public Button exitButton;

	public Text titleTextComponent;

	public Text bodyTextComponent;

	private void Start()
	{
		exitButton.onClick.AddListener(OnClickExitButton);
	}

	private void OnClickExitButton()
	{
		Object.DestroyImmediate(base.gameObject);
	}
}
}
