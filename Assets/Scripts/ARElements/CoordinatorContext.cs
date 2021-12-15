using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

public class CoordinatorContext : MonoBehaviour
{
	private Dictionary<Type, MonoBehaviour> m_Coordinators = new Dictionary<Type, MonoBehaviour>();

	public T GetCoordinator<T>() where T : MonoBehaviour
	{
		T val = (T)null;
		Type typeFromHandle = typeof(T);
		if (m_Coordinators.TryGetValue(typeFromHandle, out var value))
		{
			val = value as T;
		}
		if ((UnityEngine.Object)val == (UnityEngine.Object)null)
		{
			val = GetComponent<T>();
			if ((UnityEngine.Object)val != (UnityEngine.Object)null)
			{
				m_Coordinators[typeFromHandle] = val;
			}
		}
		return val;
	}
}
}
