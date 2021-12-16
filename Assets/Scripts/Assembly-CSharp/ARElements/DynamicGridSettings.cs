using System.Reflection;
using UnityEngine;

namespace ARElements{

public class DynamicGridSettings
{
	public string presetName = "GridPreset";

	public float visibility = 1f;

	public float focalPointRadius;

	public float focalPointRange;

	public float focalPointFadePower = 1f;

	public float cellNumCorners;

	public float gridScale;

	public float geometryEdgeFadeWidth;

	public Color gridColorBase;

	public Color gridColorFocalPoint;

	public float colorMixFocalPoint;

	public Color gridColorEdge;

	public float colorMixEdge;

	public float cellScale;

	public float scaleFocalPoint;

	public float scaleFocalPointMix;

	public float scaleEdge;

	public float scaleEdgeMix;

	public float cellFill;

	public float cellFillFocalPoint;

	public float cellFillMixFocalPoint;

	public float cellFillEdge;

	public float cellFillMixEdge;

	public float occludeCornerBase;

	public float cellCornerOccludeFocalPoint;

	public float cellCornerOccludeMixFocalPoint;

	public float cellCornerOccludeEdge;

	public float cellCornerOccludeMixEdge;

	public float occludeEdgeBase;

	public float cellEdgeOccludeFocalPoint;

	public float cellEdgeOccludeMixFocalPoint;

	public float cellEdgeOccludeEdge;

	public float cellEdgeOccludeMixEdge;

	public static DynamicGridSettings Get(string name)
	{
		TextAsset textAsset = Resources.Load<TextAsset>("GridPresets/" + name);
		string text = textAsset.text;
		return JsonUtility.FromJson<DynamicGridSettings>(text);
	}

	public static DynamicGridSettings Lerp(DynamicGridSettings start, DynamicGridSettings end, float t)
	{
		DynamicGridSettings dynamicGridSettings = new DynamicGridSettings();
		FieldInfo[] fields = dynamicGridSettings.GetType().GetFields();
		FieldInfo[] array = fields;
		foreach (FieldInfo fieldInfo in array)
		{
			switch (fieldInfo.FieldType.Name)
			{
			case "Single":
			{
				float a3 = (float)fieldInfo.GetValue(start);
				float b3 = (float)fieldInfo.GetValue(end);
				fieldInfo.SetValue(dynamicGridSettings, Mathf.Lerp(a3, b3, t));
				break;
			}
			case "Vector3":
			{
				Vector3 a2 = (Vector3)fieldInfo.GetValue(start);
				Vector3 b2 = (Vector3)fieldInfo.GetValue(end);
				fieldInfo.SetValue(dynamicGridSettings, Vector3.Lerp(a2, b2, t));
				break;
			}
			case "Color":
			{
				Color a = (Color)fieldInfo.GetValue(start);
				Color b = (Color)fieldInfo.GetValue(end);
				fieldInfo.SetValue(dynamicGridSettings, Color.Lerp(a, b, t));
				break;
			}
			}
		}
		return dynamicGridSettings;
	}

	public void GetState(Material mat)
	{
		GetState(this, mat);
	}

	public static void GetState(DynamicGridSettings settings, Material mat)
	{
		FieldInfo[] fields = settings.GetType().GetFields();
		FieldInfo[] array = fields;
		foreach (FieldInfo fieldInfo in array)
		{
			switch (fieldInfo.FieldType.Name)
			{
			case "Single":
				fieldInfo.SetValue(settings, mat.GetFloat(ToShaderlabName(fieldInfo.Name)));
				break;
			case "Vector3":
				fieldInfo.SetValue(settings, (Vector3)mat.GetVector(ToShaderlabName(fieldInfo.Name)));
				break;
			case "Color":
				fieldInfo.SetValue(settings, mat.GetColor(ToShaderlabName(fieldInfo.Name)));
				break;
			}
		}
	}

	public void ApplyTo(Material mat)
	{
		FieldInfo[] fields = GetType().GetFields();
		FieldInfo[] array = fields;
		foreach (FieldInfo fieldInfo in array)
		{
			switch (fieldInfo.FieldType.Name)
			{
			case "Single":
				mat.SetFloat(ToShaderlabName(fieldInfo.Name), (float)fieldInfo.GetValue(this));
				break;
			case "Vector3":
				mat.SetVector(ToShaderlabName(fieldInfo.Name), (Vector3)fieldInfo.GetValue(this));
				break;
			case "Color":
				mat.SetColor(ToShaderlabName(fieldInfo.Name), (Color)fieldInfo.GetValue(this));
				break;
			}
		}
	}

	public static string ToCSharpName(string name)
	{
		name = name.Substring(1);
		string text = name.Substring(0, 1).ToLower();
		return text + name.Substring(1);
	}

	public static string ToShaderlabName(string name)
	{
		string text = name.Substring(0, 1).ToUpper();
		return "_" + text + name.Substring(1);
	}
}
}
