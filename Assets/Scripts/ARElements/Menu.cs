using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace ARElements{

[RequireComponent(typeof(ScrollDragController))]
public class Menu : MonoBehaviour
{
	private enum DragState
	{
		Unknown,
		Idle,
		ThumbnailDrag,
		PlacementDrag
	}

	public MenuLayout menuLayout;

	public MenuListData menuData;

	public MenuItemHandler menuItemHandler;

	public MenuItemBaseThumbnailTransition thumbnailTransition;

	public MenuItemPlacementTransition placementTransition;

	public RectTransform contentRect;

	public ScrollRect scrollRect;

	public float thumbnailHitPadding = 7f;

	private Dictionary<MenuItemData, GameObject> m_ItemToThumbnail = new Dictionary<MenuItemData, GameObject>();

	private DragState m_DragState = DragState.Idle;

	private MenuItem m_ForcedDragItem;

	private ScrollDragController m_ScrollDragController;

	private bool m_IsRotatingThumbnails;

	private EasedQuaternion m_EasedUIRotation = new EasedQuaternion(Quaternion.identity);

	private const float k_UIRotationDuration = 0.5f;

	public void Start()
	{
		LayoutMenu();
		m_ScrollDragController = GetComponent<ScrollDragController>();
		m_ScrollDragController.startForcedDrag.AddListener(OnForcedDragStart);
		m_ScrollDragController.continueForcedDrag.AddListener(OnForcedDragContinue);
		m_ScrollDragController.endForcedDrag.AddListener(OnForcedDragEnd);
	}

	public void Update()
	{
		UpdateOrientation();
	}

	public void LayoutMenu()
	{
		menuLayout.BeginMenuLayout(menuData);
		for (int i = 0; i < menuData.items.Count; i++)
		{
			MenuItemData menuItemData = menuData.items[i];
			GameObject thumbnailForMenuItem = GetThumbnailForMenuItem(menuItemData);
			if (thumbnailForMenuItem == null)
			{
				Debug.LogError("Failed to load menu item thumbnail.");
				continue;
			}
			MenuItem component = thumbnailForMenuItem.GetComponent<MenuItem>();
			component.itemData = menuItemData;
			component.beginDragHandler = ItemBeginDragCallback;
			component.dragHandler = ItemDragCallback;
			component.endDragHandler = ItemEndDragCallback;
			component.clickHandler = ItemClickCallback;
			menuItemHandler.PrepareMenuItemThumbnail(thumbnailForMenuItem, menuItemData);
			menuLayout.LayoutMenuItem(menuData, menuItemData, i, thumbnailForMenuItem);
		}
		menuLayout.EndMenuLayout(menuData);
	}

	public void UpdateOrientation()
	{
		m_EasedUIRotation.FadeTo(ScreenOrientationToDeviceOrientation.GetRotation(), 0.5f, Time.time);
		if (!m_IsRotatingThumbnails && m_EasedUIRotation.IsCompleted(Time.time))
		{
			return;
		}
		Quaternion rotation = m_EasedUIRotation.ValueAtTime(Time.time);
		for (int i = 0; i < menuData.items.Count; i++)
		{
			MenuItemData itemData = menuData.items[i];
			GameObject thumbnailForMenuItem = GetThumbnailForMenuItem(itemData);
			if (thumbnailForMenuItem == null)
			{
				Debug.LogError("Failed to load menu item thumbnail.");
			}
			else
			{
				thumbnailForMenuItem.transform.rotation = rotation;
			}
		}
		m_IsRotatingThumbnails = !m_EasedUIRotation.IsCompleted(Time.time);
	}

	private GameObject GetThumbnailAtPointOnScreen(Vector2 pointOnScreen, float radius)
	{
		Vector2 vector = Vector2.one * 0.5f * (radius + thumbnailHitPadding);
		Vector2 screenPoint = pointOnScreen - vector;
		Vector2 screenPoint2 = pointOnScreen + vector;
		Vector2 localPoint = default(Vector2);
		Vector2 localPoint2 = default(Vector2);
		Rect rect = default(Rect);
		foreach (MenuItemData key in m_ItemToThumbnail.Keys)
		{
			GameObject gameObject = m_ItemToThumbnail[key];
			RectTransform rectTransform = gameObject.transform as RectTransform;
			RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransform, screenPoint, null, out localPoint);
			RectTransformUtility.ScreenPointToLocalPointInRectangle(rectTransform, screenPoint2, null, out localPoint2);
			rect.min = localPoint;
			rect.max = localPoint2;
			Rect rect2 = rectTransform.rect;
			if (rect.xMax > rect2.xMin && rect.yMax > rect2.yMin && rect.xMin < rect2.xMax && rect.yMin < rect2.yMax)
			{
				return gameObject;
			}
		}
		return null;
	}

	private GameObject GetThumbnailForMenuItem(MenuItemData itemData)
	{
		if (m_ItemToThumbnail.ContainsKey(itemData))
		{
			return m_ItemToThumbnail[itemData];
		}
		if (itemData.thumbnailPrefab == null)
		{
			return null;
		}
		GameObject gameObject = Object.Instantiate(itemData.thumbnailPrefab, contentRect);
		gameObject.name = itemData.title;
		m_ItemToThumbnail.Add(itemData, gameObject);
		return gameObject;
	}

	private void OnEnable()
	{
		m_IsRotatingThumbnails = true;
		m_EasedUIRotation.JumpTo(ScreenOrientationToDeviceOrientation.GetRotation());
	}

	private void ItemBeginDragCallback(MenuItem item, PointerEventData eventData)
	{
		RemoveVerticalMovement(eventData);
		RemoveHorizontalMovement(eventData);
		if (m_ForcedDragItem != null && m_ForcedDragItem != item)
		{
			CancelDragEvent(m_ForcedDragItem, eventData);
		}
		m_ForcedDragItem = null;
		scrollRect.OnBeginDrag(eventData);
	}

	private void ItemDragCallback(MenuItem item, PointerEventData eventData)
	{
		if (m_ScrollDragController.movementType == ScrollDragController.MovementType.DragScrollRect)
		{
			ScrollingEvent(item, eventData);
		}
		if (m_ScrollDragController.movementType != ScrollDragController.MovementType.DragMenuItem)
		{
			CancelDragEvent(item, eventData);
		}
		else
		{
			DraggingEvent(item, eventData);
		}
	}

	private static void RemoveHorizontalMovement(PointerEventData eventData)
	{
		Vector2 delta = eventData.delta;
		Vector2 scrollDelta = eventData.scrollDelta;
		Vector2 position = eventData.position;
		delta.x = 0f;
		scrollDelta.x = 0f;
		position.x = eventData.pressPosition.x;
		eventData.delta = delta;
		eventData.scrollDelta = scrollDelta;
		eventData.position = position;
	}

	private static void RemoveVerticalMovement(PointerEventData eventData)
	{
		Vector2 delta = eventData.delta;
		Vector2 scrollDelta = eventData.scrollDelta;
		Vector2 position = eventData.position;
		delta.y = 0f;
		scrollDelta.y = 0f;
		position.y = eventData.pressPosition.y;
		eventData.delta = delta;
		eventData.scrollDelta = scrollDelta;
		eventData.position = position;
	}

	private void ScrollingEvent(MenuItem item, PointerEventData eventData)
	{
		RemoveVerticalMovement(eventData);
		scrollRect.OnDrag(eventData);
	}

	public void CancelDragEvent(MenuItem item, PointerEventData eventData)
	{
		if (m_DragState == DragState.PlacementDrag)
		{
			placementTransition.CancelPlacement(item, eventData);
			thumbnailTransition.CancelThumbnailDrag(item, eventData);
			m_DragState = DragState.Idle;
		}
		else if (m_DragState == DragState.ThumbnailDrag)
		{
			thumbnailTransition.CancelThumbnailDrag(item, eventData);
			m_DragState = DragState.Idle;
		}
	}

	private void DraggingEvent(MenuItem item, PointerEventData eventData)
	{
		if (m_DragState == DragState.Idle)
		{
			m_DragState = DragState.ThumbnailDrag;
			thumbnailTransition.BeginThumnailDrag(item, eventData);
		}
		thumbnailTransition.ContinueThumbnailDrag(item, eventData);
		if (thumbnailTransition.IsThumnailActionTriggered(item, eventData))
		{
			if (m_DragState == DragState.ThumbnailDrag)
			{
				m_DragState = DragState.PlacementDrag;
				placementTransition.BeginPlacement(item, eventData);
			}
			placementTransition.ContinuePlacement(item, eventData);
		}
		else if (m_DragState == DragState.PlacementDrag)
		{
			m_DragState = DragState.ThumbnailDrag;
			placementTransition.CancelPlacement(item, eventData);
		}
	}

	private void ItemEndDragCallback(MenuItem item, PointerEventData eventData)
	{
		RemoveVerticalMovement(eventData);
		if (m_ScrollDragController.movementType != 0)
		{
			RemoveHorizontalMovement(eventData);
		}
		scrollRect.OnEndDrag(eventData);
		if (m_DragState != DragState.Idle)
		{
			bool flag = false;
			if (m_DragState == DragState.PlacementDrag)
			{
				flag = placementTransition.EndPlacement(item, eventData);
			}
			if (flag)
			{
				thumbnailTransition.EndThumbnailDrag(item, eventData);
			}
			else
			{
				thumbnailTransition.CancelThumbnailDrag(item, eventData);
			}
			m_DragState = DragState.Idle;
		}
	}

	private void ItemClickCallback(MenuItem item)
	{
		menuItemHandler.DidSelectMenuItem(item);
	}

	private static PointerEventData TouchToPointerEvent(Touch touch)
	{
		PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
		pointerEventData.position = touch.position;
		return pointerEventData;
	}

	private void OnForcedDragStart(Touch touch)
	{
		if (RectTransformUtility.RectangleContainsScreenPoint(base.transform as RectTransform, touch.position, null))
		{
			scrollRect.velocity = Vector2.zero;
		}
		GameObject thumbnailAtPointOnScreen = GetThumbnailAtPointOnScreen(touch.position, touch.radius);
		if (!(thumbnailAtPointOnScreen == null))
		{
			m_ForcedDragItem = thumbnailAtPointOnScreen.GetComponent<MenuItem>();
		}
	}

	private void OnForcedDragContinue(Touch touch)
	{
		if (!(m_ForcedDragItem == null))
		{
			DraggingEvent(m_ForcedDragItem, TouchToPointerEvent(touch));
		}
	}

	private void OnForcedDragEnd(Touch touch)
	{
		if (!(m_ForcedDragItem == null))
		{
			CancelDragEvent(m_ForcedDragItem, TouchToPointerEvent(touch));
			m_ForcedDragItem = null;
		}
	}

	public void cancelForcedDrag()
	{
		m_ForcedDragItem = null;
	}
}
}
