using System;
using UnityEngine;

namespace IslandsDotty
{

	[RequireComponent(typeof(AudioSource))]
	public class PlayFXOnNotify : MonoBehaviour
	{
		[Serializable]
		public struct SFX_listItem
		{
			public string Notes;

			public AudioClip SFX_to_Play;

			public float Volume;

			public float Pitch;

			[Tooltip("Assign an AudioSource. If left blank assumes this transform's audio source.")]
			public AudioSource AudioSource;
		}

		[Serializable]
		public struct VFX_listItem
		{
			public string Notes;

			public GameObject VFX_to_Play;

			[Tooltip("Parent Transform of the spawned VFX. If un-Assigned, assumes this transform.")]
			public Transform parent;
		}

		public VFX_listItem[] VFX_List;

		public SFX_listItem[] SFX_List;

		private void Awake()
		{
			for (int i = 0; i < SFX_List.Length; i++)
			{
				if (SFX_List[i].AudioSource == null)
				{
					SFX_List[i].AudioSource = base.transform.GetComponent<AudioSource>();
					SFX_List[i].AudioSource.playOnAwake = false;
				}
			}
			for (int j = 0; j < VFX_List.Length; j++)
			{
				if (VFX_List[j].parent == null)
				{
					VFX_List[j].parent = base.transform;
				}
			}
		}

		public void PlayVFX(int index)
		{
			if (Application.isPlaying)
			{
				GameObject gameObject = UnityEngine.Object.Instantiate(VFX_List[index].VFX_to_Play, VFX_List[index].parent);
				ParticleSystem componentInChildren = gameObject.transform.GetComponentInChildren<ParticleSystem>();
				componentInChildren.Play();
			}
		}

		public void PlaySFX(int index)
		{
			SFX_List[index].AudioSource.clip = SFX_List[index].SFX_to_Play;
			SFX_List[index].AudioSource.volume = SFX_List[index].Volume;
			SFX_List[index].AudioSource.pitch = SFX_List[index].Pitch;
			SFX_List[index].AudioSource.Play();
		}
	}
}
