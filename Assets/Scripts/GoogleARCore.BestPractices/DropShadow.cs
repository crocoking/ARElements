using UnityEngine;

namespace GoogleARCore.BestPractices{

public class DropShadow : MonoBehaviour
{
	public Transform anchorTransform;

	public LayerMask raycastLayerMask = -1;

	public bool useRaycast = true;

	public Vector3 forwardVector = Vector3.forward;

	public float startDistance;

	public float maxDist = 1f;

	public Vector3 scaleAtMaxDist = Vector3.one;

	public Color nearColor = Color.white;

	public Color farColor = new Color(1f, 1f, 1f, 0f);

	private Renderer[] shadowRenderers;

	private MaterialPropertyBlock materialPropertyBlock;

	private void Start()
	{
		shadowRenderers = base.gameObject.GetComponentsInChildren<Renderer>();
		materialPropertyBlock = new MaterialPropertyBlock();
	}

	private void LateUpdate()
	{
		if (useRaycast)
		{
			Ray ray = new Ray(anchorTransform.position, Vector3.down);
			float a = 0f;
			Vector3 vector = Vector3.zero;
			bool flag = false;
			if (Physics.Raycast(ray, out var hitInfo, float.PositiveInfinity, raycastLayerMask))
			{
				flag = true;
				a = hitInfo.distance;
				vector = hitInfo.normal;
			}
			if (flag)
			{
				a = Mathf.Max(a, startDistance);
				Vector3 position = ray.origin + ray.direction * a;
				float t = (a - startDistance) / maxDist;
				Vector3 localScale = Vector3.Lerp(Vector3.one, scaleAtMaxDist, t);
				base.transform.position = anchorTransform.position;
				base.transform.rotation = anchorTransform.rotation;
				Vector3 vector2 = base.transform.rotation * forwardVector;
				Vector3 forward = Vector3.ProjectOnPlane(vector2, vector);
				base.transform.rotation = Quaternion.LookRotation(forward, vector);
				base.transform.position = position;
				base.transform.localScale = localScale;
				Color value = Color.Lerp(nearColor, farColor, t);
				Renderer[] array = shadowRenderers;
				foreach (Renderer renderer in array)
				{
					renderer.GetPropertyBlock(materialPropertyBlock);
					materialPropertyBlock.SetColor("_Color", value);
					renderer.SetPropertyBlock(materialPropertyBlock);
					if (!renderer.enabled)
					{
						renderer.enabled = true;
					}
				}
				return;
			}
			Renderer[] array2 = shadowRenderers;
			foreach (Renderer renderer2 in array2)
			{
				if (renderer2.enabled)
				{
					renderer2.enabled = false;
				}
			}
			return;
		}
		Vector3 position2 = anchorTransform.position;
		float num = 0f;
		if ((bool)base.transform.parent)
		{
			num = base.transform.parent.position.y;
		}
		float num2 = (position2.y - startDistance - num) / maxDist;
		Vector3 localScale2 = Vector3.Lerp(Vector3.one, scaleAtMaxDist, num2);
		base.transform.position = anchorTransform.position;
		base.transform.rotation = anchorTransform.rotation;
		Vector3 vector3 = base.transform.rotation * forwardVector;
		Vector3 vector4 = Vector3.ProjectOnPlane(vector3, Vector3.up);
		Vector3 vector5 = vector4;
		if ((bool)base.transform.parent)
		{
			vector5 = base.transform.parent.InverseTransformDirection(vector5);
		}
		base.transform.localRotation = Quaternion.LookRotation(vector5, Vector3.up);
		Vector3 localPosition = base.transform.localPosition;
		localPosition.y = 0f;
		base.transform.localPosition = localPosition;
		base.transform.localScale = localScale2;
		Color value2 = Color.Lerp(nearColor, farColor, num2);
		Renderer[] array3 = shadowRenderers;
		foreach (Renderer renderer3 in array3)
		{
			if (num2 > 1f && renderer3.enabled)
			{
				renderer3.enabled = false;
			}
			renderer3.GetPropertyBlock(materialPropertyBlock);
			materialPropertyBlock.SetColor("_Color", value2);
			renderer3.SetPropertyBlock(materialPropertyBlock);
			if (!renderer3.enabled)
			{
				renderer3.enabled = true;
			}
		}
	}

	private void OnDrawGizmosSelected()
	{
		if ((bool)anchorTransform)
		{
			Vector3 to = anchorTransform.position + Vector3.down * startDistance;
			Gizmos.DrawLine(anchorTransform.position, to);
		}
	}
}
}
