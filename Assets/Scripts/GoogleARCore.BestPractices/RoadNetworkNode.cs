using UnityEngine;

namespace GoogleARCore.BestPractices{

public class RoadNetworkNode : MonoBehaviour
{
	private static Color inputColor = new Color(0.5f, 0.65f, 1f, 1f);

	private static Color outputColor = new Color(1f, 0.65f, 0.5f, 1f);

	protected static Color GetInputColor(GameObject forGameObject)
	{
		return inputColor;
	}

	protected static Color GetOutputColor(GameObject forGameObject)
	{
		return outputColor;
	}

	protected virtual void OnDrawGizmos()
	{
	}
}
}
