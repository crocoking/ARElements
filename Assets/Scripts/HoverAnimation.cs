using UnityEngine;

public class HoverAnimation : MonoBehaviour
{
	[Tooltip("Rotation speed adjustment.")]
	public float RotationSpeed = -120f;

	[Tooltip("Translation speed adjustment.")]
	public float speed = 10f;

	[HideInInspector]
	public Vector3 originalPosition;

	private Vector3 target;

	private bool bIsTranslating;

	public Vector3 Target
	{
		get
		{
			return target;
		}
		set
		{
			target = value;
			bIsTranslating = true;
		}
	}

	private void Update()
	{
		Translate();
		Spin();
	}

	private void Spin()
	{
		if (!bIsTranslating)
		{
			base.transform.Rotate(base.transform.up, RotationSpeed * Time.deltaTime, Space.World);
		}
	}

	private void Translate()
	{
		if (bIsTranslating)
		{
			float maxDistanceDelta = speed * Time.deltaTime;
			base.transform.position = Vector3.MoveTowards(base.transform.position, Target, maxDistanceDelta);
			if (Vector3.Distance(base.transform.position, Target) < 0.1f)
			{
				base.transform.position = Target;
				bIsTranslating = false;
			}
		}
	}

	private void OnDisable()
	{
		base.transform.localPosition = originalPosition;
		bIsTranslating = false;
	}
}
