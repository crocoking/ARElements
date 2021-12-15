using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class AudioEventTrigger : MonoBehaviour
{
	[Serializable]
	public class NamedEvent
	{
		public enum Play2D
		{
			Auto,
			True,
			False
		}

		public string name = string.Empty;

		public AudioEvent audioEvent;

		public AudioSource audioSource;

		public float volume = 1f;

		public Play2D play2D;
	}

	[Header("Lifecycle Events")]
	public bool playOnEnable;

	public bool playOnDisable;

	public bool playOnStart;

	public bool playOnDestroy;

	[Header("Trigger Settings")]
	public float volume = 1f;

	public bool play2D;

	public AudioEvent audioEvent;

	public AudioSource audioSource;

	[Header("Named Events")]
	public List<NamedEvent> namedEvents = new List<NamedEvent>();

	private void OnEnable()
	{
		if (playOnEnable)
		{
			TriggerAudioEvent();
		}
	}

	private void OnDisable()
	{
		if (playOnDisable)
		{
			TriggerAudioEvent();
		}
	}

	private void Start()
	{
		if (playOnStart)
		{
			TriggerAudioEvent();
		}
	}

	private void OnDestroy()
	{
		if (playOnDestroy)
		{
			TriggerAudioEvent();
		}
	}

	public void TriggerNamedAudioEvent(string name)
	{
		if (!Application.isPlaying)
		{
			return;
		}
		foreach (NamedEvent item in namedEvents.Where((NamedEvent v) => v != null && v.name == name))
		{
			TriggerNamedEvent(item);
		}
	}

	private void TriggerNamedEvent(NamedEvent namedEvent)
	{
		AudioEvent audioEvent = ((!namedEvent.audioEvent) ? this.audioEvent : namedEvent.audioEvent);
		AudioSource audioSource = ((!namedEvent.audioSource) ? this.audioSource : namedEvent.audioSource);
		float volumeScale = volume * namedEvent.volume;
		bool flag = play2D;
		if (namedEvent.play2D != 0)
		{
			flag = namedEvent.play2D == NamedEvent.Play2D.True;
		}
		if ((bool)audioEvent)
		{
			if ((bool)audioSource)
			{
				audioEvent.PlayOnSource(audioSource, volumeScale);
			}
			else if (flag)
			{
				audioEvent.Play2D(volumeScale);
			}
			else
			{
				audioEvent.PlayAtPoint(base.transform.position, volumeScale);
			}
		}
	}

	public void TriggerAudioEvent()
	{
		if (Application.isPlaying)
		{
			if ((bool)audioSource)
			{
				audioEvent.PlayOnSource(audioSource, volume);
			}
			else if (play2D)
			{
				audioEvent.Play2D(volume);
			}
			else
			{
				audioEvent.PlayAtPoint(base.transform.position, volume);
			}
		}
	}
}
}
