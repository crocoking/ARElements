using System;
using UnityEngine;

namespace ARElements
{
    public class AnnotationSpawner : MonoBehaviour
    {
        public bool isAnnotationSpawned
        {
            get
            {
                return m_AnnotationController != null;
            }
        }

        private void Start()
        {
            if (spawnOnStart)
            {
                Invoke("CreateAnnotation", spawnOnStartDelay);
            }
        }

        private void OnDestroy()
        {
            DestroyAnnotation();
        }

        private void OnDrawGizmosSelected()
        {
            Gizmos.color = Color.blue;
            Gizmos.DrawWireCube(transform.position, new Vector3(0.1f, 0.1f, 0.01f));
        }

        public void CreateAnnotation()
        {
            if (m_AnnotationController != null)
            {
                return;
            }
            if (annotatedObject == null)
            {
                Debug.LogError("Can't create annotation with null target object.");
                return;
            }
            Transform transform = (!(annotatedObject != null)) ? base.transform.parent : annotatedObject.transform;
            if (transform == null)
            {
                Debug.LogError("Can't create annotation without an annotated object to receive it. Assign the annotatedObject reference or nest the AnnotationSpawner on the object you want to annotate.");
                return;
            }
            m_AnnotationController = Instantiate(annotationPrefab, base.transform.position, base.transform.rotation);
            m_AnnotationController.PopulateAnnotation(annotationData, base.transform, transform);
        }

        public void DestroyAnnotation()
        {
            if (m_AnnotationController == null)
            {
                return;
            }
            if (Application.isEditor && !Application.isPlaying)
            {
                DestroyImmediate(m_AnnotationController.gameObject);
            }
            else
            {
                Destroy(m_AnnotationController.gameObject);
            }

            m_AnnotationController = null;
        }

        [Tooltip("The transform of the object that we're annotating. If null we assume the parent of this object is the item to annotate.")]
        public Transform annotatedObject;

        [Tooltip("Information about this object to display inside an annotation.")]
        public AnnotationData annotationData;

        [Tooltip("Prefab that contains the annotations view and an AnnotationController.")]
        public AnnotationController annotationPrefab;

        private AnnotationController m_AnnotationController;

        [Tooltip("If true, we'll load the annotation when this game object starts running.")]
        public bool spawnOnStart = true;

        [Tooltip("If spawning on start, you can optionally have a delay before the annotation appears.")]
        public float spawnOnStartDelay = 1f;
    }
}
