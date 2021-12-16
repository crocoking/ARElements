using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Audio;

namespace GoogleARCore.BestPractices{

[CreateAssetMenu]
public class AudioEvent : ScriptableObject
{
	public struct PlayInfo
	{
		public float volume;

		public AudioClip clip;

		public bool isValid => clip;

		public AudioSource PlayAtPoint(Vector3 point, float volumeScale = 1f, float spacialBlend = 1f)
		{
			if (!isValid)
			{
				return null;
			}
			AudioSource audioSource = new GameObject("TempAudioSource").AddComponent<AudioSource>();
			audioSource.outputAudioMixerGroup = defaultAudioMixerGroup;
			audioSource.spatialBlend = spacialBlend;
			audioSource.PlayOneShot(clip, volume * volumeScale);
			UnityEngine.Object.DontDestroyOnLoad(audioSource.gameObject);
			UnityEngine.Object.Destroy(audioSource.gameObject, clip.length + 0.25f);
			return audioSource;
		}
	}

	public enum SourceType
	{
		Auto,
		AudioClip,
		SubEvent
	}

	public float volume = 1f;

	public SourceType sourceType;

	public List<AudioEvent> subEvents = new List<AudioEvent>();

	public List<AudioClip> clips = new List<AudioClip>();

	private static AudioMixerGroup _defaultAudioMixerGroup;

	private static AudioMixerGroup defaultAudioMixerGroup
	{
		get
		{
			if (!_defaultAudioMixerGroup)
			{
				AudioMixer audioMixer = Resources.Load<AudioMixer>("ARCoreBestPractices/Audio/AudioMixer");
				_defaultAudioMixerGroup = audioMixer.FindMatchingGroups("Master/Standard").Single();
			}
			return _defaultAudioMixerGroup;
		}
	}

	public PlayInfo GetPlayInfo()
	{
		PlayInfo result = default(PlayInfo);
		SourceType sourceType = this.sourceType;
		if (sourceType == SourceType.Auto)
		{
			sourceType = ((subEvents.Count <= 0) ? SourceType.AudioClip : SourceType.SubEvent);
		}
		if (sourceType == SourceType.SubEvent && subEvents.Count <= 0)
		{
			sourceType = SourceType.AudioClip;
		}
		if (sourceType == SourceType.AudioClip && clips.Count <= 0)
		{
			return result;
		}
		switch (sourceType)
		{
		case SourceType.SubEvent:
		{
			AudioEvent audioEvent = subEvents[UnityEngine.Random.Range(0, subEvents.Count)];
			PlayInfo playInfo = audioEvent.GetPlayInfo();
			result = playInfo;
			result.volume *= volume;
			break;
		}
		case SourceType.AudioClip:
		{
			AudioClip audioClip = (result.clip = clips[UnityEngine.Random.Range(0, clips.Count)]);
			result.volume = volume;
			break;
		}
		default:
			throw new Exception(string.Format("{0} has unexpected value {1}.", "actualSourceType", sourceType));
		}
		return result;
	}

	public AudioSource PlayAtPoint(Vector3 point, float volumeScale = 1f)
	{
		PlayInfo playInfo = GetPlayInfo();
		if (!playInfo.isValid)
		{
			return null;
		}
		return playInfo.PlayAtPoint(point, volumeScale);
	}

	public AudioSource Play2D(float volumeScale = 1f)
	{
		PlayInfo playInfo = GetPlayInfo();
		if (!playInfo.isValid)
		{
			return null;
		}
		AudioSource audioSource = new GameObject("TempAudioSource").AddComponent<AudioSource>();
		audioSource.outputAudioMixerGroup = defaultAudioMixerGroup;
		audioSource.spatialBlend = 0f;
		audioSource.PlayOneShot(playInfo.clip, playInfo.volume * volumeScale);
		UnityEngine.Object.DontDestroyOnLoad(audioSource.gameObject);
		UnityEngine.Object.Destroy(audioSource.gameObject, playInfo.clip.length + 0.25f);
		return audioSource;
	}

	public void PlayOnSource(AudioSource audioSource, float volumeScale = 1f)
	{
		if ((bool)audioSource)
		{
			PlayInfo playInfo = GetPlayInfo();
			if (playInfo.isValid)
			{
				audioSource.PlayOneShot(playInfo.clip, playInfo.volume * volumeScale);
			}
		}
	}
}
}
