using System.Collections;
using System.Collections.Generic;
using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class TranslationEffect : MonoBehaviour
{
	public TranslationController translationController;

	public ParticleSystem translationEffect;

	public float translationEffectScale = 1f;

	public float translationEffectDestroyDelay;

	public float translationEffectStartDelay;

	public ParticleSystem startEffect;

	public float startEffectScale = 1f;

	public ParticleSystem endEffect;

	public float endEffectScale = 1f;

	private ParticleSystem translationEffectInstance;

	private Coroutine createTranslationEffectCoroutine;

	private static List<Collider> colliderCache = new List<Collider>();

	private void OnEnable()
	{
		translationController.onStartTransformation.AddListener(OnStartTransform);
		translationController.onEndTransformation.AddListener(OnEndTransform);
	}

	private void OnDisable()
	{
		translationController.onStartTransformation.RemoveListener(OnStartTransform);
		translationController.onEndTransformation.RemoveListener(OnEndTransform);
	}

	private void OnStartTransform()
	{
		float num = CalculateScaleFactor();
		if ((bool)startEffect)
		{
			ParticleSystem particleSystem = Object.Instantiate(startEffect, base.transform);
			particleSystem.transform.localScale = Vector3.one * num * startEffectScale;
		}
		if (translationEffectStartDelay > 0f)
		{
			createTranslationEffectCoroutine = StartCoroutine(CreateTranslationEffectDelayed(num, translationEffectStartDelay));
		}
		else
		{
			CreateTranslationEffect(num);
		}
	}

	private IEnumerator CreateTranslationEffectDelayed(float scaleFactor, float delay)
	{
		yield return new WaitForSeconds(delay);
		CreateTranslationEffect(scaleFactor);
		createTranslationEffectCoroutine = null;
	}

	private void CreateTranslationEffect(float scaleFactor)
	{
		if ((bool)translationEffect)
		{
			translationEffectInstance = Object.Instantiate(translationEffect, base.transform);
			translationEffectInstance.transform.localScale = Vector3.one * scaleFactor * translationEffectScale;
		}
	}

	private void OnEndTransform()
	{
		if ((bool)endEffect)
		{
			float num = CalculateScaleFactor();
			ParticleSystem particleSystem = Object.Instantiate(endEffect, base.transform);
			particleSystem.transform.localScale = Vector3.one * num * endEffectScale;
		}
		if ((bool)translationEffectInstance)
		{
			Object.Destroy(translationEffectInstance.gameObject, translationEffectDestroyDelay);
		}
		if (createTranslationEffectCoroutine != null)
		{
			StopCoroutine(createTranslationEffectCoroutine);
		}
	}

	private float CalculateScaleFactor()
	{
		base.gameObject.GetComponentsInChildren(colliderCache);
		if (colliderCache.Count <= 0)
		{
			return 1f;
		}
		Bounds bounds = colliderCache[0].bounds;
		for (int i = 1; i < colliderCache.Count; i++)
		{
			Bounds bounds2 = colliderCache[i].bounds;
			bounds.Encapsulate(bounds2);
		}
		Vector3 extents = bounds.extents;
		extents.y = 0f;
		Vector3 lossyScale = base.transform.lossyScale;
		extents.x /= lossyScale.x;
		extents.z /= lossyScale.z;
		return extents.magnitude;
	}
}
}
