using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.Rendering;

namespace GoogleARCore.BestPractices{

public class RenderScaleManager : MonoBehaviour
{
	public float renderScale = 1f;

	public float editorRenderScale = 1f;

	public LayerMask layerMask = 0;

	public List<Camera> camerasToResetTarget = new List<Camera>();

	private Camera _camera;

	private RenderTexture _renderTexture;

	private CommandBuffer commandBuffer;

	private int backupCullingMask;

	public Camera camera
	{
		[CompilerGenerated]
		get
		{
			return (!_camera) ? (_camera = base.gameObject.GetComponent<Camera>()) : _camera;
		}
	}

	public float actualRenderScale
	{
		[CompilerGenerated]
		get
		{
			return (!Application.isEditor) ? renderScale : editorRenderScale;
		}
	}

	public int actualWidth
	{
		[CompilerGenerated]
		get
		{
			return Mathf.RoundToInt((float)Screen.width * actualRenderScale);
		}
	}

	public int actualHeight
	{
		[CompilerGenerated]
		get
		{
			return Mathf.RoundToInt((float)Screen.height * actualRenderScale);
		}
	}

	public RenderTexture renderTarget
	{
		get
		{
			ValidateRenderTarget(actualWidth, actualHeight);
			return _renderTexture;
		}
	}

	private void Start()
	{
		commandBuffer = new CommandBuffer();
		camera.AddCommandBuffer(CameraEvent.BeforeForwardOpaque, commandBuffer);
	}

	private void ValidateRenderTarget(int width, int height)
	{
		if (!_renderTexture || _renderTexture.width != width || _renderTexture.height != height)
		{
			if ((bool)_renderTexture)
			{
				Object.DestroyImmediate(_renderTexture);
			}
			_renderTexture = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
			_renderTexture.filterMode = FilterMode.Point;
		}
	}

	private void OnPreCull()
	{
		foreach (Camera item in camerasToResetTarget)
		{
			item.targetTexture = null;
		}
		backupCullingMask = camera.cullingMask;
		camera.cullingMask = layerMask;
		commandBuffer.Clear();
		commandBuffer.Blit(renderTarget, BuiltinRenderTextureType.CameraTarget);
	}

	private void OnPostRender()
	{
		camera.cullingMask = backupCullingMask;
	}
}
}
