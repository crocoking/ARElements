using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(MeshRenderer))]
[RequireComponent(typeof(MeshFilter))]
public abstract class PlaneLayer : MonoBehaviour
{
	public ITrackedPlane plane;

	private MeshRenderer m_MeshRenderer;

	public Mesh mesh { get; private set; }

	public PlaneStack planeStack => base.transform.parent.GetComponent<PlaneStack>();

	public bool isLayerTypeDisabled => planeStack.IsLayerTypeDisabled(layerType);

	public virtual bool shouldRender => true;

	public MeshRenderer meshRenderer => (!m_MeshRenderer) ? (m_MeshRenderer = GetComponent<MeshRenderer>()) : m_MeshRenderer;

	public abstract string layerType { get; }

	private void Awake()
	{
		meshRenderer.enabled = false;
	}

	public virtual void UpdateMesh(Mesh m)
	{
		MeshFilter component = GetComponent<MeshFilter>();
		mesh = m;
		component.sharedMesh = m;
	}
}
}
