using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.Audio;

namespace GoogleARCore.BestPractices{

public class AmbientAudioLoopManager : MonoBehaviour
{
	[Serializable]
	public class Entry
	{
		public string name = string.Empty;

		public AudioClip audioClip;

		public float targetVolume = 1f;

		[Range(0f, 1f)]
		public float spacialBlend;
	}

	public struct PlayInfo
	{
		public AmbientAudioLoopManager manager;

		public Entry entry;

		public AudioSource audioSource;

		public float overrideTargetVolume;

		public float targetVolumeScaler;

		public float overrideTransitionRate;

		public bool isValid
		{
			[CompilerGenerated]
			get
			{
				return entry != null && (bool)audioSource && (bool)manager;
			}
		}

		public float targetVolume => ((!(overrideTargetVolume >= 0f)) ? entry.targetVolume : overrideTargetVolume) * targetVolumeScaler;

		public float transitionRate => (!(overrideTransitionRate >= 0f)) ? manager.defaultTransitionRate : overrideTransitionRate;

		public float scaledTransitionRate => transitionRate * entry.targetVolume;
	}

	private static AmbientAudioLoopManager _current;

	public List<Entry> entries = new List<Entry>();

	public AudioMixerGroup audioMixerGroup;

	public float defaultTransitionRate = 0.25f;

	private PlayInfo currentPlayInfo;

	private List<PlayInfo> garbageInfos = new List<PlayInfo>();

	public static AmbientAudioLoopManager current => _current ? _current : (_current = UnityEngine.Object.FindObjectOfType<AmbientAudioLoopManager>());

	private void Update()
	{
		if (currentPlayInfo.isValid)
		{
			float scaledTransitionRate = currentPlayInfo.scaledTransitionRate;
			currentPlayInfo.audioSource.volume = Mathf.MoveTowards(currentPlayInfo.audioSource.volume, currentPlayInfo.targetVolume, scaledTransitionRate * Time.deltaTime);
		}
		else
		{
			if ((bool)currentPlayInfo.audioSource)
			{
				Debug.Log(currentPlayInfo.audioSource);
				UnityEngine.Object.DestroyImmediate(currentPlayInfo.audioSource.gameObject);
			}
			currentPlayInfo = default(PlayInfo);
		}
		for (int num = garbageInfos.Count - 1; num >= 0; num--)
		{
			PlayInfo playInfo = garbageInfos[num];
			if (!playInfo.isValid)
			{
				if ((bool)playInfo.audioSource)
				{
					UnityEngine.Object.DestroyImmediate(playInfo.audioSource.gameObject);
				}
				garbageInfos.RemoveAt(num);
			}
			else
			{
				float scaledTransitionRate2 = playInfo.scaledTransitionRate;
				playInfo.audioSource.volume = Mathf.MoveTowards(playInfo.audioSource.volume, 0f, scaledTransitionRate2 * Time.deltaTime);
				if (playInfo.audioSource.volume <= 0f)
				{
					garbageInfos.RemoveAt(num);
					UnityEngine.Object.DestroyImmediate(playInfo.audioSource.gameObject);
				}
			}
		}
	}

	public Entry FindEntry(string name)
	{
		return entries.FirstOrDefault((Entry v) => v.name.Equals(name, StringComparison.InvariantCultureIgnoreCase));
	}

	public PlayInfo SetEntry(string name, float overrideVolume = -1f, float overrideTransitionRate = -1f)
	{
		return SetEntry(FindEntry(name), overrideVolume, overrideTransitionRate);
	}

	public PlayInfo SetEntry(Entry entry, float overrideTargetVolume = -1f, float overrideTransitionRate = -1f)
	{
		if (entry != null && entry == currentPlayInfo.entry)
		{
			SetCurrentOverrideTargetVolume(overrideTargetVolume);
			SetCurrentOverrideTransitionRate(overrideTransitionRate);
			return currentPlayInfo;
		}
		if (currentPlayInfo.isValid)
		{
			garbageInfos.Add(currentPlayInfo);
		}
		currentPlayInfo = new PlayInfo
		{
			entry = entry,
			manager = this,
			targetVolumeScaler = 1f,
			overrideTargetVolume = -1f,
			overrideTransitionRate = -1f
		};
		if (entry != null)
		{
			SetCurrentOverrideTargetVolume(overrideTargetVolume);
			SetCurrentOverrideTransitionRate(overrideTransitionRate);
			currentPlayInfo.audioSource = new GameObject(entry.name).AddComponent<AudioSource>();
			currentPlayInfo.audioSource.outputAudioMixerGroup = audioMixerGroup;
			UnityEngine.Object.DontDestroyOnLoad(currentPlayInfo.audioSource.gameObject);
			currentPlayInfo.audioSource.volume = 0f;
			currentPlayInfo.audioSource.loop = true;
			currentPlayInfo.audioSource.clip = entry.audioClip;
			currentPlayInfo.audioSource.Play();
		}
		return currentPlayInfo;
	}

	public void SetCurrentOverrideTargetVolume(float overrideTargetVolume = -1f)
	{
		if (currentPlayInfo.entry != null)
		{
			if (overrideTargetVolume >= 0f)
			{
				currentPlayInfo.overrideTargetVolume = overrideTargetVolume;
			}
			else
			{
				currentPlayInfo.overrideTargetVolume = -1f;
			}
		}
	}

	public void SetCurrentVolumeScale(float volumeScale = 1f)
	{
		if (currentPlayInfo.entry != null)
		{
			currentPlayInfo.targetVolumeScaler = volumeScale;
		}
	}

	public void SetCurrentOverrideTransitionRate(float overrideTransitionRate = -1f)
	{
		if (currentPlayInfo.entry != null)
		{
			if (overrideTransitionRate >= 0f)
			{
				currentPlayInfo.overrideTransitionRate = overrideTransitionRate;
			}
			else
			{
				currentPlayInfo.overrideTransitionRate = -1f;
			}
		}
	}

	public PlayInfo GetCurrentPlayInfo()
	{
		return currentPlayInfo;
	}
}
}
