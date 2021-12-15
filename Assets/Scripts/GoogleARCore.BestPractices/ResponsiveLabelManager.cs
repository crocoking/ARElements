using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class ResponsiveLabelManager : MonoBehaviour
{
	private static ResponsiveLabelManager _current;

	private static bool destroyed;

	private HashSet<ResponsiveLabel> responsiveLabels = new HashSet<ResponsiveLabel>();

	public static ResponsiveLabelManager current
	{
		get
		{
			if (!_current && !destroyed)
			{
				_current = new GameObject("ResponsiveLabelManager").AddComponent<ResponsiveLabelManager>();
				Object.DontDestroyOnLoad(_current.gameObject);
			}
			return _current;
		}
	}

	private void OnDestroy()
	{
		destroyed = true;
	}

	private void LateUpdate()
	{
		Camera main = Camera.main;
		ResponsiveLabel responsiveLabel = null;
		float num = float.NegativeInfinity;
		foreach (ResponsiveLabel responsiveLabel2 in responsiveLabels)
		{
			responsiveLabel2.MakeUnfocused();
			float num2 = Vector3.Distance(responsiveLabel2.transform.position, main.transform.position);
			float num3 = ((!(num2 > 0f)) ? float.PositiveInfinity : (1f / num2));
			Vector2 a = main.WorldToViewportPoint(responsiveLabel2.transform.position);
			float num4 = Vector2.Distance(a, new Vector2(0.5f, 0.5f));
			num4 = ((!(num4 > 0f)) ? float.PositiveInfinity : (1f / num4));
			float num5 = num3 + num4;
			if (num5 > num)
			{
				responsiveLabel = responsiveLabel2;
				num = num5;
			}
		}
		if ((bool)responsiveLabel)
		{
			responsiveLabel.MakeFocused();
		}
	}

	public void Register(ResponsiveLabel responsiveLabel)
	{
		responsiveLabels.Add(responsiveLabel);
	}

	public void Unregister(ResponsiveLabel responsiveLabel)
	{
		responsiveLabels.Remove(responsiveLabel);
	}
}
}
