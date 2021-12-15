using UnityEngine;

namespace GoogleARCore.BestPractices{

public class SceneDescription : MonoBehaviour
{
	public GameObject pedestalContent;

	[TextArea]
	public string shortInstructionText;

	[TextArea(3, int.MaxValue)]
	public string instructionText;

	public float islandAmbientOverrideVolume = -1f;

	public bool showGroundPlane;

	public bool autoGazeFocusPoint = true;

	public bool useShadows = true;

	public bool showNavButtons = true;

	public float infoCardMaxExpandPositionOverride = -1f;
}
}
