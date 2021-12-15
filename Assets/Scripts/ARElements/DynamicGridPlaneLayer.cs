using System.Collections.Generic;
using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(MeshRenderer))]
public class DynamicGridPlaneLayer : PlaneLayer
{
	public override string layerType => "DynamicGridPlaneLayer";

	public override bool shouldRender
	{
		get
		{
			Material sharedMaterial = base.meshRenderer.sharedMaterial;
			return sharedMaterial.GetFloat("_Visibility") > 0f;
		}
	}

	public override void UpdateMesh(Mesh m)
	{
		base.UpdateMesh(m);
		List<Vector3> boundaryPoints = plane.boundaryPoints;
		Vector4[] array = new Vector4[boundaryPoints.Count];
		for (int i = 0; i < array.Length; i++)
		{
			ref Vector4 reference = ref array[i];
			reference = new Vector4(boundaryPoints[i].x, boundaryPoints[i].y, boundaryPoints[i].z);
		}
		if (array.Length > 0)
		{
			Vector2 corner = new Vector2(plane.position.x - plane.size.x * 0.5f, plane.position.z - plane.size.y * 0.5f);
			PerimeterEvaluation component = GetComponent<PerimeterEvaluation>();
			component.UpdateTexture(array, corner, plane.size);
			MaterialPropertyBlock materialPropertyBlock = new MaterialPropertyBlock();
			materialPropertyBlock.SetVector("_Bounds", new Vector4(corner.x, corner.y, plane.size.x, plane.size.y));
			materialPropertyBlock.SetTexture("_PerimeterDist", component.texture);
			base.meshRenderer.SetPropertyBlock(materialPropertyBlock);
		}
	}
}
}
