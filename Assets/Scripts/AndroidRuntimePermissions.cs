using System;
using System.Text;
using System.Threading;
using AndroidRuntimePermissionsNamespace;
using UnityEngine;

public static class AndroidRuntimePermissions
{
	public enum Permission
	{
		Denied,
		Granted,
		ShouldAsk
	}

	public delegate void PermissionResult(string permission, Permission result);

	public delegate void PermissionResultMultiple(string[] permissions, Permission[] result);

	private static AndroidJavaClass m_ajc;

	private static AndroidJavaObject m_context;

	private static AndroidJavaClass AJC
	{
		get
		{
			if (m_ajc == null)
			{
				m_ajc = new AndroidJavaClass("com.yasirkula.unity.RuntimePermissions");
			}
			return m_ajc;
		}
	}

	private static AndroidJavaObject Context
	{
		get
		{
			if (m_context == null)
			{
				using (AndroidJavaObject androidJavaObject = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
				{
					m_context = androidJavaObject.GetStatic<AndroidJavaObject>("currentActivity");
				}

			}
			return m_context;
		}
	}

	public static void OpenSettings()
	{
		AJC.CallStatic("OpenSettings", Context);
	}

	public static Permission CheckPermission(string permission)
	{
		return CheckPermissions(permission)[0];
	}

	public static Permission[] CheckPermissions(params string[] permissions)
	{
		ValidateArgument(permissions);
		string text = AJC.CallStatic<string>("CheckPermission", new object[2] { permissions, Context });
		if (text.Length != permissions.Length)
		{
			Debug.LogError("CheckPermissions: something went wrong");
			return null;
		}
		Permission[] array = new Permission[permissions.Length];
		for (int i = 0; i < array.Length; i++)
		{
			Permission permission = text[i].ToPermission();
			if (permission == Permission.Denied && GetCachedPermission(permissions[i], Permission.ShouldAsk) != 0)
			{
				permission = Permission.ShouldAsk;
			}
			array[i] = permission;
		}
		return array;
	}

	public static Permission RequestPermission(string permission)
	{
		return RequestPermissions(permission)[0];
	}

	public static Permission[] RequestPermissions(params string[] permissions)
	{
		ValidateArgument(permissions);
		object obj = new object();
		PermissionCallback permissionCallback;
		lock (obj)
		{
			permissionCallback = new PermissionCallback(obj);
			AJC.CallStatic("RequestPermission", permissions, Context, permissionCallback, GetCachedPermissions(permissions));
			if (permissionCallback.Result == null)
			{
				Monitor.Wait(obj);
			}
		}
		return ProcessPermissionRequest(permissions, permissionCallback.Result);
	}

	private static void RequestPermissionAsync(string permission, PermissionResult callback)
	{
		RequestPermissionsAsync(new string[1] { permission }, delegate(string[] permissions, Permission[] result)
		{
			if (callback != null)
			{
				callback(permissions[0], result[0]);
			}
		});
	}

	private static void RequestPermissionsAsync(string[] permissions, PermissionResultMultiple callback)
	{
		ValidateArgument(permissions);
		PermissionCallbackAsync permissionCallbackAsync = new PermissionCallbackAsync(permissions, callback);
		AJC.CallStatic("RequestPermission", permissions, Context, permissionCallbackAsync, GetCachedPermissions(permissions));
	}

	public static Permission[] ProcessPermissionRequest(string[] permissions, string resultRaw)
	{
		if (resultRaw.Length != permissions.Length)
		{
			Debug.LogError("RequestPermissions: something went wrong");
			return null;
		}
		bool flag = false;
		Permission[] array = new Permission[permissions.Length];
		for (int i = 0; i < array.Length; i++)
		{
			if (CachePermission(value: array[i] = resultRaw[i].ToPermission(), permission: permissions[i]))
			{
				flag = true;
			}
		}
		if (flag)
		{
			PlayerPrefs.Save();
		}
		return array;
	}

	private static Permission GetCachedPermission(string permission, Permission defaultValue)
	{
		return (Permission)PlayerPrefs.GetInt("ARTP_" + permission, (int)defaultValue);
	}

	private static string GetCachedPermissions(string[] permissions)
	{
		StringBuilder stringBuilder = new StringBuilder(permissions.Length);
		for (int i = 0; i < permissions.Length; i++)
		{
			stringBuilder.Append((int)GetCachedPermission(permissions[i], Permission.ShouldAsk));
		}
		return stringBuilder.ToString();
	}

	private static bool CachePermission(string permission, Permission value)
	{
		if (PlayerPrefs.GetInt("ARTP_" + permission, -1) != (int)value)
		{
			PlayerPrefs.SetInt("ARTP_" + permission, (int)value);
			return true;
		}
		return false;
	}

	private static void ValidateArgument(string[] permissions)
	{
		if (permissions == null || permissions.Length == 0)
		{
			throw new ArgumentException("Parameter 'permissions' is null or empty!");
		}
		for (int i = 0; i < permissions.Length; i++)
		{
			if (string.IsNullOrEmpty(permissions[i]))
			{
				throw new ArgumentException("A permission is null or empty!");
			}
		}
	}

	private static Permission[] GetDummyResult(string[] permissions)
	{
		Permission[] array = new Permission[permissions.Length];
		for (int i = 0; i < array.Length; i++)
		{
			array[i] = Permission.Granted;
		}
		return array;
	}

	private static Permission ToPermission(this char ch)
	{
		return (Permission)(ch - 48);
	}
}
