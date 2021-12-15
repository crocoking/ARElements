using UnityEngine;
using UnityEngine.EventSystems;

namespace ARElements
{

	[ExecuteInEditMode]
	public class AnnotationController : MonoBehaviour, IPointerClickHandler, IEventSystemHandler
	{
		[Tooltip("Annotation information that will be used to populate an annotation card.")]
		public AnnotationData annotationData;

		[Tooltip("Transition that will be used to change the mesh between the different card sizes.")]
		public BaseMeshAnnotationTransition cardMeshTransition;

		[Tooltip("Transition that will be used to change the UI between different card sizes.")]
		public BaseCanvasAnnotationTransition cardCanvasTransition;

		[Tooltip("The positioner uses the spawn location and annotation data info to determine how to position the card on the model.")]
		public BaseAnnotationPositioner cardPositioner;

		[Tooltip("Distance from viewer to show the large card layout.")]
		public float largeViewDistance = 1f;

		[Tooltip("Distance from viewer to show the medium card layout.")]
		public float mediumViewDistance = 2f;

		[Tooltip("Distance from viewer to show the small card layout.")]
		public float smallViewDistance = 10f;

		private Transform m_AnnotatedObject;

		private Transform m_SpawnTransform;

		public Transform viewer => (!Camera.main) ? null : Camera.main.transform;

		public AnnotationViewSize annotationViewSize { get; protected set; }

		public void PopulateAnnotation(AnnotationData annotationData, Transform spawnTransform, Transform annotatedObject)
		{
			this.annotationData = annotationData;
			m_SpawnTransform = spawnTransform;
			m_AnnotatedObject = annotatedObject;
			UpdateCardForSize(annotationViewSize);
		}

		private void Update()
		{
			if (!(viewer == null) && !(m_AnnotatedObject == null) && !(annotationData == null) && !(cardMeshTransition == null) && !(cardCanvasTransition == null) && !(cardPositioner == null))
			{
				SetViewMode(CalculateBestViewMode());
				cardPositioner.UpdateAnnotationPosition(viewer, m_SpawnTransform, m_AnnotatedObject);
			}
		}

		private void SetViewMode(AnnotationViewSize viewSize)
		{
			if (viewSize != annotationViewSize)
			{
				UpdateCardForSize(viewSize);
				annotationViewSize = viewSize;
			}
		}

		private void UpdateCardForSize(AnnotationViewSize viewSize)
		{
			cardMeshTransition.TransitionToViewSize(annotationData, viewSize);
			cardCanvasTransition.TransitionToViewSize(annotationData, viewSize);
		}

		private AnnotationViewSize CalculateBestViewMode()
		{
			if (!m_AnnotatedObject.gameObject.activeInHierarchy)
			{
				return AnnotationViewSize.Hidden;
			}
			if (annotationData == null || m_AnnotatedObject == null)
			{
				return AnnotationViewSize.Unknown;
			}
			float num = Vector3.Distance(viewer.position, base.transform.position);
			if (annotationData.supportsLargeCardSize && num <= largeViewDistance)
			{
				return AnnotationViewSize.Large;
			}
			if (annotationData.supportsMediumCardSize && num <= mediumViewDistance)
			{
				return AnnotationViewSize.Medium;
			}
			if (annotationData.supportsSmallCardSize && num <= smallViewDistance)
			{
				return AnnotationViewSize.Small;
			}
			return AnnotationViewSize.Hidden;
		}

		public void OnPointerClick(PointerEventData eventData)
		{
			if ((bool)annotationData && (bool)annotationData.screenCardPrefab)
			{
				ElementsSystem.instance.annotationPresenter.ShowAnnotationScreenCard(annotationData, annotationData.screenCardPrefab);
			}
		}
	}
}
