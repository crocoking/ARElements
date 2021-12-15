using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CriticalErrorWatcher : MonoBehaviour
{
	private void Update()
	{
		if (!Application.isEditor)
		{
			QuitOnConnectionErrors();
		}
	}

	private void QuitOnConnectionErrors()
	{
		if (Session.Status == SessionStatus.ErrorPermissionNotGranted)
		{
			AndroidUtility.ShowToastMessage("Camera permission is needed to run this application.");
			Application.Quit();
		}
		else if (Session.Status == SessionStatus.ErrorApkNotAvailable || Session.Status == SessionStatus.ErrorSessionConfigurationNotSupported || Session.Status == SessionStatus.FatalError)
		{
			AndroidUtility.ShowToastMessage("ARCore encountered a problem connecting.  Please start the app again.");
			Application.Quit();
		}
	}
}
}
