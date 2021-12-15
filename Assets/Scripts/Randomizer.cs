using UnityEngine;

public class Randomizer : StateMachineBehaviour
{
	public bool useOnStateMachineEnter;

	public string parameterName = "Index";

	public int indexCount = 1;

	public override void OnStateEnter(Animator animator, AnimatorStateInfo animatorStateInfo, int layerIndex)
	{
		if (!useOnStateMachineEnter)
		{
			Randomize(animator);
		}
	}

	public override void OnStateMachineEnter(Animator animator, int stateMachinePathHash)
	{
		if (useOnStateMachineEnter)
		{
			Randomize(animator);
		}
	}

	private void Randomize(Animator animator)
	{
		animator.SetInteger(parameterName, Random.Range(0, indexCount));
	}
}
