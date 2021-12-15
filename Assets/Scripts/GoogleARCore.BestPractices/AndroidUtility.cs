using System;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public static class AndroidUtility
{
	public static AndroidJavaObject GetUnityActivity()
	{
			using (AndroidJavaClass androidJavaClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
			{
				return androidJavaClass.GetStatic<AndroidJavaObject>("currentActivity");
			}
	}

	public static void ShowToastMessage(string message)
	{
		AndroidJavaObject unityActivity = GetUnityActivity();
		AndroidJavaClass toastClass = new AndroidJavaClass("android.widget.Toast");
		unityActivity.Call("runOnUiThread", (AndroidJavaRunnable)delegate
		{
			using (AndroidJavaObject androidJavaObject = toastClass.CallStatic<AndroidJavaObject>("makeText", new object[3] { unityActivity, message, 0 }))
			{
				androidJavaObject.Call("show");
			}
			toastClass.Dispose();
			unityActivity.Dispose();
		});
	}

	public static bool ShouldShouldRequestPermissionRationale(string permission)
	{
			using (AndroidJavaObject androidJavaObject = GetUnityActivity())
            {
				return androidJavaObject.Call<bool>("shouldShowRequestAndroidPermissionRationale", new object[1] { permission });
			}

	}

	public static void OpenAppInfo()
	{
		try
		{
				using (AndroidJavaObject androidJavaObject = GetUnityActivity())
				{
					string text = androidJavaObject.Call<string>("getPackageName", Array.Empty<object>());
					using (AndroidJavaClass androidJavaClass = new AndroidJavaClass("android.net.Uri"))
                    {
						using (AndroidJavaObject androidJavaObject2 = androidJavaClass.CallStatic<AndroidJavaObject>("fromParts", new object[3] { "package", text, null }))
                        {
							using (AndroidJavaObject androidJavaObject3 = new AndroidJavaObject("android.content.Intent", "android.settings.APPLICATION_DETAILS_SETTINGS", androidJavaObject2))
                            {
								androidJavaObject3.Call<AndroidJavaObject>("addCategory", new object[1] { "android.intent.category.DEFAULT" });
								androidJavaObject3.Call<AndroidJavaObject>("setFlags", new object[1] { 268435456 });
								androidJavaObject.Call("startActivity", androidJavaObject3);
							}

						}

					}

				}
		}
		catch (Exception exception)
		{
			Debug.LogException(exception);
		}
	}
}
}
