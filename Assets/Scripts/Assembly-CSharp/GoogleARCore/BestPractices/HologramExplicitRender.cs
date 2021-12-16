using UnityEngine;

namespace GoogleARCore.BestPractices{

public class HologramExplicitRender : MonoBehaviour
{
	public enum State
	{
		Enabled,
		Disabled
	}

	public State state;
}
}
