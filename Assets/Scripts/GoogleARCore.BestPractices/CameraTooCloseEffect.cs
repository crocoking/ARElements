using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.Events;

namespace GoogleARCore.BestPractices{

public class CameraTooCloseEffect : MonoBehaviour
{
	public BlurEffect blurEffect;

	public float maxBlur = 2f;

	public Color tintColor = Color.white;

	public AudioSource inObjectAudioSource;

	public AudioMixer audioMixer;

	public AudioMixerSnapshot normalAudioSnapshot;

	public AudioMixerSnapshot inObjectAudioSnapshot;

	public float transitionSpeed = 5f;

	public float overlapRadius = 0.01f;

	public UnityEvent onEnter;

	public UnityEvent onExit;

	private float blurWeight;

	private bool wasInside;

	private Collider[] colliderCache = new Collider[1];

	private AudioMixerSnapshot[] audioSnapshots = new AudioMixerSnapshot[2];

	private float[] audioSnapshotWeights = new float[2];

	private void Awake()
	{
		audioSnapshots[0] = normalAudioSnapshot;
		audioSnapshots[1] = inObjectAudioSnapshot;
		audioSnapshotWeights[0] = 1f;
		audioSnapshotWeights[0] = 0f;
	}

	private void OnEnable()
	{
		CameraBlurController.current?.RegisterRequiredBlur(GetBlur);
	}

	private void OnDisable()
	{
		CameraBlurController.current?.UnregisterRequiredBlur(GetBlur);
	}

	private float GetBlur()
	{
		return Mathf.Lerp(0f, maxBlur, blurWeight);
	}

	private void LateUpdate()
	{
		bool flag = Physics.OverlapSphereNonAlloc(base.transform.position, overlapRadius, colliderCache) > 0;
		if (flag)
		{
			blurWeight += transitionSpeed * Time.deltaTime;
		}
		else
		{
			blurWeight -= transitionSpeed * Time.deltaTime;
		}
		blurWeight = Mathf.Clamp01(blurWeight);
		blurEffect.tintColor = Color.Lerp(Color.white, tintColor, blurWeight);
		if (wasInside != flag)
		{
			if (flag)
			{
				onEnter.Invoke();
			}
			else
			{
				onExit.Invoke();
			}
		}
		audioSnapshotWeights[0] = 1f - blurWeight;
		audioSnapshotWeights[1] = blurWeight;
		audioMixer.TransitionToSnapshots(audioSnapshots, audioSnapshotWeights, 0f);
		if (blurWeight > 0f && !inObjectAudioSource.isPlaying)
		{
			inObjectAudioSource.Play();
		}
		else if (blurWeight <= 0f && inObjectAudioSource.isPlaying)
		{
			inObjectAudioSource.Pause();
		}
		wasInside = flag;
	}
}
}
