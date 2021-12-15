using System.Collections;
using System.Linq;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RobotController : MonoBehaviour
{
	public Animator animator;

	public AudioSource audioSource;

	public float maxVolume = 1f;

	private Coroutine punchCoroutine;

	private float nextPunchTime;

	private Coroutine headSpinCoroutine;

	private float nextHeadSpinTime;

	private Coroutine adjustFeetCoroutine;

	private float nextAdjustFeetTime;

	private void OnEnable()
	{
		nextPunchTime = Time.timeSinceLevelLoad + Random.Range(1f, 3f);
		nextHeadSpinTime = Time.timeSinceLevelLoad + Random.Range(5f, 10f);
		nextAdjustFeetTime = Time.timeSinceLevelLoad + Random.Range(5f, 10f);
	}

	private void OnDisable()
	{
		punchCoroutine = null;
		headSpinCoroutine = null;
		adjustFeetCoroutine = null;
	}

	private void Update()
	{
		if (punchCoroutine == null && Time.timeSinceLevelLoad >= nextPunchTime)
		{
			punchCoroutine = StartCoroutine(Punch());
		}
		if (headSpinCoroutine == null && Time.timeSinceLevelLoad >= nextHeadSpinTime)
		{
			headSpinCoroutine = StartCoroutine(HeadSpin());
		}
		if (adjustFeetCoroutine == null && Time.timeSinceLevelLoad >= nextAdjustFeetTime)
		{
			adjustFeetCoroutine = StartCoroutine(AdjustFeet());
		}
		if ((bool)audioSource)
		{
			float num = 0f;
			float num2 = maxVolume / 3f;
			if (punchCoroutine != null)
			{
				num += num2;
			}
			if (headSpinCoroutine != null)
			{
				num += num2;
			}
			if (adjustFeetCoroutine != null)
			{
				num += num2;
			}
			audioSource.volume = Mathf.Lerp(audioSource.volume, num, 5f * Time.deltaTime);
		}
	}

	private IEnumerator Punch()
	{
		animator.SetBool("Punch", value: true);
		float waitTime = Random.Range(2f, 4f);
		if ((double)Random.value > 0.8)
		{
			waitTime = Random.Range(5f, 10f);
		}
		yield return new WaitForSeconds(waitTime);
		animator.SetBool("Punch", value: false);
		nextPunchTime = Time.timeSinceLevelLoad + Random.Range(2f, 4f);
		punchCoroutine = null;
	}

	private IEnumerator HeadSpin()
	{
		animator.SetTrigger("HeadSpin");
		float length = animator.runtimeAnimatorController.animationClips.First((AnimationClip v) => v.name == "HeadSpin").length;
		yield return new WaitForSeconds(length);
		nextHeadSpinTime = Time.timeSinceLevelLoad + Random.Range(5f, 10f);
		if ((double)Random.value >= 0.8)
		{
			nextHeadSpinTime = Time.timeSinceLevelLoad;
		}
		headSpinCoroutine = null;
	}

	private IEnumerator AdjustFeet()
	{
		animator.SetTrigger("AdjustFeet");
		float length = animator.runtimeAnimatorController.animationClips.First((AnimationClip v) => v.name == "AdjustFeet").length;
		yield return new WaitForSeconds(length);
		nextAdjustFeetTime = Time.timeSinceLevelLoad + Random.Range(5f, 10f);
		if ((double)Random.value >= 0.5)
		{
			nextAdjustFeetTime = Time.timeSinceLevelLoad;
		}
		adjustFeetCoroutine = null;
	}
}
}
