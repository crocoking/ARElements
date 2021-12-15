using UnityEngine;

namespace KeenTween
{

	public class TweenTicker : MonoBehaviour
	{
		private static TweenTicker instance;

		public static void ValidateInstance()
		{
			if (!instance)
			{
				instance = Object.FindObjectOfType<TweenTicker>();
				if (!instance)
				{
					instance = new GameObject("TweenTicker").AddComponent<TweenTicker>();
					Object.DontDestroyOnLoad(instance);
				}
			}
		}

		private void Update()
		{
			Tween.Tick(Time.deltaTime);
		}
	}
}
