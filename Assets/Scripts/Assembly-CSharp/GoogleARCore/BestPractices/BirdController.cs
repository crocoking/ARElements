using System.Collections;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class BirdController : MonoBehaviour
{
	public Bird bird;

	public float circleDistance = 2f;

	public Transform anchorLocation;

	public float targetChangeTime = 5f;

	private Camera mainCamera;

	private Transform currentTarget;

	private float timeOnScreenCounter;

	private float targetChangedCounter;

	private void Start()
	{
		mainCamera = Camera.main;
		CreateTarget(anchorLocation.position);
		bird.target = currentTarget;
		StartCoroutine(AlternateDirection());
	}

	private void Update()
	{
		if (!anchorLocation)
		{
			if (targetChangedCounter > targetChangeTime)
			{
				Vector3 normalized = (bird.transform.position - mainCamera.transform.position).normalized;
				if (Vector3.Dot(normalized, mainCamera.transform.forward) > 0f)
				{
					Vector3 vector = mainCamera.WorldToViewportPoint(bird.transform.position);
					if (vector.x > 0f && vector.x < 1f && vector.y > 0f && vector.y < 1f)
					{
						timeOnScreenCounter += Time.deltaTime;
					}
				}
			}
			targetChangedCounter += Time.deltaTime;
			if (timeOnScreenCounter > 5f)
			{
				Vector3 vector2 = Quaternion.Euler(0f, Random.Range(25f, 120f), 0f) * mainCamera.transform.forward;
				vector2.y = 0f;
				vector2.Normalize();
				vector2 *= circleDistance;
				CreateTarget(mainCamera.transform.position + vector2);
				bird.target = currentTarget;
				timeOnScreenCounter = 0f;
				targetChangedCounter = 0f;
			}
		}
		else if ((bool)currentTarget)
		{
			currentTarget.position = anchorLocation.position;
		}
	}

	private IEnumerator AlternateDirection()
	{
		while (true)
		{
			yield return new WaitForSeconds(Random.Range(4f, 8f));
			bird.circleRadius = 0f - bird.circleRadius;
		}
	}

	private void CreateTarget(Vector3 position)
	{
		if ((bool)currentTarget)
		{
			Object.DestroyImmediate(currentTarget.gameObject);
		}
		if ((bool)anchorLocation || Application.isEditor)
		{
			currentTarget = new GameObject("Target").transform;
			currentTarget.position = position;
		}
		else
		{
			currentTarget = Session.CreateAnchor(new Pose(position, Quaternion.identity)).transform;
		}
	}
}
}
