using System;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements
{
    public class CoordinatorContext : MonoBehaviour
    {
        private Dictionary<Type, MonoBehaviour> m_Coordinators = new Dictionary<Type, MonoBehaviour>();

        public T GetCoordinator<T>() where T:MonoBehaviour
        {
            T t = (T)((object)null);
            Type typeFromHandle = typeof(T);
            MonoBehaviour monoBehaviour;
            if(m_Coordinators.TryGetValue(typeFromHandle, out monoBehaviour))
            {
                t = (monoBehaviour as T);
            }
            if(t == null)
            {
                t = base.GetComponent<T>();
                if(t != null)
                {
                    m_Coordinators[typeFromHandle] = t;
                }
            }
            return t;
        }
    }
}
