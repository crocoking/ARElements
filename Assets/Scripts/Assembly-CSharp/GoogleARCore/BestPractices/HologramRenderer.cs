using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using Unity.Collections;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.SceneManagement;

namespace GoogleARCore.BestPractices{

public class HologramRenderer : MonoBehaviour
{
	private struct RenderInfo : IDisposable
	{
		public Transform transform;

		public Mesh mesh;

		public bool isUniqueMesh;

		public NativeArray<int> subMeshIndices;

		public int subMeshIndexCount;

		private static List<Vector3> vertexCache = new List<Vector3>();

		public RenderInfo(int subMeshMaxCount)
		{
			transform = null;
			mesh = null;
			isUniqueMesh = false;
			subMeshIndices = new NativeArray<int>(subMeshMaxCount, Allocator.Persistent);
			subMeshIndexCount = 0;
		}

		public void Dispose()
		{
			transform = null;
			subMeshIndices.Dispose();
			subMeshIndexCount = 0;
			if (isUniqueMesh)
			{
				UnityEngine.Object.DestroyImmediate(mesh);
			}
			mesh = null;
		}

		public void BakeSkinnedSnapsot(SkinnedMeshRenderer skinnedMeshRenderer)
		{
			isUniqueMesh = true;
			mesh = new Mesh();
			skinnedMeshRenderer.BakeMesh(mesh);
			Matrix4x4 inverse = Matrix4x4.Scale(skinnedMeshRenderer.transform.lossyScale).inverse;
			vertexCache.Clear();
			mesh.GetVertices(vertexCache);
			for (int i = 0; i < vertexCache.Count; i++)
			{
				vertexCache[i] = inverse.MultiplyPoint3x4(vertexCache[i]);
			}
			mesh.SetVertices(vertexCache);
			vertexCache.Clear();
			mesh.GetNormals(vertexCache);
			for (int j = 0; j < vertexCache.Count; j++)
			{
				vertexCache[j] = vertexCache[j].normalized;
			}
			mesh.SetNormals(vertexCache);
			vertexCache.Clear();
		}
	}

	private static HologramRenderer _current;

	public Camera targetCamera;

	public Material material;

	public Material depthMaterial;

	private List<RenderInfo> renderInfos = new List<RenderInfo>();

	private CommandBuffer commandBuffer;

	private const CameraEvent cameraEvent = CameraEvent.AfterForwardAlpha;

	public static HologramRenderer current
	{
		[CompilerGenerated]
		get
		{
			return _current ? _current : (_current = UnityEngine.Object.FindObjectOfType<HologramRenderer>());
		}
	}

	public float intensity
	{
		get
		{
			return Shader.GetGlobalFloat("_HologramGlobalIntensity");
		}
		set
		{
			value = Mathf.Max(value, 0f);
			Shader.SetGlobalFloat("_HologramGlobalIntensity", value);
		}
	}

	private void OnEnable()
	{
		SceneManager.sceneUnloaded += OnSceneUnloaded;
		commandBuffer = new CommandBuffer();
		targetCamera.AddCommandBuffer(CameraEvent.AfterForwardAlpha, commandBuffer);
	}

	private void OnDisable()
	{
		SceneManager.sceneUnloaded -= OnSceneUnloaded;
		CleanUp();
	}

	private void OnDestroy()
	{
		ClearSceneRoots();
		CleanUp();
	}

	private void LateUpdate()
	{
		commandBuffer.Clear();
		foreach (RenderInfo renderInfo3 in renderInfos)
		{
			Matrix4x4 localToWorldMatrix = renderInfo3.transform.localToWorldMatrix;
			foreach (int subMeshIndex in renderInfo3.subMeshIndices)
			{
				commandBuffer.DrawMesh(renderInfo3.mesh, localToWorldMatrix, depthMaterial, subMeshIndex, 0);
			}
		}
		foreach (RenderInfo renderInfo4 in renderInfos)
		{
			Matrix4x4 localToWorldMatrix2 = renderInfo4.transform.localToWorldMatrix;
			foreach (int subMeshIndex2 in renderInfo4.subMeshIndices)
			{
				commandBuffer.DrawMesh(renderInfo4.mesh, localToWorldMatrix2, material, subMeshIndex2, 0);
			}
		}
	}

