using UnityEngine;

namespace GoogleARCore.BestPractices{

public class NavigationInterface : MonoBehaviour
{
	protected virtual void OnEnable()
	{
		SceneTransitionController.RegisterNavigationInterface(this);
	}

	protected virtual void OnDisable()
	{
		SceneTransitionController.UnregisterNavigationInterface(this);
	}

	public virtual void OnVisibilityUpdated(bool previous, bool next, bool menu)
	{
	}
}
}
