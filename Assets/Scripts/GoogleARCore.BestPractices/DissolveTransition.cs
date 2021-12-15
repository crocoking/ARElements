using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class DissolveTransition : MonoBehaviour
{
	[Serializable]
	public class EnabledDependent
	{
		public float threshhold = 0.5f;

		public GameObject gameObject;
	}

	public float maxHeight = 1f;

	public float minHeight;

	public float maxRampSize = 3f;

	public float minRampSize = 3f;

	public Animator animator;

	public Renderer targetRenderer;

	public List<EnabledDependent> enabledDependents = new List<EnabledDependent>();

	private MaterialPropertyBlock propertyBlock;

	private void Start()
	{
		propertyBlock = new MaterialPropertyBlock();
	}

	private void LateUpdate()
	{
		float @float = animator.GetFloat("Dissolve");
		targetRenderer.GetPropertyBlock(propertyBlock);
		Vector3 position = base.transform.position;
		propertyBlock.SetFloat("_DissolveWeight", (@float < 1f) ? 1 : 0);
		propertyBlock.SetFloat("_DissolveHeight", Mathf.Lerp(position.y + minHeight, position.y + maxHeight, @float));
		propertyBlock.SetFloat("_DissolveRampSize", Mathf.Lerp(minRampSize, maxRampSize, @float));
		targetRenderer.SetPropertyBlock(propertyBlock);
		foreach (EnabledDependent enabledDependent in enabledDependents)
		{
			if (enabledDependent == null || !enabledDependent.gameObject)
			{
				continue;
			}
			if (@float < enabledDependent.threshhold)
			{
				if (enabledDependent.gameObject.activeSelf)
				{
					enabledDependent.gameObject.SetActive(value: false);
				}
			}
			else if (!enabledDependent.gameObject.activeSelf)
			{
				enabledDependent.gameObject.SetActive(value: true);
			}
		}
	}

	private void OnDrawGizmos()
	{
		Vector3 position = base.transform.position;
		Gizmos.DrawLine(position + new Vector3(0f, minHeight, 0f), position + new Vector3(0f, maxHeight, 0f));
	}
}
}
