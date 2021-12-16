using GoogleARCore;
using UnityEngine;

namespace ARElements
{

	public static class AndroidUtilities
	{
		public static bool KeepAwakeIfTracking()
		{
			return KeepAwakeIfTrackingInAR();
		}

		private static bool KeepAwakeIfTrackingInAR()
		{
			QuitOnConnectionErrors();
			if (Session.Status != SessionStatus.Tracking)
			{
				Screen.sleepTimeout = 15;
				return false;
			}
			Screen.sleepTimeout = -1;
			return true;
		}

		private static void QuitOnConnectionErrors()
		{
			if (Session.Status == SessionStatus.ErrorPermissionNotGranted)
			{
				ShowAndroidToastMessage("Camera permission is needed to run this application.");
				Application.Quit();
			}
			else if (Session.Status == SessionStatus.FatalError)
			{
				ShowAndroidToastMessage("ARCore encountered a problem connecting.  Please start the app again.");
				Application.Quit();
			}
		}

		private static void ShowAndroidToastMessage(string message)
		{
			AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject unityActivity = androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
			if (unityActivity != null)
			{
				AndroidJavaClass toastClass = new AndroidJavaClass("android.widget.Toast");
				unityActivity.Call("runOnUiThread", (AndroidJavaRunnable)delegate
				{
					AndroidJavaObject androidJavaObject = toastClass.CallStatic<AndroidJavaObject>("makeText", new object[3] { unityActivity, message, 0 });
					androidJavaObject.Call("show");
				});
			}
		}
	}
}
