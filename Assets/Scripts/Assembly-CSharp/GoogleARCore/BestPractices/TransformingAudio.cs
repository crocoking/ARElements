using System.Collections.Generic;
using System.Linq;
using ARElements;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class TransformingAudio : MonoBehaviour
{
	public enum TransformationType
	{
		Translation,
		Rotation
	}

	public AudioSource audioSource;

	public List<Component> transformationControllerComponents;

	public TransformationType transformationType;

	public float transformationEffectScaler = 1f;

	public float threshold;

	public float minVolume;

	public float maxVolume = 1f;

	public float minPitch = 1f;

	public float maxPitch = 1f;

	public float adjustmentRate = 20f;

	private Vector3 previousPosition;

	private Quaternion previousRotation;

	private float transformationAudioScale;

	private bool isTransforming => transformationControllerComponents.Any((Component v) => v is ITransformationController && ((ITransformationController)v).isTransforming);

	private void Start()
	{
		previousPosition = base.transform.position;
		previousRotation = base.transform.localRotation;
		audioSource.volume = 0f;
	}

	private void Update()
	{
		UpdateAudio();
		previousPosition = base.transform.position;
		previousRotation = base.transform.localRotation;
	}

	private void UpdateAudio()
	{
		UpdateAudioTransformationScale();
		float b = Mathf.Lerp(minVolume, maxVolume, transformationAudioScale);
		float b2 = Mathf.LerpUnclamped(minPitch, maxPitch, transformationAudioScale);
		if (!isTransforming || transformationAudioScale < threshold)
		{
			b = 0f;
		}
		audioSource.volume = Mathf.Lerp(audioSource.volume, b, adjustmentRate * Time.deltaTime);
		audioSource.pitch = Mathf.Lerp(audioSource.pitch, b2, adjustmentRate * Time.deltaTime);
		if (audioSource.volume < 0.05f)
		{
			if (audioSource.isPlaying)
			{
				audioSource.Pause();
			}
		}
		else if (!audioSource.isPlaying)
		{
			audioSource.Play();
		}
	}

	public void UpdateAudioTransformationScale()
	{
		if (!isTransforming)
		{
			transformationAudioScale = 0f;
			return;
		}
		float num = 0f;
		if (transformationType == TransformationType.Translation)
		{
			Vector2 vector = Camera.main.WorldToViewportPoint(base.transform.position);
			Vector2 vector2 = Camera.main.WorldToViewportPoint(previousPosition);
			num = (vector - vector2).magnitude * 10f;
		}
		else if (transformationType == TransformationType.Rotation)
		{
			num = Quaternion.Angle(base.transform.localRotation, previousRotation) / 45f;
		}
		num = (transformationAudioScale = num * transformationEffectScaler);
	}
}
}
