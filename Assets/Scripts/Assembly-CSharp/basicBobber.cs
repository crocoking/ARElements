using UnityEngine;

public class basicBobber : MonoBehaviour
{
	public float maxMovement = 1f;

	public float speed = 1f;

	public float offsetTime;

	public Vector3 bobbAxis = new Vector3(0f, 1f, 0f);

	private Vector3 startingPos;

	private void Start()
	{
		startingPos = base.transform.localPosition;
	}

	private void Update()
	{
		float num = Mathf.Sin(Time.timeSinceLevelLoad + offsetTime) * speed;
		base.transform.localPosition = new Vector3(startingPos.x + num * bobbAxis.x * maxMovement, startingPos.y + num * bobbAxis.y * maxMovement, startingPos.z + num * bobbAxis.z * maxMovement);
	}
}
