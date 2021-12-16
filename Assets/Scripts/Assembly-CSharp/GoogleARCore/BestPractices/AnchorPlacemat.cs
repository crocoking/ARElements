using System.Collections.Generic;
using ARElements;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class AnchorPlacemat : MonoBehaviour
{
	public Animator animator;

	public MeshRenderer frameRenderer;

	public float minScaleFactor = 0.5f;

	public List<Transform> cornerNodes = new List<Transform>();

	public Transform holoScenePivot;

	public RuntimeAnimatorController holoSceneAnimatorController;

	public Button anchorButton;

	public CanvasGroup anchorButtonCanvasGroup;

	public Button anchorTapTarget;

	public BackgroundPressDetection backgroundPressDetection;

	public AudioEvent anchorAudioEvent;

	public float hologramBrightness;

	public UnityEvent onCreateScene = new UnityEvent();

	public bool isPlaced { get; private set; }

	private void OnEnable()
	{
		anchorButtonCanvasGroup.alpha = 0f;
		animator.Play("Begin");
	}

	private void OnDisable()
	{
		if ((bool)HologramRenderer.current)
		{
			HologramRenderer.current.intensity = 0f;
		}
		anchorButtonCanvasGroup.alpha = 0f;
	}

	private void Start()
	{
		anchorButton.onClick.AddListener(OnAnchorClicked);
		anchorTapTarget.onClick.AddListener(OnAnchorClicked);
		backgroundPressDetection.onRelease.AddListener(OnAnchorClicked);
		HologramRenderer.current.intensity = 0f;
	}

	private void LateUpdate()
	{
		HologramRenderer.current.intensity = hologramBrightness;
	}

	private void OnAnchorClicked()
	{
		if (!isPlaced && anchorButton.gameObject.activeSelf)
		{
			if ((object)anchorAudioEvent != null)
			{
				anchorAudioEvent.Play2D();
			}
			animator.SetTrigger("End");
			isPlaced = true;
		}
	}

	private void CreateScene()
	{
		onCreateScene.Invoke();
	}

	public float TestCornerExtents(ITrackedPlane trackedPlane, Vector3 position)
	{
		float num = 1f;
		List<Vector3> boundaryPoints = trackedPlane.boundaryPoints;
		for (int i = 0; i < boundaryPoints.Count; i++)
		{
			Vector3 vector = boundaryPoints[i];
			Vector3 vector2 = boundaryPoints[(i + 1) % boundaryPoints.Count];
			Vector3 normalized = (vector2 - vector).normalized;
			Vector3 lhs = trackedPlane.rotation * Vector3.up;
			Vector3 inNormal = Vector3.Cross(lhs, normalized);
			Plane plane = new Plane(inNormal, vector);
			for (int j = 0; j < cornerNodes.Count; j++)
			{
				Transform transform = cornerNodes[j];
				Vector3 vector3 = transform.position - base.transform.position;
				float magnitude = vector3.magnitude;
				Vector3 normalized2 = vector3.normalized;
				Ray ray = new Ray(position, normalized2);
				if (plane.Raycast(ray, out var enter) && enter < magnitude)
				{
					float num2 = enter / magnitude;
					if (num2 < num)
					{
						num = num2;
					}
				}
			}
		}
		return num;
	}
}
}
