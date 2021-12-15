using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CameraBlurController : MonoBehaviour
{
	public delegate float RequiredBlurDelegate();

	private static CameraBlurController _current;

	public BlurEffect backgroundBlurEffect;

	public BlurEffect blurEffect;

	private HashSet<RequiredBlurDelegate> requiredBackgroundBlurs = new HashSet<RequiredBlurDelegate>();

	private HashSet<RequiredBlurDelegate> requiredBlurs = new HashSet<RequiredBlurDelegate>();

	public static CameraBlurController current => _current ? _current : (_current = Object.FindObjectOfType<CameraBlurController>());

	private void LateUpdate()
	{
		float num = 0f;
		foreach (RequiredBlurDelegate requiredBackgroundBlur in requiredBackgroundBlurs)
		{
			num = Mathf.Max(num, requiredBackgroundBlur());
		}
		float num2 = 0f;
		foreach (RequiredBlurDelegate requiredBlur in requiredBlurs)
		{
			num2 = Mathf.Max(num2, requiredBlur());
		}
		if ((bool)backgroundBlurEffect)
		{
			backgroundBlurEffect.blurSize = num;
			if (num <= 0f)
			{
				if (backgroundBlurEffect.enabled)
				{
					backgroundBlurEffect.enabled = false;
				}
			}
			else if (!backgroundBlurEffect.enabled)
			{
				backgroundBlurEffect.enabled = true;
			}
		}
		if (!blurEffect)
		{
			return;
		}
		blurEffect.blurSize = num2;
		if (num2 <= 0f)
		{
			if (blurEffect.enabled)
			{
				blurEffect.enabled = false;
			}
		}
		else if (!blurEffect.enabled)
		{
			blurEffect.enabled = true;
		}
	}

	public void RegisterRequiredBackgroundBlur(RequiredBlurDelegate requiredBlur)
	{
		requiredBackgroundBlurs.Add(requiredBlur);
	}

	public void UnregisterRequiredBackgroundBlur(RequiredBlurDelegate requiredBlur)
	{
		requiredBackgroundBlurs.Remove(requiredBlur);
	}

	public void RegisterRequiredBlur(RequiredBlurDelegate requiredBlur)
	{
		requiredBlurs.Add(requiredBlur);
	}

	public void UnregisterRequiredBlur(RequiredBlurDelegate requiredBlur)
	{
		requiredBlurs.Remove(requiredBlur);
	}
}
}
