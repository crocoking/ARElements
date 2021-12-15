using System.Collections.Generic;
using GoogleARCore;
using UnityEngine;

namespace ARElements{

public class ObjectBrowserController : MonoBehaviour
{
	private enum ScrollDirection
	{
		Clockwise,
		CounterClockwise,
		NotScrolling
	}

	private class ScrollInfo
	{
		public ScrollDirection direction;

		public float deltaAngle;

		public float velocity;

		public float startTime;

		public float stopTime;

		public float totalDeltaAngle;

		public Vector2 startTouchPosition;
	}

	private class AttachPoint
	{
		public Transform transform;

		public GameObject content;

		public int contentPosition;

		public AttachPoint(int contentPosition, Transform transform)
		{
			this.contentPosition = contentPosition;
			this.transform = transform;
		}
	}

	private class Panel
	{
		public bool isVisible;

		public GameObject panelObject;

		public List<AttachPoint> attachPoints;

		private EasedFloat m_ContentScale = new EasedFloat(0f);

		public Panel(GameObject panelObject)
		{
			this.panelObject = panelObject;
			attachPoints = new List<AttachPoint>();
		}

		public void UpdateAnimation()
		{
			foreach (AttachPoint attachPoint in attachPoints)
			{
				if (attachPoint.content != null)
				{
					attachPoint.transform.localScale = Vector3.one * m_ContentScale.ValueAtTime(Time.time);
				}
			}
		}

		public void DestroyContent()
		{
			m_ContentScale.FadeTo(0f, 0.01f, Time.time);
			foreach (AttachPoint attachPoint in attachPoints)
			{
				Object.Destroy(attachPoint.content);
				attachPoint.content = null;
			}
		}

		public void CreateContent(int firstContentPosition, List<GameObject> allContent, float scale, float animationDuration)
		{
			int num = 0;
			m_ContentScale.FadeTo(scale, animationDuration, Time.time);
			foreach (AttachPoint attachPoint in attachPoints)
			{
				attachPoint.contentPosition = firstContentPosition + num;
				GameObject original = allContent[MathUtilities.PositiveModulo(attachPoint.contentPosition, allContent.Count)];
				GameObject content = Object.Instantiate(original, attachPoint.transform.position, attachPoint.transform.rotation, attachPoint.transform);
				attachPoint.transform.localScale = Vector3.zero;
				attachPoint.content = content;
				num++;
			}
		}

		public bool IsEmpty()
		{
			foreach (AttachPoint attachPoint in attachPoints)
			{
				if (attachPoint.content != null)
				{
					return false;
				}
			}
			return true;
		}
	}

	public delegate void ARTouchEvent(TrackableHit hit);

	private class SimpleLayout
	{
		public List<Panel> panels = new List<Panel>();

		private int m_TotalAttachPoints;

		public void AddPanel(GameObject panel)
		{
			panels.Add(new Panel(panel));
		}

		public void AddAttachPoint(Transform transform)
		{
			panels[panels.Count - 1].attachPoints.Insert(0, new AttachPoint(m_TotalAttachPoints++, transform));
		}

		private void ContentPositionRange(out int min, out int max)
		{
			min = int.MaxValue;
			max = int.MinValue;
			foreach (Panel panel in panels)
			{
				foreach (AttachPoint attachPoint in panel.attachPoints)
				{
					min = Mathf.Min(min, attachPoint.contentPosition);
					max = Mathf.Max(max, attachPoint.contentPosition);
				}
			}
			if (min == int.MaxValue)
			{
				min = (max = 0);
			}
		}

		public void RecycleContent(Panel panelFacingCamera, List<GameObject> allContent, float containedObjectScale, float animationDuration, ScrollDirection direction)
		{
			int num = panels.IndexOf(panelFacingCamera);
			int index = (num + panels.Count / 2) % panels.Count;
			if (panels[num].IsEmpty())
			{
				int firstContentPosition = panels[num].attachPoints[0].contentPosition;
				if (direction != ScrollDirection.NotScrolling)
				{
					ContentPositionRange(out var min, out var max);
					firstContentPosition = ((direction != 0) ? (min - panels[num].attachPoints.Count) : (max + 1));
				}
				panels[num].CreateContent(firstContentPosition, allContent, containedObjectScale, animationDuration);
			}
			panels[index].DestroyContent();
		}

