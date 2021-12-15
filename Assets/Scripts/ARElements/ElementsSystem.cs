using UnityEngine;

namespace ARElements{

public class ElementsSystem : MonoBehaviour
{
	public static ElementsSystem instance;

	[SerializeField]
	[Tooltip("Plane manager handles AR plane updates.")]
	private PlaneManager m_PlaneManager;

	[SerializeField]
	[Tooltip("Controller managing focus points on planes.")]
	private PlaneFocusController m_PlaneFocusController;

	[SerializeField]
	[Tooltip("Controller managing object selection.")]
	private SelectionCoordinator m_SelectionCoordinator;

	[SerializeField]
	[Tooltip("Controller managing the shadow rendering.")]
	private ShadowMapController m_ShadowController;

	[SerializeField]
	[Tooltip("Controller managing the plane discovery indicator.")]
	private PlaneDiscovery m_PlaneDiscovery;

	[SerializeField]
	[Tooltip("Controller for presenting annotation content on screen.")]
	private AnnotationPresenter m_AnnotationPresenter;

	public PlaneManager planeManager => m_PlaneManager;

	public PlaneFocusController planeFocusController => m_PlaneFocusController;

	public SelectionCoordinator selectionCoordinator => m_SelectionCoordinator;

	public ShadowMapController shadowController => m_ShadowController;

	public PlaneDiscovery planeDiscovery => m_PlaneDiscovery;

	public AnnotationPresenter annotationPresenter => m_AnnotationPresenter;

	private void Awake()
	{
		if (instance != null)
		{
			Debug.LogWarning("Created duplicate ElementsSystem, setting instance property to latest version");
		}
		instance = this;
	}

	private void OnDestroy()
	{
		if (instance == this)
		{
			instance = null;
		}
	}

	private void Update()
	{
		AndroidUtilities.KeepAwakeIfTracking();
	}
}
}