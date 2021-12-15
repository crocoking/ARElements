using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class SceneIslandLabel : MonoBehaviour
{
	public ResponsiveLabel responsiveLabel;

	public Image collapsedIcon;

	public Image expandedIcon;

	public Text expandedText;

	public void SetContent(Sprite icon, string text)
	{
		if ((bool)icon)
		{
			collapsedIcon.sprite = icon;
			expandedIcon.sprite = icon;
		}
		expandedText.text = text;
	}
}
}
