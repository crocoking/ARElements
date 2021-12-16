using UnityEngine;

namespace GoogleARCore.BestPractices{

public class HelpDialogController : MonoBehaviour
{
	public DialogBox dialogBox;

	private void Start()
	{
		dialogBox.AddDismissButton("GOT IT");
	}
}
}
