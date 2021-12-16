using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CaptureCameraTexture : MonoBehaviour
{
	public string captureTag = string.Empty;

	public string shaderVariable = string.Empty;

	public bool requiresUsers;

	private static Dictionary<string, CaptureCameraTexture> taggedInstances = new Dictionary<string, CaptureCameraTexture>();

	private HashSet<object> users = new HashSet<object>();

	public RenderTexture cameraTexture { get; private set; }

	private void Awake()
	{
		if (!string.IsNullOrEmpty(captureTag))
		{
			taggedInstances.Add(captureTag, this);
		}
	}

	private void OnDestroy()
	{
		if (!string.IsNullOrEmpty(captureTag) && taggedInstances.ContainsKey(captureTag))
		{
			taggedInstances.Remove(captureTag);
		}
	}

	public static CaptureCameraTexture GetByTag(string tag)
	{
		taggedInstances.TryGetValue(tag, out var value);
		return value;
	}

	public void RegisterUser(object user)
	{
		users.Add(user);
	}

	public void UnregisterUser(object user)
	{
		users.Remove(user);
	}

	private void CleanUsers()
	{
		users.RemoveWhere((object v) => v == null);
	}

	private void ValidateCameraTexture(RenderTexture source)
	{
		if (!cameraTexture || cameraTexture.width != source.width || cameraTexture.height != source.height || cameraTexture.format != source.format)
		{
			if ((bool)cameraTexture)
			{
				Object.DestroyImmediate(cameraTexture);
			}
			cameraTexture = new RenderTexture(source.width, source.height, 0, source.format);
			cameraTexture.Create();
		}
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		CleanUsers();
		if (requiresUsers && users.Count <= 0)
		{
			Graphics.Blit(source, destination);
			return;
		}
		ValidateCameraTexture(source);
		cameraTexture.DiscardContents();
		Graphics.Blit(source, cameraTexture);
		Graphics.Blit(source, destination);
		if (!string.IsNullOrEmpty(shaderVariable))
		{
			Shader.SetGlobalTexture(shaderVariable, cameraTexture);
		}
	}
}
}
