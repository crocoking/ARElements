using KeenTween;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class VolumetricTargetingReticle : MonoBehaviour
{
	public GameObject contents;

	public GameObject hologramRoot;

	public bool startInvisible;

	private Tween tween;

	private bool _visible;

	public bool visible
	{
		get
		{
			return _visible;
		}
		set
		{
			if (_visible == value)
			{
				return;
			}
			if (tween != null && !tween.isDone)
			{
				tween.Cancel();
			}
			_visible = value;
			if (_visible)
			{
				contents.SetActive(value: true);
				tween = new Tween(null, base.transform.localScale.x, 1f, 0.25f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
				{
					HologramRenderer.current.intensity = t.currentValue;
					base.transform.localScale = Vector3.one * t.currentValue;
				});
				HologramRenderer.current.ClearSceneRoots();
				HologramRenderer.current.AppendSceneRoot(hologramRoot.gameObject);
			}
			else
			{
				tween = new Tween(null, base.transform.localScale.x, 0f, 0.25f, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
				{
					HologramRenderer.current.intensity = t.currentValue;
					base.transform.localScale = Vector3.one * t.currentValue;
				});
				tween.onFinish += delegate
				{
					HologramRenderer.current.ClearSceneRoots();
					contents.SetActive(value: false);
				};
			}
		}
	}

	private void OnDisable()
	{
		HologramRenderer.current?.ClearSceneRoots();
	}

	private void Start()
	{
		if (startInvisible)
		{
			_visible = false;
			base.transform.localScale = Vector3.zero;
			contents.SetActive(value: false);
		}
	}
}
}
