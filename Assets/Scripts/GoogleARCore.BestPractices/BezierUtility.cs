using UnityEngine;

namespace GoogleARCore.BestPractices{

public static class BezierUtility
{
	public static Vector3 Bezier(Vector3 a, Vector3 b, Vector3 c, float ratio)
	{
		Vector3 a2 = Vector3.Lerp(a, b, ratio);
		Vector3 b2 = Vector3.Lerp(b, c, ratio);
		return Vector3.Lerp(a2, b2, ratio);
	}

	public static Vector3 BezierTangent(Vector3 a, Vector3 b, Vector3 c, float ratio)
	{
		Vector3 vector = Vector3.Lerp(a, b, ratio);
		Vector3 vector2 = Vector3.Lerp(b, c, ratio);
		return (vector2 - vector).normalized;
	}

	public static Vector3 BezierCubic(Vector3 a, Vector3 b, Vector3 c, Vector3 d, float ratio)
	{
		Vector3 a2 = Vector3.Lerp(a, b, ratio);
		Vector3 vector = Vector3.Lerp(b, c, ratio);
		Vector3 b2 = Vector3.Lerp(c, d, ratio);
		Vector3 a3 = Vector3.Lerp(a2, vector, ratio);
		Vector3 b3 = Vector3.Lerp(vector, b2, ratio);
		return Vector3.Lerp(a3, b3, ratio);
	}

	public static Vector3 BezierCubicTangent(Vector3 a, Vector3 b, Vector3 c, Vector3 d, float ratio)
	{
		Vector3 a2 = Vector3.Lerp(a, b, ratio);
		Vector3 vector = Vector3.Lerp(b, c, ratio);
		Vector3 b2 = Vector3.Lerp(c, d, ratio);
		Vector3 vector2 = Vector3.Lerp(a2, vector, ratio);
		Vector3 vector3 = Vector3.Lerp(vector, b2, ratio);
		return (vector3 - vector2).normalized;
	}
}
}
