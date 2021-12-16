using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class OnDestroyEvent : MonoBehaviour
{
	public UnityEvent onDestroy = new UnityEvent();

	private void OnDestroy()
	{
		onDestroy.Invoke();
	}
}
}
