using System;
using UnityEngine;

namespace ARElements
{
    public abstract class BaseAnnotationPositioner : MonoBehaviour
    {
        public abstract void UpdateAnnotationPosition(Transform viewer, Transform spawnTransform, Transform annotatedObject);
    }
}
