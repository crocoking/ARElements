using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements
{
    public class GestureTouches : MonoBehaviour
    {
        private static GestureTouches s_instance;

        public LayerMask raycastLayerMask = -1;

        private int m_LastUpdatedFrameCount = -1;

        private PointerEventData m_EventData;

        private List<RaycastResult> m_RaycastResults = new List<RaycastResult>();

        private HashSet<int> m_RetainedFingerIds = new HashSet<int>();

        public static Touch[] touches
        {
            get
            {
                return Input.touches;
            }
        }

        public static bool TryFindTouch(int fingerId, out Touch touch)
        {
            for (int i = 0; i < GestureTouches.touches.Length; i++)
            {
                if(GestureTouches.touches[i].fingerId == fingerId)
                {
                    touch = GestureTouches.touches[i];
                    return true;
                }
            }
            touch = default(Touch);
            return false;
        }

        public static float PixelsToInches(float pixels)
        {
            return pixels / Screen.dpi;
        }

        public static float InchesToPixels(float inches)
        {
            return inches * Screen.dpi;
        }

        public static bool IsTouchOffScreenEdge(Touch touch, float edgeSlopInches)
        {
            float num = GestureTouches.InchesToPixels(edgeSlopInches);
            bool flag = touch.position.x <= num;
            flag |= (touch.position.y <= num);
            flag |= (touch.position.x >= (float)Screen.width - num);
            return flag | touch.position.y >= (float)Screen.height - num;
        }

        public static bool RaycastFromCamera(Vector2 screenPos, out RaycastResult result)
        {
            if(Camera.main == null)
            {
                result = default(RaycastResult);
                return false;
            }
            if(s_instance == null)
            {
                result = default(RaycastResult);
                return false;
            }
            if(s_instance.m_EventData == null)
            {
                s_instance.m_EventData = new PointerEventData(EventSystem.current);
            }
            s_instance.m_EventData.position = screenPos;
            EventSystem.current.RaycastAll(s_instance.m_EventData, s_instance.m_RaycastResults);
            if(s_instance.m_RaycastResults.Count == 0)
            {
                result = default(RaycastResult);
                return false;
            }
            result = FindFirstRaycast(s_instance.m_RaycastResults);
            return true;
        }

        public static void LockFingerId(int fingerId)
        {
            if(s_instance == null)
            {
                return;
            }
            if(!IsFingerIdRetained(fingerId))
            {
                s_instance.m_RetainedFingerIds.Add(fingerId);
            }
        }

        public static void ReleaseFingerId(int fingerId)
        {
            if(s_instance == null)
            {
                return;
            }

            if(IsFingerIdRetained(fingerId))
            {
                s_instance.m_RetainedFingerIds.Remove(fingerId);
            }
        }

        public static bool IsFingerIdRetained(int fingerId)
        {
            return !(s_instance == null) && s_instance.m_RetainedFingerIds.Contains(fingerId);
        }

        private void Awake()
        {
            if(s_instance != null)
            {
                Debug.LogError("More than one GestureTouches s_instance was found in your scene. Ensure that there is only one GestureTouches.");
                base.enabled = false;
                return;
            }
            s_instance = this;
        }

        private void Update()
        {
            if(m_LastUpdatedFrameCount != Time.frameCount)
            {
                m_LastUpdatedFrameCount = Time.frameCount;
            }
        }

        private static RaycastResult FindFirstRaycast(List<RaycastResult> candidates)
        {
            for (int i = 0; i < candidates.Count; i++)
            {
                if(!(candidates[i].gameObject == null))
                {
                    return candidates[i];
                }
            }
            return default(RaycastResult);
        }
    }
}
