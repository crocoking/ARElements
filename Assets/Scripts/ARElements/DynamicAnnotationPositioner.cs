using UnityEngine;

namespace ARElements{

[ExecuteInEditMode]
public class DynamicAnnotationPositioner : BaseAnnotationPositioner
{
	public enum RotationMode
	{
		None,
		InPlace,
		AroundObject
	}

	[Tooltip("Rotation mode defines how the annotation will behave when the main camera moves around the card.")]
	public RotationMode rotationMode;

	[Range(0f, 180f)]
	[Tooltip("Number of degrees used for increment snapping on y-axis rotation.")]
	public float rotationIncrementInDegrees = 45f;

	[Tooltip("Enables tilting which applies local x-axis rotation to face towards the viewer.")]
	public bool allowTilting = true;

	[Range(0f, 100f)]
	[Tooltip("Number of degrees used for increment snapping on x-axis rotation.")]
	public float tiltIncrementInDegrees = 45f;

	private Vector3 m_SnappedLocalPosition;

	private Vector3 m_SnappedWorldDirection;

	private bool m_isFirstPass = true;

	public override void UpdateAnnotationPosition(Transform viewer, Transform spawnTransform, Transform annotatedObject)
	{
		if (rotationMode == RotationMode.None)
		{
			HandleFixedMode(viewer, spawnTransform, annotatedObject);
		}
		else if (rotationMode == RotationMode.InPlace)
		{
			HandleYAxisInPlaceRotation(viewer, spawnTransform, annotatedObject);
		}
		else if (rotationMode == RotationMode.AroundObject)
		{
			HandleYAxisAroundObjectRotation(viewer, spawnTransform, annotatedObject);
		}
		else
		{
			Debug.LogError("Unknown rotation mode set: " + rotationMode);
		}
	}

	private void HandleFixedMode(Transform viewer, Transform spawnTransform, Transform annotatedObject)
	{
		if (!(spawnTransform == null))
		{
			base.transform.position = spawnTransform.position;
			base.transform.rotation = spawnTransform.rotation;
		}
	}

	private void HandleYAxisInPlaceRotation(Transform viewer, Transform spawnTransform, Transform annotatedObject)
	{
		if (!(viewer == null) && !(spawnTransform == null) && !(annotatedObject == null))
		{
			if (m_isFirstPass)
			{
				m_SnappedWorldDirection = base.transform.forward;
				m_isFirstPass = false;
			}
			base.transform.rotation = Quaternion.identity;
			base.transform.position = spawnTransform.position;
			Vector3 vector = new Vector3(viewer.position.x, base.transform.position.y, viewer.position.z);
			Vector3 normalized = (vector - base.transform.position).normalized;
			Vector3 vector2 = m_SnappedWorldDirection;
			float num = Vector3.Angle(normalized, m_SnappedWorldDirection);
			if (num > rotationIncrementInDegrees)
			{
				vector2 = normalized;
			}
			base.transform.forward = vector2;
			m_SnappedWorldDirection = vector2;
			HandleTilting(viewer);
		}
	}

	private void HandleYAxisAroundObjectRotation(Transform viewer, Transform spawnTransform, Transform annotatedObject)
	{
		Vector3 vector = annotatedObject.InverseTransformPoint(spawnTransform.position);
		vector.y = 0f;
		if (vector.magnitude > 0f)
		{
			HandleOffsetRotation(viewer, vector.magnitude, spawnTransform, annotatedObject);
		}
		else
		{
			HandleYAxisInPlaceRotation(viewer, spawnTransform, annotatedObject);
		}
	}

	private void HandleOffsetRotation(Transform viewer, float radius, Transform spawnTransform, Transform annotatedObject)
	{
		if (!(viewer == null) && !(annotatedObject == null))
		{
			Vector3 vector = m_SnappedLocalPosition;
			if (m_isFirstPass)
			{
				vector = new Vector3(0f, spawnTransform.localPosition.y, radius);
				m_isFirstPass = false;
			}
			vector.y = spawnTransform.localPosition.y;
			Vector3 vector2 = annotatedObject.TransformPoint(vector);
			Vector3 position = viewer.position;
			Vector3 position2 = annotatedObject.position;
			vector2.y = spawnTransform.position.y;
			position.y = spawnTransform.position.y;
			position2.y = spawnTransform.position.y;
			Vector3 vector3 = vector2 - position2;
			Vector3 to = position - position2;
			Vector3 forward = vector3;
			float num = Vector3.Angle(vector3, to);
			if (num >= rotationIncrementInDegrees)
			{
				Vector3 vector4 = position2 + to.normalized * radius;
				vector = annotatedObject.InverseTransformPoint(vector4);
				forward = vector4 - position2;
			}
			base.transform.position = annotatedObject.TransformPoint(vector);
			base.transform.rotation = Quaternion.identity;
			base.transform.forward = forward;
			m_SnappedLocalPosition = vector;
			HandleTilting(viewer);
		}
	}

	private void HandleTilting(Transform viewer)
	{
		if (allowTilting)
		{
			Vector3 normalized = (viewer.position - base.transform.position).normalized;
			Vector3 vector = base.transform.InverseTransformDirection(normalized);
			float num = Mathf.Atan2(vector.y, vector.z) * 57.29578f * -1f;
			float x = num;
			if (tiltIncrementInDegrees > 0f)
			{
				int num2 = (int)(num / tiltIncrementInDegrees);
				x = (float)num2 * tiltIncrementInDegrees;
			}
			base.transform.localRotation *= Quaternion.Euler(x, 0f, 0f);
		}
	}
}
}
