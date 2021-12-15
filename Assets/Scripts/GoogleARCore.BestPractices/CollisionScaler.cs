using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CollisionScaler : MonoBehaviour
{
	public SphereCollider sphereCollider;

	public float minRadius = 0.05f;

	private float startRadius;

	private void Start()
	{
		startRadius = sphereCollider.radius;
	}

	private void Update()
	{
		CalculateScaledRadius(out var _, out var scaledRadius);
		if (sphereCollider.radius != scaledRadius)
		{
			sphereCollider.radius = scaledRadius;
		}
	}

	private float CalculateHeightAspect()
	{
		float num = Mathf.Max(Screen.width, Screen.height);
		return (float)Screen.height / num;
	}

	public void CalculateScaledRadius(out float viewRadius, out float scaledRadius)
	{
		float num = CalculateHeightAspect();
		Camera main = Camera.main;
		Vector3 position = main.transform.position;
		float z = main.transform.InverseTransformPoint(base.transform.position).z;
		Vector3 vector = position + main.transform.forward * z;
		Vector3 position2 = vector + main.transform.up * startRadius;
		Vector3 vector2 = main.WorldToViewportPoint(position2);
		viewRadius = Vector2.Distance(vector2, new Vector2(0.5f, 0.5f)) * num;
		scaledRadius = startRadius;
		if (!(z < startRadius) && viewRadius < minRadius)
		{
			Vector3 a = main.ViewportToWorldPoint(new Vector3(0.5f, 0.5f + minRadius / num, z));
			scaledRadius = Vector3.Distance(a, vector);
			viewRadius = minRadius;
		}
	}
}
}
