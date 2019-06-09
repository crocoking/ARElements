using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ARElements
{
    public class CoordinatorReceiver : MonoBehaviour
    {
        private CoordinatorContext m_Context;

        public CoordinatorContext context
        {
            get
            {
                if(m_Context == null)
                {
                    m_Context = GetComponentInParent<CoordinatorContext>();
                }
                return m_Context;
            }
        }

        public T GetCoordinator<T>() where T:MonoBehaviour
        {
            if(context == null)
            {
                return (T)((object)null);
            }
            return context.GetCoordinator<T>();
        }

        private void OnTransformParentChanged()
        {
            m_Context = null;
        }
    }
}
