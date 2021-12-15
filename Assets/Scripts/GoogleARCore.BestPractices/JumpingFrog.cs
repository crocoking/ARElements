using System;
using System.Collections;
using System.Runtime.CompilerServices;
using KeenTween;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class JumpingFrog : MonoBehaviour
{
	public Animator animator;

	public AudioSource audioSource;

	private int currentLocatorIndex;

	public AnimationCurve jumpSpeedCurve = AnimationCurve.Linear(0f, 1f, 1f, 1f);

	public float jumpSpeed = 5f;

	public Transform locatorTemplate;

	public AudioEvent jumpAudio;

	public AudioEvent landAudio;

	public AudioEvent showLocatorAudio;

	private Transform nextLocatorParent;

	public bool waitForNextLocator;

	public Transform[] locators { get; } = new Transform[2];


	public Transform currentLocator
	{
		[CompilerGenerated]
		get
		{
			return locators[currentLocatorIndex];
		}
	}

	public Transform otherLocator
	{
		[CompilerGenerated]
		get
		{
			return locators[(currentLocatorIndex + 1) % 2];
		}
	}

	private void Start()
	{
		Transform transform = new GameObject("Anchor").transform;
		transform.transform.localPosition = locatorTemplate.transform.localPosition;
		transform.SetParent(base.transform.parent, worldPositionStays: false);
		Transform transform2 = UnityEngine.Object.Instantiate(locatorTemplate, transform, worldPositionStays: false);
		transform2.transform.localPosition = Vector3.zero;
		transform2.gameObject.SetActive(value: true);
		locators[0] = transform2;
	}

	private void OnEnable()
	{
		StartCoroutine(JumpSequence());
	}

	public void SetNextLocator(Transform nextLocatorParent)
	{
		if ((bool)this.nextLocatorParent)
		{
			UnityEngine.Object.DestroyImmediate(this.nextLocatorParent.gameObject);
		}
		this.nextLocatorParent = nextLocatorParent;
	}

	public Vector3 GetJumpApex()
	{
		if (!currentLocator || !otherLocator)
		{
			throw new Exception("Cannot get jump apex because there are not 2 locators.");
		}
		Vector3 position = currentLocator.position;
		Vector3 position2 = otherLocator.position;
		return GetJumpApex(position, position2);
	}

	public static Vector3 GetJumpApex(Vector3 start, Vector3 end)
	{
		float num = Vector3.Distance(start, end);
		Vector3 result = (start + end) / 2f;
		result.y += num;
		return result;
	}

	private IEnumerator JumpSequence()
	{
		while (true)
		{
			if ((bool)nextLocatorParent)
			{
				Transform locator = UnityEngine.Object.Instantiate(locatorTemplate, nextLocatorParent, worldPositionStays: false);
				locator.transform.localPosition = Vector3.zero;
				locator.gameObject.SetActive(value: true);
				nextLocatorParent = null;
				int num = (currentLocatorIndex + 1) % 2;
				Transform locatorToRemove = locators[num];
				locators[num] = locator;
				locator.transform.localScale = Vector3.zero;
				new Tween(null, 0f, 1f, 0.5f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
				{
					if ((bool)locator)
					{
						locator.transform.localScale = SceneArea.current.transform.localScale * t.currentValue;
					}
				});
				if ((object)showLocatorAudio != null)
				{
					showLocatorAudio.PlayAtPoint(locator.transform.position);
				}
				if (!locatorToRemove)
				{
					break;
				}
				Vector3 startScale = locatorToRemove.transform.localScale;
				new Tween(null, 0f, 1f, 0.5f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
				{
					if ((bool)locatorToRemove)
					{
						locatorToRemove.transform.localScale = Vector3.Lerp(startScale, Vector3.zero, t.currentValue);
					}
				}).onFinish += delegate
				{
					UnityEngine.Object.DestroyImmediate(locatorToRemove.parent.gameObject);
				};
				break;
			}
			if ((bool)otherLocator && !waitForNextLocator)
			{
				break;
			}
			yield return null;
		}
		Vector3 flatDirection = otherLocator.position - currentLocator.position;
		flatDirection.y = 0f;
		flatDirection.Normalize();
		yield return StartCoroutine(PreJumpHop(flatDirection));
		yield return new WaitForSeconds(UnityEngine.Random.Range(0.5f, 1f));
		yield return StartCoroutine(Jump());
		currentLocatorIndex = (currentLocatorIndex + 1) % 2;
		StartCoroutine(JumpSequence());
	}

	private IEnumerator PreJumpHop(Vector3 flatDirection)
	{
		animator.SetTrigger("Hop");
		yield return new WaitForSeconds(0.1f);
		float ratio = 0f;
		Quaternion startRotation = base.transform.rotation;
		Quaternion targetRotation = Quaternion.LookRotation(flatDirection);
		while (true)
		{
			ratio += 5f * Time.deltaTime;
			base.transform.position = currentLocator.position;
			base.transform.rotation = Quaternion.Slerp(startRotation, targetRotation, ratio);
			if (ratio >= 1f)
			{
				break;
			}
			yield return 0;
		}
	}

	private IEnumerator Jump()
	{
		animator.SetTrigger("JumpStart");
		yield return new WaitForSeconds(0.1f);
		if ((object)jumpAudio != null)
		{
			jumpAudio.PlayOnSource(audioSource);
		}
		bool triggeredJumpEndAnimation = false;
		float distance = Vector3.Distance(currentLocator.position, otherLocator.position);
		float jumpTimeScale = 1f / distance;
		float ratio2 = 0f;
		while (true)
		{
			ratio2 += jumpTimeScale * jumpSpeedCurve.Evaluate(ratio2) * jumpSpeed * Time.deltaTime;
			base.transform.position = BezierUtility.Bezier(currentLocator.position, GetJumpApex(), otherLocator.position, ratio2);
			Vector3 flatDirection2 = otherLocator.position - currentLocator.position;
			flatDirection2.y = 0f;
			flatDirection2.Normalize();
			Vector3 lookDirection = flatDirection2;
			if (ratio2 > 1f - jumpTimeScale * 0.5f)
			{
				if (!triggeredJumpEndAnimation)
				{
					animator.SetTrigger("JumpEnd");
					triggeredJumpEndAnimation = true;
				}
			}
			else
			{
				lookDirection = BezierUtility.BezierTangent(currentLocator.position, GetJumpApex(), otherLocator.position, ratio2);
			}
			base.transform.rotation = Quaternion.Slerp(base.transform.rotation, Quaternion.LookRotation(lookDirection), jumpTimeScale * 10f * Time.deltaTime);
			if (ratio2 >= 1f)
			{
				break;
			}
			yield return 0;
		}
		if ((object)landAudio != null)
		{
			landAudio.PlayOnSource(audioSource);
		}
		ratio2 = 0f;
		Quaternion startRotation = base.transform.rotation;
		while (true)
		{
			ratio2 += 5f * Time.deltaTime;
			Vector3 flatDirection = otherLocator.position - currentLocator.position;
			flatDirection.y = 0f;
			flatDirection.Normalize();
			Quaternion targetRotation = Quaternion.LookRotation(flatDirection);
			base.transform.rotation = Quaternion.Slerp(startRotation, targetRotation, ratio2);
			if (ratio2 >= 1f)
			{
				break;
			}
			yield return 0;
		}
	}
}
}
