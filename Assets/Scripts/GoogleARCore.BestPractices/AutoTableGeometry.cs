using UnityEngine;

namespace GoogleARCore.BestPractices{

public class AutoTableGeometry : MonoBehaviour
{
	public AutoTable autoTable;

	public Mesh topSourceMesh;

	public Mesh middleSourceMesh;

	public Mesh bottomSourceMesh;

	public MeshFilter meshFilter;

	public Collider tableCollider;

	public Transform shadowTransform;

	private Mesh mesh;

	private CombineInstance[] combineInstanceCache = new CombineInstance[3];

	private void Awake()
	{
		mesh = new Mesh();
		meshFilter.sharedMesh = mesh;
	}

	public void UpdateGeometry(float height)
	{
		Vector3 localScale = new Vector3(autoTable.interpolationRatio, 1f, autoTable.interpolationRatio);
		base.transform.localScale = localScale;
		float num = ((autoTable.transform.lossyScale.y == 0f) ? 0f : (height / autoTable.transform.lossyScale.y));
		UpdateMesh(num);
		tableCollider.transform.localPosition = new Vector3(0f, (0f - num) * 0.5f - 0.001f, 0f);
		tableCollider.transform.localScale = new Vector3(1f, num, 1f);
		shadowTransform.transform.localPosition = new Vector3(0f, 0f - num, 0f);
	}

	private void UpdateMesh(float height)
	{
		mesh.Clear();
		float num = topSourceMesh.bounds.size.z * 100f;
		float num2 = bottomSourceMesh.bounds.size.z * 100f;
		height = Mathf.Max(height, num + num2);
		Quaternion q = Quaternion.AngleAxis(-90f, Vector3.right);
		CombineInstance combineInstance = default(CombineInstance);
		combineInstance.mesh = topSourceMesh;
		combineInstance.transform = Matrix4x4.TRS(new Vector3(0f, 0f, 0f), q, Vector3.one) * Matrix4x4.Scale(new Vector3(100f, 100f, 100f));
		CombineInstance combineInstance2 = combineInstance;
		combineInstance = default(CombineInstance);
		combineInstance.mesh = bottomSourceMesh;
		combineInstance.transform = Matrix4x4.TRS(new Vector3(0f, 0f - height, 0f), q, Vector3.one) * Matrix4x4.Scale(new Vector3(100f, 100f, 100f));
		CombineInstance combineInstance3 = combineInstance;
		combineInstance = default(CombineInstance);
		combineInstance.mesh = middleSourceMesh;
		combineInstance.transform = Matrix4x4.TRS(new Vector3(0f, (0f - height) / 2f, 0f), q, Vector3.one) * Matrix4x4.Scale(new Vector3(100f, 100f, 100f * (height - num - num2)));
		CombineInstance combineInstance4 = combineInstance;
		combineInstanceCache[0] = combineInstance2;
		combineInstanceCache[1] = combineInstance3;
		combineInstanceCache[2] = combineInstance4;
		mesh.CombineMeshes(combineInstanceCache, mergeSubMeshes: true, useMatrices: true);
	}
}
}
