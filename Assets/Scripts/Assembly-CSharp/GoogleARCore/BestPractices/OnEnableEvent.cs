using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class OnEnableEvent : MonoBehaviour
{
	public UnityEvent onEnable = new UnityEvent();

	private void OnEnable()
	{
		onEnable.Invoke();
	}
}
}
