using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CreateDialog : MonoBehaviour
{
	public DialogBox dialogBoxTemplate;

	public DialogBox Create()
	{
		return Object.Instantiate(dialogBoxTemplate);
	}

	public void CreateEvent()
	{
		Create();
	}
}
}
