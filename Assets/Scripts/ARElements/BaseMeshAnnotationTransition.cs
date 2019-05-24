using System;
using UnityEngine;

namespace ARElements
{
    public abstract class BaseMeshAnnotationTransition : MonoBehaviour
    {
        public AnnotationViewSize viewSize
        {
            get
            {
                return m_ViewSize;
            }
            protected set
            {
                this.m_ViewSize = value;
            }
        }

        public abstract void TransitionToViewSize(AnnotationData data, AnnotationViewSize nextAnnotationViewSize);

        private AnnotationViewSize m_ViewSize;
    }
}
