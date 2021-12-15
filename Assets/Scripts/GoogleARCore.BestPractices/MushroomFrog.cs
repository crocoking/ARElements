using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;
using KeenTween;
using UnityEngine;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class MushroomFrog : MonoBehaviour
{
	public List<Transform> targetPoints = new List<Transform>();

	public Transform centerTransform;

	public float hopTime = 0.5f;

	public float hopAwayTime = 3f;

	public Animator animator;

	public UnityEvent onHop = new UnityEvent();

	private float nextLookAroundTime;

	private int targetIndex;

	private int desiredTargetIndex;

	private float moveCounter;

	private Coroutine hopCoroutine;

	private Camera mainCamera;

	private Transform currentTarget
	{
		[CompilerGenerated]
		get
		{
			return targetPoints[targetIndex];
		}
	}

	private Transform nextTarget
	{
		[CompilerGenerated]
		get
		{
			return targetPoints[(targetIndex + 1) % targetPoints.Count];
		}
	}

	private Transform nextNextTarget
	{
		[CompilerGenerated]
		get
		{
			return targetPoints[(targetIndex + 2) % targetPoints.Count];
		}
	}

	private void Start()
	{
		mainCamera = Camera.main;
		Vector3 normalized = (nextTarget.position - currentTarget.position).normalized;
		Quaternion rotation = Quaternion.LookRotation(normalized);
		base.transform.rotation = rotation;
		base.transform.position = currentTarget.position;
	}

	private void Update()
	{
		Vector3 lhs = base.transform.position - centerTransform.position;
		lhs.y = 0f;
		lhs.Normalize();
		Vector3 rhs = mainCamera.transform.position - centerTransform.position;
		rhs.y = 0f;
		rhs.Normalize();
		if (Vector3.Dot(lhs, rhs) > 0f)
		{
			moveCounter += Time.deltaTime;
			if (moveCounter > hopAwayTime)
			{
				moveCounter = 0f;
				desiredTargetIndex = GetFurthestTarget(mainCamera.transform.position);
			}
		}
		if (desiredTargetIndex != targetIndex && hopCoroutine == null)
		{
			hopCoroutine = StartCoroutine(HopToNextTarget());
		}
		if (Time.timeSinceLevelLoad >= nextLookAroundTime)
		{
			animator.SetTrigger("LookAround");
			nextLookAroundTime = Time.timeSinceLevelLoad + Random.Range(4f, 10f);
		}
	}

	private int GetFurthestTarget(Vector3 fromPosition)
	{
		int num = -1;
		float num2 = 0f;
		for (int i = 0; i < targetPoints.Count; i++)
		{
			Transform transform = targetPoints[i];
			float num3 = Vector3.Distance(fromPosition, transform.position);
			if (num == -1 || num3 > num2)
			{
				num = i;
				num2 = num3;
			}
		}
		return num;
	}

	private IEnumerator HopToNextTarget()
	{
		Vector3 startDirection = (nextTarget.position - currentTarget.position).normalized;
		Vector3 targetDirection = (nextNextTarget.position - nextTarget.position).normalized;
		Quaternion startRotation = Quaternion.LookRotation(startDirection);
		Quaternion targetRotation = Quaternion.LookRotation(targetDirection);
		Tween tween = new Tween(null, 0f, 1f, hopTime, null, delegate(Tween t)
		{
			base.transform.position = Vector3.Lerp(currentTarget.position, nextTarget.position, t.currentValue);
			base.transform.rotation = Quaternion.Slerp(startRotation, targetRotation, t.currentValue);
		});
		animator.SetTrigger("Hop");
		if (onHop != null)
		{
			onHop.Invoke();
		}
		while (!tween.isDone)
		{
			yield return 0;
		}
		targetIndex = (targetIndex + 1) % targetPoints.Count;
		hopCoroutine = null;
	}

	private void OnDrawGizmos()
	{
		for (int i = 0; i < targetPoints.Count; i++)
		{
			Transform transform = targetPoints[i];
			Transform transform2 = targetPoints[(i + 1) % targetPoints.Count];
			Gizmos.DrawLine(transform.position, transform2.position);
		}
	}
}
}
