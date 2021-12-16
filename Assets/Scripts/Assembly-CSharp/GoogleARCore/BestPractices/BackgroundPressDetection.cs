using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class BackgroundPressDetection : MonoBehaviour
{
	public delegate bool PressConditionDelegate();

	public UnityEvent onPress;

	public UnityEvent onRelease;

	private HashSet<PressConditionDelegate> pressConditions = new HashSet<PressConditionDelegate>();

	public bool isPressing { get; private set; }

	public void AddCondition(PressConditionDelegate pressCondition)
	{
		pressConditions.Add(pressCondition);
	}

	public void RemoveCondition(PressConditionDelegate pressCondition)
	{
		pressConditions.Remove(pressCondition);
	}

	private void Update()
	{
		if (!isPressing && CheckBackgroundPress())
		{
			bool flag = true;
			foreach (PressConditionDelegate pressCondition in pressConditions)
			{
				if (!pressCondition())
				{
					flag = false;
					break;
				}
			}
			if (flag)
			{
				isPressing = true;
				try
				{
					if (onPress != null)
					{
						onPress.Invoke();
					}
				}
				catch (Exception exception)
				{
					Debug.LogException(exception);
				}
			}
		}
		if (!isPressing || ((!Application.isMobilePlatform) ? Input.GetMouseButton(0) : (Input.touchCount > 0)))
		{
			return;
		}
		isPressing = false;
		try
		{
			if (onRelease != null)
			{
				onRelease.Invoke();
			}
		}
		catch (Exception exception2)
		{
			Debug.LogException(exception2);
		}
	}

	private bool CheckBackgroundPress()
	{
		if (Input.touchCount > 0 || Input.GetMouseButtonDown(0))
		{
			if (Input.touchCount > 0 && Input.GetTouch(0).phase != 0)
			{
				return false;
			}
			PointerEventData pointerEventData = new PointerEventData(EventSystem.current);
			pointerEventData.position = ((Input.touchCount <= 0) ? ((Vector2)Input.mousePosition) : Input.GetTouch(0).position);
			List<RaycastResult> list = new List<RaycastResult>();
			EventSystem.current.RaycastAll(pointerEventData, list);
			foreach (RaycastResult item in list)
			{
				if ((bool)item.gameObject && (bool)item.gameObject.GetComponentInParent<Selectable>())
				{
					return false;
				}
			}
			return true;
		}
		return false;
	}
}
}
