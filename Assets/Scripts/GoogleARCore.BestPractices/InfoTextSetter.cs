using UnityEngine;

namespace GoogleARCore.BestPractices{

public class InfoTextSetter : MonoBehaviour
{
	public string text = string.Empty;

	private void OnEnable()
	{
		SceneArea.current?.infoCard.SetShortText(text);
	}
}
}
