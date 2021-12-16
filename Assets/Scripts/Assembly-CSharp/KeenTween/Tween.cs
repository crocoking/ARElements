using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using UnityEngine;

namespace KeenTween
{

	public class Tween
	{
		public enum TweenUpdateMode
		{
			Update,
			FixedUpdate
		}

		public enum TweenLoopMode
		{
			None,
			Loop,
			PingPong
		}

		public delegate void OnTweenStartCallback(Tween tween);

		public delegate void OnTweenTickDelegate(Tween tween);

		public delegate void OnTweenFinishCallback(Tween tween);

		private static List<Tween> tweens;

		private static CurveLinear defaultCurve;

		private float delayCounter;

		public List<Tween> childList = new List<Tween>();

		public TweenLoopMode loopMode { get; set; }

		public float from { get; set; }

		public float to { get; set; }

		public float length { get; set; }

		public float delay { get; set; }

		public TweenCurve curve { get; set; }

		public ReadOnlyCollection<Tween> children { get; private set; }

		public float currentTime { get; set; }

		public float currentPosition => Mathf.Clamp01(currentTime / length);

		public float currentValue
		{
			get
			{
				TweenCurve tweenCurve = ((curve == null) ? defaultCurve : curve);
				return Mathf.LerpUnclamped(from, to, tweenCurve.Sample(currentPosition));
			}
		}

		public bool isDone { get; private set; }

		public event OnTweenTickDelegate onTick;

		public event OnTweenFinishCallback onFinish;

		static Tween()
		{
			tweens = new List<Tween>();
			defaultCurve = new CurveLinear(TweenCurveMode.InOut);
			TweenTicker.ValidateInstance();
		}

		public Tween(Tween parent, float from, float to, float length, TweenCurve curve = null, OnTweenTickDelegate onTick = null)
		{
			children = new ReadOnlyCollection<Tween>(childList);
			this.from = from;
			this.to = to;
			this.length = length;
			this.curve = curve;
			if (onTick != null)
			{
				this.onTick += onTick;
			}
			if (parent == null)
			{
				tweens.Add(this);
			}
			else
			{
				parent.childList.Add(this);
			}
		}

		private bool OnTick()
		{
			try
			{
				if (this.onTick != null)
				{
					this.onTick(this);
				}
			}
			catch (Exception exception)
			{
				Debug.LogException(exception);
				return false;
			}
			return true;
		}

		private bool OnFinish()
		{
			try
			{
				if (this.onFinish != null)
				{
					this.onFinish(this);
				}
			}
			catch (Exception exception)
			{
				Debug.LogException(exception);
				return false;
			}
			return true;
		}

		private void TickInstance(float deltaTime)
		{
			if (isDone)
			{
				return;
			}
			if (delay > 0f)
			{
				delayCounter += deltaTime;
				if (delayCounter < delay)
				{
					return;
				}
			}
			currentTime += deltaTime;
			if (!OnTick())
			{
				Cancel();
			}
			if (currentTime >= length)
			{
				Finish();
			}
		}

		public void Cancel()
		{
			currentTime = 1f;
			isDone = true;
		}

		public void Finish()
		{
			OnFinish();
			Cancel();
			foreach (Tween child in childList)
			{
				tweens.Add(child);
			}
			childList.Clear();
		}

		public static void Tick(float deltaTime)
		{
			for (int i = 0; i < tweens.Count; i++)
			{
				Tween tween = tweens[i];
				tween.TickInstance(deltaTime);
				if (tween.isDone)
				{
					tweens.RemoveAt(i);
					i--;
				}
			}
		}

		public static void Clear()
		{
			tweens.Clear();
		}
	}
}