	private void OnSceneUnloaded(Scene scene)
	{
		ClearSceneRoots();
		if (commandBuffer != null)
		{
			commandBuffer.Clear();
		}
	}

	public void ClearSceneRoots()
	{
		foreach (RenderInfo renderInfo in renderInfos)
		{
			renderInfo.Dispose();
		}
		renderInfos.Clear();
	}

	private void CleanUp()
	{
		if (commandBuffer != null)
		{
			targetCamera.RemoveCommandBuffer(CameraEvent.AfterForwardAlpha, commandBuffer);
			commandBuffer.Dispose();
			commandBuffer = null;
		}
	}

	public void AppendSceneRoot(GameObject sceneRoot)
	{
		if (!sceneRoot)
		{
			throw new ArgumentNullException("sceneRoot");
		}
		CollectRenderInfos(sceneRoot, renderInfos);
	}

	private static void CollectRenderInfos(GameObject root, List<RenderInfo> renderInfos)
	{
		Renderer component = root.GetComponent<Renderer>();
		HologramExplicitRender component2 = root.GetComponent<HologramExplicitRender>();
		bool flag = component;
		if ((bool)component && (bool)component2)
		{
			flag = component2.state != HologramExplicitRender.State.Disabled && root.activeSelf && component.enabled;
		}
		if ((bool)component && flag)
		{
			Mesh mesh = null;
			if (component is SkinnedMeshRenderer)
			{
				SkinnedMeshRenderer skinnedMeshRenderer = (SkinnedMeshRenderer)component;
				mesh = skinnedMeshRenderer.sharedMesh;
			}
			else if (component is MeshRenderer)
			{
				MeshFilter component3 = root.GetComponent<MeshFilter>();
				if ((bool)component3)
				{
					mesh = component3.sharedMesh;
				}
			}
			if ((bool)mesh && mesh.subMeshCount > 0)
			{
				Material[] sharedMaterials = component.sharedMaterials;
				RenderInfo renderInfo = new RenderInfo(sharedMaterials.Length);
				renderInfo.transform = component.transform;
				renderInfo.mesh = mesh;
				RenderInfo item = renderInfo;
				for (int i = 0; i < sharedMaterials.Length; i++)
				{
					Material material = sharedMaterials[i];
					if (((bool)material && !(material.GetTag("RenderType", searchFallbacks: false) != "Opaque")) || ((bool)component2 && component2.state == HologramExplicitRender.State.Enabled))
					{
						int value = i % mesh.subMeshCount;
						item.subMeshIndices[item.subMeshIndexCount] = value;
						item.subMeshIndexCount++;
					}
				}
				if (item.subMeshIndexCount > 0)
				{
					if (component is SkinnedMeshRenderer)
					{
						item.BakeSkinnedSnapsot((SkinnedMeshRenderer)component);
					}
					renderInfos.Add(item);
				}
				else
				{
					item.Dispose();
				}
			}
		}
		for (int j = 0; j < root.transform.childCount; j++)
		{
			GameObject gameObject = root.transform.GetChild(j).gameObject;
			HologramExplicitRender component4 = gameObject.GetComponent<HologramExplicitRender>();
			bool flag2 = gameObject.activeSelf;
			if ((bool)component4)
			{
				if (component4.state == HologramExplicitRender.State.Disabled)
				{
					flag2 = false;
				}
				else if (component4.state == HologramExplicitRender.State.Enabled)
				{
					flag2 = true;
				}
			}
			if (flag2)
			{
				CollectRenderInfos(gameObject, renderInfos);
			}
		}
	}
}
}
