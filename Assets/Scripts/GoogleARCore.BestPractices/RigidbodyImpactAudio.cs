using System;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RigidbodyImpactAudio : MonoBehaviour
{
	[Serializable]
	public class ImpactAudio
	{
		public AudioEvent audioEvent;

		public float minSpeed;
	}

	private Rigidbody _rigidbody;

	public AudioSource audioSource;

	public float minTimeBetweenSounds;

	public float minVolume = 0.25f;

	public float maxVolume = 1f;

	public float minSpeed;

	public float maxSpeed = 2f;

	public List<ImpactAudio> impactAudios = new List<ImpactAudio>();

	private float lastSoundTime = float.NegativeInfinity;

	public Rigidbody rigidbody
	{
		[CompilerGenerated]
		get
		{
			return (!_rigidbody) ? (_rigidbody = base.gameObject.GetComponent<Rigidbody>()) : _rigidbody;
		}
	}

	private void OnCollisionEnter(Collision collision)
	{
		float magnitude = collision.relativeVelocity.magnitude;
		ImpactAudio impactAudio = null;
		for (int i = 0; i < impactAudios.Count; i++)
		{
			ImpactAudio impactAudio2 = impactAudios[i];
			ImpactAudio impactAudio3 = null;
			if (i < impactAudios.Count - 1)
			{
				impactAudio3 = impactAudios[i + 1];
			}
			if (magnitude >= impactAudio2.minSpeed)
			{
				if (impactAudio3 == null)
				{
					impactAudio = impactAudio2;
					break;
				}
				if (magnitude < impactAudio3.minSpeed)
				{
					impactAudio = impactAudio2;
					break;
				}
			}
		}
		if (impactAudio != null && (bool)impactAudio.audioEvent && Time.timeSinceLevelLoad - lastSoundTime >= minTimeBetweenSounds)
		{
			float t = (magnitude - minSpeed) / (maxSpeed - minSpeed);
			float volumeScale = Mathf.LerpUnclamped(minVolume, maxVolume, t);
			if ((bool)audioSource)
			{
				impactAudio.audioEvent.PlayOnSource(audioSource, volumeScale);
			}
			else
			{
				impactAudio.audioEvent.PlayAtPoint(base.transform.position, volumeScale);
			}
			lastSoundTime = Time.timeSinceLevelLoad;
		}
	}
}
}
