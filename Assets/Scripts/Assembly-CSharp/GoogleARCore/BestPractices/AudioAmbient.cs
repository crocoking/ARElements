using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class AudioAmbient : MonoBehaviour
{
	[Serializable]
	public class AudioGroup
	{
		public enum DelayType
		{
			FromStartOfClip,
			FromEndOfClip
		}

		public DelayType delayType = DelayType.FromEndOfClip;

		public float minDelay = 1f;

		public float maxDelay = 1f;

		public AudioEvent audioEvent;
	}

	public AudioSource audioSource;

	public float volume = 1f;

	public AudioGroup initialAudioGroup = new AudioGroup();

	public List<AudioGroup> audioGroups = new List<AudioGroup>
	{
		new AudioGroup
		{
			delayType = AudioGroup.DelayType.FromEndOfClip,
			minDelay = 1f,
			maxDelay = 1f
		}
	};

	private void OnEnable()
	{
		StartCoroutine(PlayCoroutine());
	}

	private IEnumerator PlayCoroutine()
	{
		yield return StartCoroutine(HandleGroup(initialAudioGroup));
		while (true)
		{
			if (audioGroups.Count <= 0)
			{
				yield return null;
				yield break;
			}
			AudioGroup group = audioGroups[UnityEngine.Random.Range(0, audioGroups.Count)];
			if (group == null)
			{
				break;
			}
			yield return StartCoroutine(HandleGroup(group));
		}
		yield return null;
	}

	private IEnumerator HandleGroup(AudioGroup group)
	{
		AudioEvent.PlayInfo playInfo = default(AudioEvent.PlayInfo);
		if ((bool)group.audioEvent)
		{
			playInfo = group.audioEvent.GetPlayInfo();
		}
		float delay = UnityEngine.Random.Range(group.minDelay, group.maxDelay);
		if (playInfo.isValid)
		{
			if ((bool)audioSource)
			{
				audioSource.PlayOneShot(playInfo.clip, playInfo.volume * volume);
			}
			else
			{
				playInfo.PlayAtPoint(base.transform.position, volume);
			}
			if (group.delayType == AudioGroup.DelayType.FromEndOfClip)
			{
				float num = playInfo.clip.length;
				if ((bool)audioSource)
				{
					num /= audioSource.pitch;
				}
				delay += num;
			}
		}
		if (delay > 0f)
		{
			yield return new WaitForSeconds(delay);
		}
	}
}
}
