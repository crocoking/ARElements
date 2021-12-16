using UnityEngine;
using UnityEngine.EventSystems;

namespace GoogleARCore.BestPractices{

public class DinoController : MonoBehaviour, IPointerClickHandler, IEventSystemHandler
{
	public HeadLookController headLookController;

	public Animator animator;

	public string lookatWeightCurveName = "LookWeightCurve";

	public float minLookWeightRandomTime = 2.5f;

	public float maxLookWeightRandomTime = 3.5f;

	public float lookWeghtAdaptRate = 3f;

	public string tapTriggerString = "Tap";

	public float tapTriggerRate = 1f;

	private float lastTapTrigger = float.NegativeInfinity;

	private float nextLookWeightRandomChange;

	private float targetLookWeightRandomValue;

	private float lookWeightRandomValue;

	public float minLookOffsetChangeTime = 0.5f;

	public float maxLookOffsetChangeTime = 3f;

	public float lookOffsetAdaptRate = 3f;

	public float minLookOffsetRadius;

	public float maxLookOffsetRadius = 1f;

	private float nextLookoffsetChange;

	private Vector3 lookOffset;

	private Vector3 targetLookOffset;

	private void Update()
	{
		UpdateRandomLookWeight();
		UpdateLookOffset();
		if ((bool)headLookController && (bool)animator)
		{
			float @float = animator.GetFloat(lookatWeightCurveName);
			@float *= lookWeightRandomValue;
			headLookController.weight = @float;
			headLookController.worldLookOffset = lookOffset;
		}
	}

	private void UpdateRandomLookWeight()
	{
		if (Time.timeSinceLevelLoad >= nextLookWeightRandomChange)
		{
			targetLookWeightRandomValue = ((Random.value >= 0.5f) ? 1 : 0);
			if (targetLookWeightRandomValue <= 0f)
			{
				targetLookWeightRandomValue = ((!(Random.value >= 0.5f)) ? 0f : Random.Range(0.25f, 0.75f));
			}
			nextLookWeightRandomChange = Time.timeSinceLevelLoad + Random.Range(minLookWeightRandomTime, maxLookWeightRandomTime);
		}
		lookWeightRandomValue = Mathf.Lerp(lookWeightRandomValue, targetLookWeightRandomValue, lookWeghtAdaptRate * Time.deltaTime);
	}

	private void UpdateLookOffset()
	{
		if (Time.timeSinceLevelLoad >= nextLookoffsetChange)
		{
			targetLookOffset = Vector3.zero;
			if (Random.value >= 0.5f)
			{
				targetLookOffset = Random.onUnitSphere * Random.Range(minLookOffsetRadius, maxLookOffsetRadius);
			}
			nextLookoffsetChange = Time.timeSinceLevelLoad + Random.Range(minLookOffsetChangeTime, maxLookOffsetChangeTime);
		}
		lookOffset = Vector3.Lerp(lookOffset, targetLookOffset, lookOffsetAdaptRate * Time.deltaTime);
	}

	public void OnPointerClick(PointerEventData eventData)
	{
		if (Time.timeSinceLevelLoad - lastTapTrigger >= tapTriggerRate)
		{
			animator.SetTrigger("Tap");
			lastTapTrigger = Time.timeSinceLevelLoad;
		}
	}
}
}
