using System;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;

namespace ARElements
{
    public abstract class BaseGestureRecognizer : MonoBehaviour
    {
        [Range(0f, 10f)]
        [Tooltip("Used to filter out accidental touches on the edge of the screen.")]
        public float edgeThresholdInches = 0.1f;

        public event Action<BaseGesture> onGestureStarted;

        protected abstract void TryCreateGestures();

        protected List<BaseGesture> m_Gestures = new List<BaseGesture>();

        private void Update()
        {
            TryCreateGestures();
            for (int i = m_Gestures.Count - 1; i >= 0; i--)
            {
                BaseGesture baseGesture = m_Gestures[i];
                baseGesture.Update();
                if (baseGesture.justStarted && onGestureStarted != null)
                {
                    onGestureStarted(baseGesture);
                }
            }
        }

        private void LateUpdate()
        {
            for (int i = m_Gestures.Count
                 - 1; i >= 0; i--)
            {
                if (m_Gestures[i].hasFinished)
                {
                    m_Gestures.RemoveAt(i);
                }
            }
        }

        protected void TryCreateOneFingerGestureOnTouchBegan<T>(Func<Touch, T> createGestureFunction) where T :
            BaseGesture
        {
            for (int i = 0; i < GestureTouches.touches.Length; i++)
            {
                Touch touch = GestureTouches.touches[i];
                if (touch.phase == null && !GestureTouches.IsFingerIdRetained(touch.fingerId) && !
                    GestureTouches.IsTouchOffScreenEdge(touch, edgeThresholdInches))
                {
                    m_Gestures.Add(createGestureFunction(touch));
                }
            }
        }

        protected void TryCreateTwoFingerGestureOnTouchBegan<T>(Func<Touch, Touch, T> createGestureFunction) where T:
            BaseGesture
        {
            if(GestureTouches.touches.Length < 2)
            {
                return;
            }
            for (int i = 0; i < GestureTouches.touches.Length; i++)
            {
                TryCreateGestureTwoFingerGestureOnTouchBeganForTouchIndex<T>(i, createGestureFunction);
            }
        }

        private void TryCreateGestureTwoFingerGestureOnTouchBeganForTouchIndex<T>(int touchIndex, Func<Touch, Touch, T>
             createGestureFunction) where T:BaseGesture
        {
            if(GestureTouches.touches[touchIndex].phase != null)
            {
                return;
            }
            Touch touch = GestureTouches.touches[touchIndex];
            if(GestureTouches.IsFingerIdRetained(touch.fingerId) || GestureTouches.IsTouchOffScreenEdge(touch,
                    edgeThresholdInches))
            {
                return;
            }
            for (int i = 0; i < GestureTouches.touches.Length; i++)
            {
                if (i != touchIndex)
                {
                    if (i >= touchIndex || GestureTouches.touches[i].phase != null)
                    {
                        Touch touch2 = GestureTouches.touches[i];
                        if (!GestureTouches.IsFingerIdRetained(touch2.fingerId) && !GestureTouches.IsTouchOffScreenEdge(touch2, edgeThresholdInches))
                        {
                            m_Gestures.Add(createGestureFunction(touch, touch2));
                        }
                    }
                }
            }

        }


    }
}
