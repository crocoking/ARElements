using KeenTween;
using UnityEngine;
using UnityEngine.Playables;

namespace GoogleARCore.BestPractices{

public class PauseTimelineOnInfoExpand : MonoBehaviour
{
	public PlayableDirector playableDirector;

	public float transitionTime = 0.5f;

	private Tween tween;

	private void OnEnable()
	{
		SceneArea.current?.infoCard?.onExpandChanged?.AddListener(OnInfoCardExpandChanged);
	}

	private void OnDisable()
	{
		SceneArea.current?.infoCard?.onExpandChanged?.RemoveListener(OnInfoCardExpandChanged);
	}

	private void OnInfoCardExpandChanged(bool isExpanded)
	{
		float num = ((!isExpanded) ? 1 : 0);
		if (tween != null && !tween.isDone)
		{
			tween.Cancel();
			tween = null;
		}
		if (transitionTime > 0f)
		{
			float from = (float)playableDirector.playableGraph.GetRootPlayable(0).GetSpeed();
			tween = new Tween(null, from, num, transitionTime, new CurveCubic(TweenCurveMode.Out), delegate(Tween t)
			{
				if ((bool)playableDirector)
				{
					playableDirector.playableGraph.GetRootPlayable(0).SetSpeed(t.currentValue);
				}
			});
		}
		else
		{
			playableDirector.playableGraph.GetRootPlayable(0).SetSpeed(num);
		}
	}
}
}
