using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class TennisBallTouchManager : MonoBehaviour
{
	[Serializable]
	public class BallInfo
	{
		public GameObject gameObject;

		public Transform start;

		public Transform end;

		public float speed;

		public float radius;

		public GameObject tapEffect;

		public AudioSource ambientAudioSource;

		public AudioLowPassFilter lowPassFilter;

		public float minLPF;

		public float maxLPF;

		public float minPitch;

		public float maxPitch;

		public float minVolume;

		public float maxVolume;

		[NonSerialized]
		public bool isPaused;

		private float time;

		private Vector3 angularVelocity;

		public void Update()
		{
			if (!gameObject || !start || !end)
			{
				return;
			}
			Vector3 b = Vector3.zero;
			if (!isPaused)
			{
				Vector3 position = gameObject.transform.position;
				float t = Mathf.PingPong(time, 1f);
				t = Mathf.SmoothStep(0f, 1f, t);
				gameObject.transform.position = Vector3.Lerp(start.position, end.position, t);
				time += speed * Time.deltaTime;
				Vector3 vector = (gameObject.transform.position - position) / Time.deltaTime;
				Vector3 normalized = vector.normalized;
				float magnitude = vector.magnitude;
				if (magnitude > 0f)
				{
					Vector3 vector2 = Vector3.Cross(Vector3.up, normalized);
					float num = (float)Math.PI * radius;
					b = vector2 * (magnitude / num * 2f * 2f * 2f);
				}
				if ((bool)lowPassFilter)
				{
					float b2 = Mathf.LerpUnclamped(minLPF, maxLPF, magnitude / speed);
					lowPassFilter.cutoffFrequency = Mathf.Lerp(lowPassFilter.cutoffFrequency, b2, 5f * Time.deltaTime);
				}
				float b3 = Mathf.LerpUnclamped(minPitch, maxPitch, magnitude / speed);
				ambientAudioSource.pitch = Mathf.Lerp(ambientAudioSource.pitch, b3, 5f * Time.deltaTime);
				float b4 = Mathf.LerpUnclamped(minVolume, maxVolume, magnitude / speed);
				ambientAudioSource.volume = Mathf.Lerp(ambientAudioSource.volume, b4, 5f * Time.deltaTime);
			}
			angularVelocity = Vector3.Lerp(angularVelocity, b, 20f * Time.deltaTime);
			gameObject.transform.rotation = Quaternion.Euler(angularVelocity * 57.29578f * Time.deltaTime) * gameObject.transform.rotation;
		}
	}

	public List<BallInfo> ballInfos = new List<BallInfo>();

	public List<GameObject> dependents = new List<GameObject>();

	private void Start()
	{
		foreach (BallInfo ballInfo in ballInfos)
		{
			ballInfo.gameObject.transform.position = ballInfo.start.position;
			ballInfo.ambientAudioSource.time = UnityEngine.Random.Range(0f, ballInfo.ambientAudioSource.clip.length);
		}
	}

	private void OnEnable()
	{
		foreach (GameObject dependent in dependents)
		{
			dependent?.SetActive(value: true);
		}
	}

	private void OnDisable()
	{
		foreach (GameObject dependent in dependents)
		{
			if ((bool)dependent)
			{
				dependent.SetActive(value: false);
			}
		}
	}

	public void OnPointerDown(GameObject targetObject)
	{
		for (int i = 0; i < ballInfos.Count; i++)
		{
			BallInfo ballInfo = ballInfos[i];
			if (targetObject == ballInfo.gameObject)
			{
				if (!ballInfo.isPaused && (bool)ballInfo.tapEffect)
				{
					GameObject gameObject = UnityEngine.Object.Instantiate(ballInfo.tapEffect, ballInfo.gameObject.transform.position, ballInfo.tapEffect.transform.rotation);
					gameObject.transform.Rotate(0f, UnityEngine.Random.Range(-180, 180), 0f, Space.World);
					gameObject.SetActive(value: true);
					ballInfo.ambientAudioSource.Pause();
				}
				ballInfo.isPaused = true;
			}
		}
	}

	public void OnPointerUp(GameObject targetObject)
	{
		for (int i = 0; i < ballInfos.Count; i++)
		{
			BallInfo ballInfo = ballInfos[i];
			if (ballInfo.isPaused)
			{
				ballInfo.isPaused = false;
				ballInfo.ambientAudioSource.UnPause();
			}
		}
	}

	private void Update()
	{
		foreach (BallInfo ballInfo in ballInfos)
		{
			ballInfo.Update();
		}
	}
}
}
