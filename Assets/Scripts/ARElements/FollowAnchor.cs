using System;
using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class FollowAnchor : MonoBehaviour
{
	[Range(1f, 100f)]
	public float damping = 5f;

	[Range(0f, 1f)]
	public float objectPercentOfFov = 0.25f;

	private Anchor m_Anchor;

	private readonly EasedVector3 m_EasedPosition = new EasedVector3();

	private readonly EasedQuaternion m_EasedRotation = new EasedQuaternion();

	private float m_AlignmentOffset;

	private float m_FovOffset;

	public void BeginMoveTo(Vector3 position, Quaternion rotation)
	{
		UnityEngine.Object.Destroy(m_Anchor);
		m_Anchor = null;
		m_EasedPosition.JumpTo(position + Vector3.up * m_AlignmentOffset + Camera.main.transform.forward * m_FovOffset);
		m_EasedRotation.JumpTo(rotation);
		Bounds bounds = CalculateContentBounds(base.gameObject);
		m_AlignmentOffset = 0f - bounds.center.y;
		m_FovOffset = Mathf.Max(bounds.extents.x, bounds.extents.y) / Mathf.Tan((float)Math.PI / 180f * Camera.main.fieldOfView * objectPercentOfFov);
	}

	public void ContinueMoveTo(Vector3 position, Quaternion rotation)
	{
		m_EasedPosition.FadeTo(position + Vector3.up * m_AlignmentOffset + Camera.main.transform.forward * m_FovOffset, damping / 10f, Time.time);
		m_EasedRotation.FadeTo(rotation, damping / 10f, Time.time);
	}

	public void EndMoveTo(TrackableHit hit, Quaternion rotation)
	{
		SetAnchor(hit.Pose.position, rotation);
		if (m_Anchor != null)
		{
			m_EasedPosition.FadeTo(m_Anchor.transform.position, damping / 10f, Time.time);
			m_EasedRotation.FadeTo(m_Anchor.transform.rotation, damping / 10f, Time.time);
		}
		else
		{
			m_EasedPosition.FadeTo(hit.Pose.position, damping / 10f, Time.time);
			m_EasedRotation.FadeTo(rotation, damping / 10f, Time.time);
		}
	}

	private void Start()
	{
	}

	private void Update()
	{
		if (base.gameObject.activeInHierarchy)
		{
			if (m_Anchor != null)
			{
				m_EasedPosition.FadeTo(m_Anchor.transform.position, damping / 10f, Time.time);
				m_EasedRotation.FadeTo(m_Anchor.transform.rotation, damping / 10f, Time.time);
			}
			base.transform.position = m_EasedPosition.ValueAtTime(Time.time);
			base.transform.rotation = m_EasedRotation.ValueAtTime(Time.time);
		}
	}

	private void SetAnchor(Vector3 position, Quaternion rotation)
	{
		Anchor anchor = Session.CreateAnchor(new Pose(position, rotation));
		if (m_Anchor != null)
		{
			List<Transform> list = new List<Transform>();
			for (int i = 0; i < m_Anchor.transform.childCount; i++)
			{
				list.Add(m_Anchor.transform.GetChild(i));
			}
			foreach (Transform item in list)
			{
				item.SetParent(anchor.transform, worldPositionStays: false);
			}
			UnityEngine.Object.Destroy(m_Anchor);
		}
		m_Anchor = anchor;
	}

	private Bounds CalculateContentBounds(GameObject content)
	{
		Bounds bounds = default(Bounds);
		Quaternion rotation = content.transform.rotation;
		content.transform.rotation = Quaternion.identity;
		Renderer component = content.GetComponent<Renderer>();
		bounds = ((!(component != null)) ? new Bounds(content.transform.position, Vector3.zero) : component.bounds);
		Renderer[] componentsInChildren = GetComponentsInChildren<Renderer>();
		foreach (Renderer renderer in componentsInChildren)
		{
			bounds.Encapsulate(renderer.bounds);
		}
		bounds.center -= content.transform.position;
		content.transform.rotation = rotation;
		return bounds;
	}
}
}
