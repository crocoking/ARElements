using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class HoldButton : Button, IPointerDownHandler, IPointerUpHandler, IEventSystemHandler
{
	public UnityEvent onPressed = new UnityEvent();

	public UnityEvent onReleased = new UnityEvent();

	public bool isPressed { get; private set; }

	public override void OnPointerDown(PointerEventData eventData)
	{
		base.OnPointerDown(eventData);
		isPressed = true;
		if (onPressed != null)
		{
			onPressed.Invoke();
		}
	}

	public override void OnPointerUp(PointerEventData eventData)
	{
		base.OnPointerUp(eventData);
		isPressed = false;
		if (onReleased != null)
		{
			onReleased.Invoke();
		}
	}
}
}
