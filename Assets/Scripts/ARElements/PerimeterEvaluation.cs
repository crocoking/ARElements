using UnityEngine;

namespace ARElements
{

	public class PerimeterEvaluation : MonoBehaviour
	{
		public RenderTexture texture;

		public Material effectMaterialPrefab;

		public int resolution = 256;

		public Vector4[] perimeterVerts = new Vector4[4]
		{
		new Vector4(1f, 0f, 0f, 0f),
		new Vector4(0f, 0f, 1f, 0f),
		new Vector4(-1f, 0f, 0f, 0f),
		new Vector4(0f, 0f, -1f, 0f)
		};

		public Vector2 corner = new Vector2(-1f, -1f);

		public Vector2 size = new Vector2(2f, 2f);

		private void Awake()
		{
			if (effectMaterialPrefab == null)
			{
				Debug.LogError("effectMaterial must be set to the PerimeterEvaluation material.");
				return;
			}
			effectMaterialPrefab = new Material(effectMaterialPrefab);
			effectMaterialPrefab.SetVectorArray("_PerimeterVerts", new Vector4[128]);
			effectMaterialPrefab.SetFloat("_NumVerts", 0f);
			texture = new RenderTexture(resolution, resolution, 0, RenderTextureFormat.ARGB32, RenderTextureReadWrite.Linear);
			texture.name = "Perimiter Eval Local";
			texture.enableRandomWrite = true;
			texture.Create();
			UpdateTexture();
		}

		public void UpdateTexture()
		{
			UpdateTexture(perimeterVerts, corner, size);
		}

		public void UpdateTexture(Vector4[] perimeterVerts, Vector2 corner, Vector2 size)
		{
			this.perimeterVerts = perimeterVerts;
			this.corner = corner;
			this.size = size;
			Vector2 scale = new Vector2(1f / this.size.x, 1f / this.size.y);
			Vector4[] verts = OffsetVectors(this.perimeterVerts, corner);
			verts = ScaleVectors(verts, scale);
			effectMaterialPrefab.SetVectorArray("_PerimeterVerts", verts);
			effectMaterialPrefab.SetFloat("_NumVerts", verts.Length);
			texture.DiscardContents();
			RenderTexture active = RenderTexture.active;
			RenderTexture.active = texture;
			Graphics.Blit(null, texture, effectMaterialPrefab);
			RenderTexture.active = active;
		}

		private Vector4[] OffsetVectors(Vector4[] verts, Vector2 offset)
		{
			Vector4 vector = new Vector4(offset.x, 0f, offset.y, 0f);
			Vector4[] array = new Vector4[verts.Length];
			for (int i = 0; i < verts.Length; i++)
			{
				ref Vector4 reference = ref array[i];
				reference = verts[i] - vector;
			}
			return array;
		}

		private Vector4[] ScaleVectors(Vector4[] verts, Vector2 scale)
		{
			Vector4 b = new Vector4(scale.x, 0f, scale.y, 0f);
			Vector4[] array = new Vector4[verts.Length];
			for (int i = 0; i < verts.Length; i++)
			{
				ref Vector4 reference = ref array[i];
				reference = Vector4.Scale(verts[i], b);
			}
			return array;
		}
	}
}
