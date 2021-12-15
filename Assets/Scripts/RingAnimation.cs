using UnityEngine;

public class RingAnimation : MonoBehaviour
{
	public float transitionTime = 0.25f;

	private float transitionStart;

	private Renderer rend;

	private void Start()
	{
		rend = GetComponent<Renderer>();
		rend.material.SetFloat("_Completion", 0.75f);
	}

	private void Update()
	{
		if (Time.time - transitionStart < transitionTime)
		{
			Transition();
		}
		else
		{
			rend.material.SetFloat("_Completion", 1f);
		}
	}

	private void Transition()
	{
		float num = (Time.time - transitionStart) / transitionTime + 0.75f;
		if (num > 1f)
		{
			num = 1f;
		}
		rend.material.SetFloat("_Completion", num);
	}

	private void OnEnable()
	{
		transitionStart = Time.time;
		rend.material.SetFloat("_Completion", 0f);
	}
}
