using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RoadNetworkSpan : RoadNetworkNode
{
	public Transform start;

	public Transform end;

	public Transform midPoint;

	public RoadNetworkNode startNode;

	public RoadNetworkNode endNode;

	public float length
	{
		get
		{
			if (!start || !end)
			{
				return 0f;
			}
			return Vector3.Distance(start.position, end.position);
		}
	}

	public RoadNetworkIntersection intersection
	{
		get
		{
			if (!base.transform.parent)
			{
				return null;
			}
			return base.transform.parent.GetComponent<RoadNetworkIntersection>();
		}
	}

	public Transform GetOther(Transform from)
	{
		if (from != start && from != end)
		{
			return null;
		}
		return (!(from == start)) ? start : end;
	}

	public Transform GetClosest(Vector3 point)
	{
		if (!start || !end)
		{
			return null;
		}
		float num = Vector3.Distance(point, start.position);
		return (!(Vector3.Distance(point, end.position) > num)) ? end : start;
	}

	public Transform GetOverlapping(Vector3 point)
	{
		if (!start || !end)
		{
			return null;
		}
		float num = Vector3.Distance(point, start.position);
		float num2 = Vector3.Distance(point, end.position);
		if (Mathf.Min(num, num2) > 1E-05f)
		{
			return null;
		}
		return (!(num2 > num)) ? end : start;
	}

	public Vector3 GetPosition(float ratio)
	{
		if (!start || !end)
		{
			return Vector3.zero;
		}
		Vector3 b = ((!midPoint) ? ((start.position + end.position) / 2f) : midPoint.position);
		return BezierUtility.Bezier(start.position, b, end.position, ratio);
	}

	public Vector3 GetTangent(float ratio)
	{
		if (!start || !end)
		{
			return Vector3.zero;
		}
		Vector3 b = ((!midPoint) ? ((start.position + end.position) / 2f) : midPoint.position);
		return BezierUtility.BezierTangent(start.position, b, end.position, ratio);
	}

	protected override void OnDrawGizmos()
	{
		if (!start || !end)
		{
			return;
		}
		Gizmos.color = RoadNetworkNode.GetInputColor(base.gameObject);
		if ((bool)midPoint)
		{
			Vector3 from = start.position;
			for (int i = 1; i <= 8; i++)
			{
				float ratio = (float)i / 8f;
				Vector3 vector = BezierUtility.Bezier(start.position, midPoint.position, end.position, ratio);
				Gizmos.DrawLine(from, vector);
				from = vector;
			}
		}
		else
		{
			Gizmos.DrawLine(start.position, end.position);
		}
	}

	private void OnDrawGizmosSelected()
	{
	}
}
}
