using System.Collections.Generic;
using KeenTween;
using UnityEngine;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class ReticleCycler : MonoBehaviour
{
	public List<Image> images = new List<Image>();

	public float cycleTime = 3f;

	public float blendTime = 0.5f;

	private int imageIndex;

	private float cycleCounter;

	private Tween blendTween;

	private void Start()
	{
		if (images.Count <= 0)
		{
			return;
		}
		foreach (Image image in images)
		{
			image.color = new Color(1f, 1f, 1f, 0f);
		}
		images[0].color = Color.white;
	}

	private void Update()
	{
		if (images.Count > 0)
		{
			cycleCounter += Time.deltaTime;
			if (cycleCounter >= cycleTime)
			{
				CreateBlendImage();
				cycleCounter = 0f;
			}
		}
	}

	private void CreateBlendImage()
	{
		Image previousImage = images[imageIndex];
		imageIndex = (imageIndex + 1) % images.Count;
		Image image = images[imageIndex];
		if (blendTween != null && !blendTween.isDone)
		{
			blendTween.Cancel();
		}
		blendTween = new Tween(null, 0f, 1f, blendTime, new CurveCubic(TweenCurveMode.InOut), delegate(Tween t)
		{
			if ((bool)image)
			{
				image.color = Color.Lerp(new Color(1f, 1f, 1f, 0f), Color.white, t.currentValue);
			}
			if ((bool)previousImage)
			{
				previousImage.color = Color.Lerp(Color.white, new Color(1f, 1f, 1f, 0f), t.currentValue);
			}
		});
	}
}
}
