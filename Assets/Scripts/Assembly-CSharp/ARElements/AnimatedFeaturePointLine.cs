using System.Collections.Generic;
using UnityEngine;

namespace ARElements
{

	public class AnimatedFeaturePointLine
	{
		private float m_Length;

		private float m_Speed;

		private List<Vector3> m_FeaturePoints;

		private LinkedList<Vector3> m_UnvistedPoints;

		private LinkedList<Vector3> m_Points;

		private Vector3 m_Start;

		private Vector3 m_End;

		private Camera m_ARCoreCamera;

		public AnimatedFeaturePointLine(float length, float speed, List<Vector3> featurePoints, LinkedList<Vector3> unvisited, Camera camera)
		{
			m_Length = length;
			m_Speed = speed;
			m_FeaturePoints = featurePoints;
			m_UnvistedPoints = unvisited;
			m_ARCoreCamera = camera;
			m_Start = m_FeaturePoints[Random.Range(0, m_FeaturePoints.Count - 1)];
			m_End = m_Start;
			m_Points = new LinkedList<Vector3>();
			m_Points.AddLast(m_FeaturePoints[Random.Range(0, m_FeaturePoints.Count - 1)]);
		}

		public void SetLength(float length)
		{
			m_Length = length;
		}

		public void SetSpeed(float speed)
		{
			m_Speed = speed;
		}

		public void UpdateLine()
		{
			if (CalculateLength() < m_Length)
			{
				MoveEnd(m_Speed * Time.deltaTime);
			}
			if (CalculateLength() >= m_Length)
			{
				MoveStart(m_Speed * Time.deltaTime);
			}
		}

		private float CalculateLength()
		{
			float num = 0f;
			List<Vector3> points = GetPoints();
			for (int i = 0; i < points.Count - 1; i++)
			{
				num += Vector3.Distance(points[i], points[i + 1]);
			}
			return num;
		}

		private void MoveStart(float step)
		{
			float num = Vector3.Distance(m_Start, m_Points.First.Value);
			if (num > step)
			{
				m_Start = Vector3.MoveTowards(m_Start, m_Points.First.Value, step);
				return;
			}
			m_Start = m_Points.First.Value;
			m_Points.RemoveFirst();
			if (m_Points.Count > 0)
			{
				MoveStart(step - num);
			}
		}

		private void MoveEnd(float step)
		{
			float num = Vector3.Distance(m_End, m_Points.Last.Value);
			if (num > step)
			{
				m_End = Vector3.MoveTowards(m_End, m_Points.Last.Value, step);
				return;
			}
			m_End = m_Points.Last.Value;
			while (m_UnvistedPoints.Count > 0)
			{
				Vector3 value = m_UnvistedPoints.First.Value;
				m_UnvistedPoints.RemoveFirst();
				if (IsPointInCameraViewPort(value))
				{
					m_Points.AddLast(value);
					MoveEnd(step - num);
					break;
				}
			}
			if (m_End == m_Points.Last.Value)
			{
				int num2 = FindRandomPointIndexInView(0, m_FeaturePoints.Count - 1);
				if (num2 > 0 && m_Points.Last.Value != m_FeaturePoints[num2])
				{
					m_Points.AddLast(m_FeaturePoints[num2]);
					MoveEnd(step - num);
				}
			}
		}

		private int FindRandomPointIndexInView(int start, int end)
		{
			if (start >= end)
			{
				return (!IsPointInCameraViewPort(m_FeaturePoints[start])) ? (-1) : start;
			}
			int num = Random.Range(start, end);
			if (IsPointInCameraViewPort(m_FeaturePoints[num]))
			{
				return num;
			}
			int num2 = num;
			num = FindRandomPointIndexInView(start, num - 1);
			if (num > 0)
			{
				return num;
			}
			return FindRandomPointIndexInView(num2 + 1, end);
		}

		private bool IsPointInCameraViewPort(Vector3 point)
		{
			point = m_ARCoreCamera.WorldToViewportPoint(point);
			if (point.z <= 0f)
			{
				return false;
			}
			if (point.x > 1f || point.x < 0f)
			{
				return false;
			}
			if (point.y > 1f || point.y < 0f)
			{
				return false;
			}
			return true;
		}

		public List<Vector3> GetPoints()
		{
			List<Vector3> list = new List<Vector3>();
			list.Add(m_Start);
			for (LinkedListNode<Vector3> linkedListNode = m_Points.First; linkedListNode != m_Points.Last; linkedListNode = linkedListNode.Next)
			{
				list.Add(linkedListNode.Value);
			}
			list.Add(m_End);
			return list;
		}
	}
}