		public Panel CalculatePanelFacingCamera(Vector3 cameraPos)
		{
			Panel result = null;
			Transform parent = panels[0].panelObject.transform.parent;
			Vector3 from = parent.position - cameraPos;
			from.y = 0f;
			float num = 180f;
			foreach (Panel panel in panels)
			{
				float num2 = Vector3.Angle(from, -panel.panelObject.transform.forward);
				if (num2 < num)
				{
					num = num2;
					result = panel;
				}
			}
			return result;
		}
	}

	public Camera firstPersonCamera;

	public GameObject searchingForPlaneUI;

	public GameObject readyToBrowseUI;

	public GameObject galleryPrefab;

	public List<GameObject> contentsPrefabs = new List<GameObject>();

	public float containedObjectScale = 0.05f;

	public float scrollDegreesPerPixel = -0.18f;

	public float animationDuration = 1f;

	private GameObject m_Gallery;

	private DetectedPlane m_GroundPlane;

	private EasedFloat m_GalleryScale = new EasedFloat(0f);

	private GameObject m_RotationPoint;

	private List<DetectedPlane> m_NewPlanes = new List<DetectedPlane>();

	private List<DetectedPlane> m_AllPlanes = new List<DetectedPlane>();

	private SimpleLayout m_Layout = new SimpleLayout();

	private ScrollInfo m_Scroll = new ScrollInfo();

	private ScrollDirection m_PanelScrolling = ScrollDirection.NotScrolling;

	private Panel m_MostVisiblePanel;

	private Panel m_PrevMostVisiblePanel;

	private const float k_MinScrollDeltaAnglePerPanel = 30f;

	public static event ARTouchEvent OnARTouch;

	private void Start()
	{
		OnARTouch += AttachBrowser;
	}

	private void Update()
	{
		if (!AndroidUtilities.KeepAwakeIfTracking())
		{
			return;
		}
		Session.GetTrackables(m_NewPlanes, TrackableQueryFilter.New);
		bool flag = true;
		Session.GetTrackables(m_AllPlanes);
		for (int i = 0; i < m_AllPlanes.Count; i++)
		{
			if (m_AllPlanes[i].TrackingState == TrackingState.Tracking)
			{
				flag = false;
				break;
			}
		}
		searchingForPlaneUI.SetActive(flag);
		bool readyToBrowse = false;
		if (m_Gallery == null && !flag)
		{
			readyToBrowse = true;
		}
		if (m_Gallery != null && (m_GroundPlane == null || m_GroundPlane.TrackingState != 0))
		{
			Object.Destroy(m_Gallery);
			m_Layout.panels.Clear();
			m_Gallery = null;
			flag = true;
			readyToBrowse = false;
			m_GalleryScale.FadeTo(0f, 0.1f, Time.time);
		}
		UpdateBrowserUI(readyToBrowse);
		UpdateScroll();
		UpdateVisibility();
	}

	private void UpdateVisibility()
	{
		if (m_Gallery == null || !m_Gallery.activeInHierarchy)
		{
			return;
		}
		bool flag = false;
		foreach (Panel panel in m_Layout.panels)
		{
			bool isVisible = panel.isVisible;
			Vector3 lhs = firstPersonCamera.transform.position - panel.panelObject.transform.position;
			panel.isVisible = Vector3.Dot(lhs, panel.panelObject.transform.forward) < 0f;
			if (panel.isVisible && !isVisible)
			{
				flag = true;
			}
			panel.UpdateAnimation();
		}
		m_MostVisiblePanel = m_Layout.CalculatePanelFacingCamera(firstPersonCamera.transform.position);
		if (flag)
		{
			if (m_Scroll.direction == ScrollDirection.NotScrolling)
			{
				m_PrevMostVisiblePanel = m_MostVisiblePanel;
			}
			else if (m_PrevMostVisiblePanel != m_MostVisiblePanel && Mathf.Abs(m_Scroll.deltaAngle) > 30f)
			{
				m_PanelScrolling = m_Scroll.direction;
			}
			else
			{
				m_PanelScrolling = ScrollDirection.NotScrolling;
			}
		}
		m_Layout.RecycleContent(m_MostVisiblePanel, contentsPrefabs, containedObjectScale, animationDuration, m_Scroll.direction);
	}

