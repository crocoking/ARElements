using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class DelayedEventTrigger : MonoBehaviour
{
	[Serializable]
	public class DelayedEvent
	{
		public string name = string.Empty;

		public UnityEvent delayedEvent = new UnityEvent();

		public float delay = 1f;
	}

	public List<DelayedEvent> delayedEvents = new List<DelayedEvent>
	{
		new DelayedEvent()
	};

	public void Trigger(string eventName)
	{
		foreach (DelayedEvent item in delayedEvents.Where((DelayedEvent v) => v.name == eventName))
		{
			StartCoroutine(TriggerDelayedEvent(item));
		}
	}

	private IEnumerator TriggerDelayedEvent(DelayedEvent delayedEvent)
	{
		yield return new WaitForSeconds(delayedEvent.delay);
		delayedEvent.delayedEvent?.Invoke();
	}
}
}
