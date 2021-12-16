using System;
using UnityEngine;

namespace AndroidRuntimePermissionsNamespace
{

	public class PermissionCallbackHelper : MonoBehaviour
	{
		private Action mainThreadAction;

		private void Awake()
		{
			UnityEngine.Object.DontDestroyOnLoad(base.gameObject);
		}

		private void Update()
		{
			if (mainThreadAction != null)
			{
				Action action = mainThreadAction;
				mainThreadAction = null;
				action();
			}
		}

		public void CallOnMainThread(Action function)
		{
			mainThreadAction = function;
		}
	}
}
