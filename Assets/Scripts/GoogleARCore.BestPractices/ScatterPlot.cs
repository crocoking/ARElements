using System;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ScatterPlot : MonoBehaviour
{
	private MeshFilter _meshFilter;

	private MeshRenderer _meshRenderer;

	private Mesh mesh;

	public int xSize = 10;

	public int zSize = 10;

	public Color highColor = Color.white;

	public Color lowColor = Color.white;

	public TextAsset dataAsset;

	private float[,] processedData;

	private Vector3[] verticesCache;

	private Color[] colorsCache;

	private Vector3[] normalCache;

	private int[] indicesCache;

	public MeshFilter meshFilter => (!_meshFilter) ? (_meshFilter = base.gameObject.GetComponent<MeshFilter>()) : _meshFilter;

	public MeshRenderer meshRenderer => (!_meshRenderer) ? (_meshRenderer = base.gameObject.GetComponent<MeshRenderer>()) : _meshRenderer;

	private void Awake()
	{
		if (!base.enabled)
		{
			return;
		}
		mesh = new Mesh();
		byte[] bytes = dataAsset.bytes;
		float[] array = new float[bytes.Length / 4];
		Buffer.BlockCopy(bytes, 0, array, 0, bytes.Length);
		float[,] array2 = new float[366, 24];
		float num = 0f;
		for (int i = 0; i < 366; i++)
		{
			int num2 = i * 24;
			for (int j = 0; j < 24; j++)
			{
				int num3 = num2 + j;
				float num4 = array[num3];
				if (num4 > 60f)
				{
					num4 = num;
				}
				int num5 = (j + 24 - 8) % 24;
				array2[i, num5] = num4;
				num = num4;
			}
		}
		processedData = new float[52, 24];
		float[] array3 = new float[24];
		for (int k = 0; k < 52; k++)
		{
			int num6 = k * 7;
			for (int l = 0; l < 24; l++)
			{
				array3[l] = 0f;
			}
			for (int m = 0; m < 7; m++)
			{
				int num7 = num6 + m;
				for (int n = 0; n < 24; n++)
				{
					array3[n] += array2[num7, n];
				}
			}
			for (int num8 = 0; num8 < 24; num8++)
			{
				array3[num8] /= 7f;
				processedData[k, num8] = array3[num8];
			}
		}
	}

	private void Start()
	{
		RebuildMesh();
	}

	private void OnDrawGizmosSelected()
	{
		Gizmos.matrix = base.transform.localToWorldMatrix;
		Gizmos.DrawWireCube(new Vector3(0.5f, 0.5f, 0.5f), Vector3.one);
	}

	private void RebuildMesh()
	{
		mesh.Clear();
		int num = xSize * zSize * 4 * 6;
		int num2 = xSize * zSize * 36;
		if (verticesCache == null || verticesCache.Length != num)
		{
			verticesCache = new Vector3[num];
			colorsCache = new Color[num];
			normalCache = new Vector3[num];
			indicesCache = new int[num2];
		}
		for (int i = 0; i < xSize; i++)
		{
			for (int j = 0; j < zSize; j++)
			{
				BuildColumn(i, j);
			}
		}
		mesh.vertices = verticesCache;
		mesh.colors = colorsCache;
		mesh.normals = normalCache;
		mesh.triangles = indicesCache;
		mesh.bounds = new Bounds(new Vector3(0.5f, 0.5f, 0.5f), Vector3.one);
		meshFilter.sharedMesh = mesh;
	}

	private void BuildColumn(int x, int z)
	{
		Vector3 vector = new Vector3(1f / (float)xSize, 0f, 1f / (float)zSize);
		Vector3 vector2 = Vector3.Scale(new Vector3(x, 0f, z), vector);
		float num = 1f;
		Vector3 vector3 = vector * num;
		Vector3 vector4 = vector2 + vector * (1f - num) / 2f;
		float num2 = 0f;
		num2 = processedData[x, z];
		num2 += 5f;
		num2 /= 35f;
		float num3 = 0f;
		float num4 = num2 - num3;
		Color color = Color.Lerp(lowColor, highColor, num2);
		Color color2 = color;
		Color color3 = lowColor;
		Vector3 vector5 = vector4;
		Vector3 vector6 = vector4 + new Vector3(0f, 0f, vector3.z);
		Vector3 vector7 = vector4 + new Vector3(vector3.x, 0f, vector3.z);
		Vector3 vector8 = vector4 + new Vector3(vector3.x, 0f, 0f);
		int num5 = (x + z * xSize) * 4 * 6;
		int num6 = (x + z * xSize) * 36;
		vector5.y += num3;
		vector6.y += num3;
		vector7.y += num3;
		vector8.y += num3;
		Vector3 vector9 = vector5;
		Vector3 vector10 = vector6;
		Vector3 vector11 = vector7;
		Vector3 vector12 = vector8;
		vector9.y += num4;
		vector10.y += num4;
		vector11.y += num4;
		vector12.y += num4;
		int num7 = num5;
		verticesCache[num7] = vector8;
		colorsCache[num7] = color3;
		ref Vector3 reference = ref normalCache[num7];
		reference = Vector3.down;
		verticesCache[num7 + 1] = vector7;
		colorsCache[num7 + 1] = color3;
		ref Vector3 reference2 = ref normalCache[num7 + 1];
		reference2 = Vector3.down;
		verticesCache[num7 + 2] = vector6;
		colorsCache[num7 + 2] = color3;
		ref Vector3 reference3 = ref normalCache[num7 + 2];
		reference3 = Vector3.down;
		verticesCache[num7 + 3] = vector5;
		colorsCache[num7 + 3] = color3;
		ref Vector3 reference4 = ref normalCache[num7 + 3];
		reference4 = Vector3.down;
		num7 += 4;
		verticesCache[num7] = vector9;
		colorsCache[num7] = color2;
		ref Vector3 reference5 = ref normalCache[num7];
		reference5 = Vector3.up;
		verticesCache[num7 + 1] = vector10;
		colorsCache[num7 + 1] = color2;
		ref Vector3 reference6 = ref normalCache[num7 + 1];
		reference6 = Vector3.up;
		verticesCache[num7 + 2] = vector11;
		colorsCache[num7 + 2] = color2;
		ref Vector3 reference7 = ref normalCache[num7 + 2];
		reference7 = Vector3.up;
		verticesCache[num7 + 3] = vector12;
		colorsCache[num7 + 3] = color2;
		ref Vector3 reference8 = ref normalCache[num7 + 3];
		reference8 = Vector3.up;
		num7 += 4;
		verticesCache[num7] = vector6;
		colorsCache[num7] = color3;
		ref Vector3 reference9 = ref normalCache[num7];
		reference9 = Vector3.forward;
		verticesCache[num7 + 1] = vector7;
		colorsCache[num7 + 1] = color3;
		ref Vector3 reference10 = ref normalCache[num7 + 1];
		reference10 = Vector3.forward;
		verticesCache[num7 + 2] = vector11;
		colorsCache[num7 + 2] = color2;
		ref Vector3 reference11 = ref normalCache[num7 + 2];
		reference11 = Vector3.forward;
		verticesCache[num7 + 3] = vector10;
		colorsCache[num7 + 3] = color2;
		ref Vector3 reference12 = ref normalCache[num7 + 3];
		reference12 = Vector3.forward;
		num7 += 4;
		verticesCache[num7] = vector8;
		colorsCache[num7] = color3;
		ref Vector3 reference13 = ref normalCache[num7];
		reference13 = Vector3.back;
		verticesCache[num7 + 1] = vector5;
		colorsCache[num7 + 1] = color3;
		ref Vector3 reference14 = ref normalCache[num7 + 1];
		reference14 = Vector3.back;
		verticesCache[num7 + 2] = vector9;
		colorsCache[num7 + 2] = color2;
		ref Vector3 reference15 = ref normalCache[num7 + 2];
		reference15 = Vector3.back;
		verticesCache[num7 + 3] = vector12;
		colorsCache[num7 + 3] = color2;
		ref Vector3 reference16 = ref normalCache[num7 + 3];
		reference16 = Vector3.back;
		num7 += 4;
		verticesCache[num7] = vector7;
		colorsCache[num7] = color3;
		ref Vector3 reference17 = ref normalCache[num7];
		reference17 = Vector3.right;
		verticesCache[num7 + 1] = vector8;
		colorsCache[num7 + 1] = color3;
		ref Vector3 reference18 = ref normalCache[num7 + 1];
		reference18 = Vector3.right;
		verticesCache[num7 + 2] = vector12;
		colorsCache[num7 + 2] = color2;
		ref Vector3 reference19 = ref normalCache[num7 + 2];
		reference19 = Vector3.right;
		verticesCache[num7 + 3] = vector11;
		colorsCache[num7 + 3] = color2;
		ref Vector3 reference20 = ref normalCache[num7 + 3];
		reference20 = Vector3.right;
		num7 += 4;
		verticesCache[num7] = vector5;
		colorsCache[num7] = color3;
		ref Vector3 reference21 = ref normalCache[num7];
		reference21 = Vector3.left;
		verticesCache[num7 + 1] = vector6;
		colorsCache[num7 + 1] = color3;
		ref Vector3 reference22 = ref normalCache[num7 + 1];
		reference22 = Vector3.left;
		verticesCache[num7 + 2] = vector10;
		colorsCache[num7 + 2] = color2;
		ref Vector3 reference23 = ref normalCache[num7 + 2];
		reference23 = Vector3.left;
		verticesCache[num7 + 3] = vector9;
		colorsCache[num7 + 3] = color2;
		ref Vector3 reference24 = ref normalCache[num7 + 3];
		reference24 = Vector3.left;
		for (int i = 0; i < 6; i++)
		{
			if (i != 3)
			{
			}
			int num8 = i * 6;
			int num9 = i * 4;
			indicesCache[num6 + num8] = num5 + num9;
			indicesCache[num6 + num8 + 1] = num5 + num9 + 1;
			indicesCache[num6 + num8 + 2] = num5 + num9 + 2;
			indicesCache[num6 + num8 + 3] = num5 + num9 + 2;
			indicesCache[num6 + num8 + 4] = num5 + num9 + 3;
			indicesCache[num6 + num8 + 5] = num5 + num9;
		}
	}
}
}
