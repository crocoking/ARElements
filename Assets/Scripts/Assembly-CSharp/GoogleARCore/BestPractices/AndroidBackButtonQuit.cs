using UnityEngine;

namespace GoogleARCore.BestPractices{

public class AndroidBackButtonQuit : MonoBehaviour
{
	private void Awake()
	{
		Input.backButtonLeavesApp = true;
	}
}
}
