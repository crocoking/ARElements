using GoogleARCore.BestPractices;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

namespace IslandsDotty
{

	public class LocomotionWaypoint : MonoBehaviour, IPointerClickHandler, IEventSystemHandler
	{
		[Tooltip("Size of the Trigger to raycast against.")]
		public float TriggerSize = 7f;

		public bool createCollider = true;

		public UnityEvent onClick = new UnityEvent();

		private SceneInfoCollection.SceneInfo _sceneInfo;

		private GameObject buttonGO;

		public LocomotionController locomotionController { get; set; }

		public SphereCollider sphereCollider { get; private set; }

		public SceneInfoCollection.SceneInfo sceneInfo
		{
			get
			{
				return _sceneInfo;
			}
			set
			{
				if (value != _sceneInfo)
				{
					_sceneInfo = value;
					OnSetSceneInfo();
				}
			}
		}

		private void Awake()
		{
			if (createCollider)
			{
				if (sphereCollider == null)
				{
					sphereCollider = base.transform.gameObject.AddComponent<SphereCollider>();
				}
				sphereCollider.isTrigger = true;
				sphereCollider.radius = TriggerSize;
			}
		}

		private void OnSetSceneInfo()
		{
			if (!buttonGO)
			{
				buttonGO = Object.Instantiate(Resources.Load<GameObject>("WaypointButton3D_P"), base.transform.parent);
			}
			switch (sceneInfo.islandGroup)
			{
				case 0:
					buttonGO.GetComponentInChildren<Renderer>().sharedMaterial = Resources.Load<Material>("WaypointButton_Green_Mat");
					break;
				case 1:
					buttonGO.GetComponentInChildren<Renderer>().sharedMaterial = Resources.Load<Material>("WaypointButton_Blue_Mat");
					break;
				case 2:
					buttonGO.GetComponentInChildren<Renderer>().sharedMaterial = Resources.Load<Material>("WaypointButton_Red_Mat");
					break;
				case 3:
					buttonGO.GetComponentInChildren<Renderer>().sharedMaterial = Resources.Load<Material>("WaypointButton_Yellow_Mat");
					break;
				default:
					buttonGO.GetComponentInChildren<Renderer>().sharedMaterial = Resources.Load<Material>("WaypointButton_Green_Mat");
					break;
			}
			buttonGO.transform.Find("CanvasRoot").gameObject.SetActive(!string.IsNullOrWhiteSpace(sceneInfo.title));
		}

		public void OnPointerClick(PointerEventData eventData)
		{
			if (!locomotionController)
			{
				return;
			}
			if (!Application.CanStreamedLevelBeLoaded(sceneInfo.name))
			{
				Debug.LogError($"\"{sceneInfo.name}\" is not a valid scene.");
			}
			else if (!locomotionController.blockingAction)
			{
				locomotionController.JumpToLocation(this);
				if (onClick != null)
				{
					onClick.Invoke();
				}
			}
		}
	}
}
