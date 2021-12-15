using UnityEngine;

namespace ARElements{

public abstract class BaseCanvasAnnotationTransition : MonoBehaviour
{
	private AnnotationViewSize m_ViewSize;

	public AnnotationViewSize viewSize
	{
		get
		{
			return m_ViewSize;
		}
		protected set
		{
			m_ViewSize = value;
		}
	}

	public abstract void TransitionToViewSize(AnnotationData annotationData, AnnotationViewSize nextAnnotationViewSize);
}
}