	private void UpdateBrowserUI(bool readyToBrowse)
	{
		readyToBrowseUI.SetActive(readyToBrowse);
		if (readyToBrowse && Input.touchCount >= 1)
		{
			Touch touch;
			Touch touch2 = (touch = Input.GetTouch(0));
			if (touch2.phase == TouchPhase.Began && RaycastUtilities.GetRaycastResult(touch.position, firstPersonCamera, out var hit))
			{
				ObjectBrowserController.OnARTouch(hit);
			}
		}
	}

	private void UpdateScroll()
	{
		m_Scroll.velocity = 0f;
		if (m_Gallery == null || !m_Gallery.activeInHierarchy)
		{
			return;
		}
		m_RotationPoint.transform.localScale = Vector3.one * m_GalleryScale.ValueAtTime(Time.time);
		if (m_Scroll.startTime > m_Scroll.stopTime)
		{
			if (Input.touchCount == 1)
			{
				Touch touch;
				Touch touch2 = (touch = Input.GetTouch(0));
				if (touch2.phase != TouchPhase.Ended)
				{
					float num = touch.deltaPosition.x * scrollDegreesPerPixel;
					if (m_PanelScrolling == ScrollDirection.NotScrolling || num > 0f != (m_PanelScrolling == ScrollDirection.Clockwise))
					{
						m_Scroll.deltaAngle += num;
						m_Scroll.velocity = num / Time.deltaTime;
					}
					if (num > 0f)
					{
						m_Scroll.direction = ScrollDirection.Clockwise;
					}
					else
					{
						m_Scroll.direction = ScrollDirection.CounterClockwise;
					}
					m_RotationPoint.transform.localRotation = Quaternion.AngleAxis(m_Scroll.totalDeltaAngle + m_Scroll.deltaAngle, Vector3.up);
					return;
				}
			}
			m_Scroll.stopTime = Time.time;
			m_Scroll.totalDeltaAngle += m_Scroll.deltaAngle;
			m_Scroll.deltaAngle = 0f;
			m_PanelScrolling = ScrollDirection.NotScrolling;
			m_Scroll.direction = ScrollDirection.NotScrolling;
		}
		else if (Input.touchCount == 1)
		{
			Touch touch;
			Touch touch3 = (touch = Input.GetTouch(0));
			if (touch3.phase == TouchPhase.Began)
			{
				m_Scroll.startTime = Time.time;
				m_Scroll.startTouchPosition = touch.position;
			}
		}
	}

	private void AttachBrowser(TrackableHit hit)
	{
		if (!(m_Gallery != null))
		{
			Anchor anchor = Session.CreateAnchor(hit.Pose);
			m_RotationPoint = new GameObject();
			m_RotationPoint.transform.SetParent(anchor.transform, worldPositionStays: false);
			m_Gallery = Object.Instantiate(galleryPrefab, hit.Pose.position, Quaternion.identity, m_RotationPoint.transform);
			m_GalleryScale.FadeTo(1f, animationDuration, Time.time);
			m_Gallery.SetActive(value: true);
			m_Gallery.transform.LookAt(firstPersonCamera.transform);
			m_Gallery.transform.rotation = Quaternion.Euler(0f, m_Gallery.transform.rotation.eulerAngles.y, m_Gallery.transform.rotation.z);
			m_Gallery.GetComponent<PlaneAttachment>().Attach(hit.Trackable as DetectedPlane);
			m_GroundPlane = hit.Trackable as DetectedPlane;
			FindPanelsAndAttachPoints();
		}
	}

	private void FindPanelsAndAttachPoints()
	{
		if (m_Gallery == null)
		{
			return;
		}
		List<Transform> list = new List<Transform>();
		list.Add(m_Gallery.transform);
		while (list.Count > 0)
		{
			Transform transform = list[0];
			list.Remove(transform);
			for (int num = transform.childCount - 1; num >= 0; num--)
			{
				list.Insert(0, transform.GetChild(num));
			}
			if (transform.gameObject.name.StartsWith("Panel_") && transform.gameObject.name.EndsWith("Displays"))
			{
				m_Layout.AddPanel(transform.gameObject);
			}
			else if (m_Layout.panels.Count > 0 && transform.name.StartsWith("AttachPoint_"))
			{
				m_Layout.AddAttachPoint(transform);
			}
		}
	}
}
}
