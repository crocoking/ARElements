using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CityCar : MonoBehaviour
{
	public RoadNetworkSpan currentSpan;

	public float speed = 0.1f;

	public int direction = 1;

	public float position;

	public float yieldDistance = 0.5f;

	public Transform policeLights;

	public Transform headlights;

	private float currentSpeed;

	private CityController cityController;

	private List<RoadNetworkSpan> possibleSpansCache = new List<RoadNetworkSpan>();

	private Transform startPoint => (direction <= 0) ? currentSpan.end : currentSpan.start;

	private Transform endPoint => (direction <= 0) ? currentSpan.start : currentSpan.end;

	private void Start()
	{
		currentSpeed = speed;
		cityController = base.gameObject.GetComponentInParent<CityController>();
		cityController.onDayNightChange += OnDayNightChange;
		if ((bool)headlights)
		{
			headlights.gameObject.SetActive(!cityController.isDay);
		}
	}

	private void OnDayNightChange(bool isDay)
	{
		if ((bool)headlights)
		{
			headlights.gameObject.SetActive(!isDay);
		}
	}

	private void Update()
	{
		float num = 0f;
		foreach (CityCar car in cityController.cars)
		{
			if (!(car == this))
			{
				Vector3 vector = car.transform.position - base.transform.position;
				float magnitude = vector.magnitude;
				if (!(magnitude >= yieldDistance))
				{
					Vector3 normalized = vector.normalized;
					float num2 = 1f - magnitude / yieldDistance;
					num2 *= Mathf.Clamp01(Vector3.Dot(normalized, base.transform.forward));
					num2 *= Mathf.Clamp01(Vector3.Dot(base.transform.forward, car.transform.forward));
					num = Mathf.Max(num, num2);
				}
			}
		}
		float b = speed * (1f - num);
		currentSpeed = Mathf.Lerp(currentSpeed, b, 1f * Time.deltaTime);
		float length = currentSpan.length;
		position += currentSpeed / length * (float)direction * Time.deltaTime;
		UpdatePosition();
		if ((bool)policeLights)
		{
			policeLights.Rotate(0f, 0f, 360f * Time.deltaTime);
		}
		RoadNetworkNode roadNetworkNode = null;
		if (direction > 0)
		{
			if (position > 1f)
			{
				roadNetworkNode = currentSpan.endNode;
				if (!roadNetworkNode)
				{
					Debug.LogError("Span has no endNode link.", currentSpan);
					Object.DestroyImmediate(base.gameObject);
					return;
				}
			}
		}
		else if (position < 0f)
		{
			roadNetworkNode = currentSpan.startNode;
			if (!roadNetworkNode)
			{
				Debug.LogError("Span has no startNode link.", currentSpan);
				Object.DestroyImmediate(base.gameObject);
				return;
			}
		}
		if (!roadNetworkNode)
		{
			return;
		}
		RoadNetworkIntersection roadNetworkIntersection = roadNetworkNode as RoadNetworkIntersection;
		RoadNetworkSpan roadNetworkSpan = roadNetworkNode as RoadNetworkSpan;
		if ((bool)roadNetworkIntersection)
		{
			possibleSpansCache.Clear();
			foreach (RoadNetworkSpan span in roadNetworkIntersection.spans)
			{
				if (span.startNode == currentSpan || span.endNode == currentSpan)
				{
					possibleSpansCache.Add(span);
				}
			}
			if (possibleSpansCache.Count > 0)
			{
				roadNetworkSpan = possibleSpansCache[Random.Range(0, possibleSpansCache.Count)];
			}
		}
		if ((bool)roadNetworkSpan)
		{
			Transform closest = roadNetworkSpan.GetClosest(endPoint.position);
			direction = ((closest == roadNetworkSpan.start) ? 1 : (-1));
			position = ((direction <= 0) ? 1 : 0);
			currentSpan = roadNetworkSpan;
		}
		else
		{
			Debug.LogError("Unsupported node transition.", roadNetworkNode);
			Object.DestroyImmediate(base.gameObject);
		}
	}

	public void UpdatePosition()
	{
		base.transform.position = currentSpan.GetPosition(position);
		base.transform.rotation = Quaternion.LookRotation(currentSpan.GetTangent(position) * ((direction > 0) ? 1 : (-1)));
	}
}
}
