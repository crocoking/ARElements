using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class GroundPlaneRangeOverride : MonoBehaviour
{
	private Renderer _renderer;

	private float startRadius;

	private static bool hasOverride;

	private static float overrideRadius;

	private const string key = "_FocalPointRange";

	private Renderer renderer
	{
		[CompilerGenerated]
		get
		{
			return (!_renderer) ? (_renderer = base.gameObject.GetComponent<Renderer>()) : _renderer;
		}
	}

	private void Awake()
	{
		if ((bool)renderer)
		{
			startRadius = renderer.sharedMaterial.GetFloat("_FocalPointRange");
		}
	}

	private void LateUpdate()
	{
		if ((bool)renderer)
		{
			renderer.sharedMaterial.SetFloat("_FocalPointRange", (!hasOverride) ? startRadius : overrideRadius);
		}
	}

	public static void SetOverride(float radius)
	{
		hasOverride = true;
		overrideRadius = radius;
	}

	public static void ClearOverride()
	{
		hasOverride = false;
		overrideRadius = 0f;
	}
}
}
