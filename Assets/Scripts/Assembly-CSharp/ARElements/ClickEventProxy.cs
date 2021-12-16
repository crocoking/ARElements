using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

namespace ARElements{

public class ClickEventProxy : MonoBehaviour, IPointerClickHandler, IEventSystemHandler
{
	[Serializable]
	public class ButtonClickedEvent : UnityEvent
	{
	}

	[SerializeField]
	private ButtonClickedEvent m_OnClick = new ButtonClickedEvent();

	public ButtonClickedEvent onClick
	{
		get
		{
			return m_OnClick;
		}
		set
		{
			m_OnClick = value;
		}
	}

	public virtual void OnPointerClick(PointerEventData eventData)
	{
		if (!eventData.dragging)
		{
			m_OnClick.Invoke();
		}
	}
}
}
