using UnityEngine;

public class basicRotater : MonoBehaviour
{
	public float speed = 1f;

	public bool X;

	public bool Y = true;

	public bool Z;

	public bool localSpace = true;

	private void Start()
	{
	}

	private void Update()
	{
		Vector3 vector = new Vector3(0f, 0f, 0f);
		if (X)
		{
			vector = new Vector3(1f, vector.y, vector.z);
		}
		if (Y)
		{
			vector = new Vector3(vector.x, 1f, vector.z);
		}
		if (Z)
		{
			vector = new Vector3(vector.x, vector.y, 1f);
		}
		float num = Time.deltaTime * speed;
		if (localSpace)
		{
			base.transform.Rotate(new Vector3(num * vector.x, 0f, 0f), Space.Self);
			base.transform.Rotate(new Vector3(0f, num * vector.y, 0f), Space.Self);
			base.transform.Rotate(new Vector3(0f, 0f, num * vector.z), Space.Self);
		}
		else
		{
			base.transform.Rotate(new Vector3(num * vector.x, 0f, 0f), Space.World);
			base.transform.Rotate(new Vector3(0f, num * vector.y, 0f), Space.World);
			base.transform.Rotate(new Vector3(0f, 0f, num * vector.z), Space.World);
		}
	}
}
