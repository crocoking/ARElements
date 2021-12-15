using UnityEngine;

namespace GoogleARCore.BestPractices{

public class DestroyOn : StateMachineBehaviour
{
	public enum DestroyEvent
	{
		Enter,
		Exit
	}

	public DestroyEvent destroyEvent;

	public bool immediate;

	public float delay;

	public override void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
	{
		if (destroyEvent == DestroyEvent.Enter)
		{
			DoDestroy(animator.gameObject);
		}
	}

	public override void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
	{
		if (destroyEvent == DestroyEvent.Exit)
		{
			DoDestroy(animator.gameObject);
		}
	}

	private void DoDestroy(Object obj)
	{
		if (immediate)
		{
			Object.DestroyImmediate(obj);
		}
		else
		{
			Object.Destroy(obj, delay);
		}
	}
}
}