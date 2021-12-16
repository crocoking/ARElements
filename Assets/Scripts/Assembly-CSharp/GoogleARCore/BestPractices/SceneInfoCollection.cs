using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

[CreateAssetMenu]
public class SceneInfoCollection : ScriptableObject
{
	[Serializable]
	public class SceneInfo
	{
		public string name = string.Empty;

		public string title = string.Empty;

		public Sprite icon;

		public int islandGroup;

		public bool unlisted;
	}

	public List<SceneInfo> sceneInfos = new List<SceneInfo>();

	public int GetSceneInfoIndex(string sceneName)
	{
		int result = -1;
		for (int i = 0; i < sceneInfos.Count; i++)
		{
			SceneInfo sceneInfo = sceneInfos[i];
			if (sceneInfo != null && sceneInfo.name == sceneName)
			{
				result = i;
				break;
			}
		}
		return result;
	}

	public SceneInfo GetSceneInfo(string sceneName)
	{
		if (sceneName == "Menu")
		{
			return null;
		}
		int sceneInfoIndex = GetSceneInfoIndex(sceneName);
		if (sceneInfoIndex == -1)
		{
			return null;
		}
		return sceneInfos[sceneInfoIndex];
	}

	public SceneInfo GetNextSceneInfo(string sceneName)
	{
		if (sceneName == "Menu")
		{
			return sceneInfos[0];
		}
		int sceneInfoIndex = GetSceneInfoIndex(sceneName);
		if (sceneInfoIndex == -1)
		{
			return null;
		}
		sceneInfoIndex = GetNextValidSceneIndex(sceneInfoIndex, 1);
		return sceneInfos[sceneInfoIndex];
	}

	public SceneInfo GetPreviousSceneInfo(string sceneName)
	{
		if (sceneName == "Menu")
		{
			return sceneInfos[sceneInfos.Count - 1];
		}
		int sceneInfoIndex = GetSceneInfoIndex(sceneName);
		if (sceneInfoIndex == -1)
		{
			return null;
		}
		sceneInfoIndex = GetNextValidSceneIndex(sceneInfoIndex, -1);
		return sceneInfos[sceneInfoIndex];
	}

	private int GetNextValidSceneIndex(int index, int direction)
	{
		SceneInfo sceneInfo;
		do
		{
			index += direction;
			if (index < 0)
			{
				index = sceneInfos.Count - 1;
			}
			else if (index >= sceneInfos.Count)
			{
				index = 0;
			}
			sceneInfo = sceneInfos[index];
		}
		while (sceneInfo.unlisted);
		return index;
	}
}
}
