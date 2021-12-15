using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class GestureCoordinator : MonoBehaviour
{
	public TapGestureRecognizer tapGestureRecognizer;

	public DragGestureRecognizer dragGestureRecognizer;

	public PinchGestureRecognizer pinchGestureRecognizer;

	public TwistGestureRecognizer twistGestureRecognizer;

	private Dictionary<Type, BaseGestureRecognizer> m_GestureControllerMap;

	private Dictionary<Type, BaseGestureRecognizer> GestureControllerMap
	{
		get
		{
			if (m_GestureControllerMap == null)
			{
				m_GestureControllerMap = new Dictionary<Type, BaseGestureRecognizer>();
				m_GestureControllerMap[typeof(TapGesture)] = tapGestureRecognizer;
				m_GestureControllerMap[typeof(DragGesture)] = dragGestureRecognizer;
				m_GestureControllerMap[typeof(PinchGesture)] = pinchGestureRecognizer;
				m_GestureControllerMap[typeof(TwistGesture)] = twistGestureRecognizer;
			}
			return m_GestureControllerMap;
		}
	}

	public BaseGestureRecognizer GetGestureRecognizer<T>() where T : BaseGesture
	{
		if (GestureControllerMap.TryGetValue(typeof(T), out var value))
		{
			return value;
		}
		return null;
	}
}
}
