using System;
using UnityEngine;

namespace ARElements
{

	public abstract class BaseGesture
	{
		public bool hasStarted { get; private set; }

		public bool justStarted { get; private set; }

		public bool hasFinished { get; private set; }

		public bool wasCancelled { get; private set; }

		public GameObject targetObject { get; protected set; }

		protected BaseGestureRecognizer Recognizer { get; private set; }

		public event Action<BaseGesture> onStart;

		public event Action<BaseGesture> onUpdated;

		public event Action<BaseGesture> onFinished;

		public BaseGesture(BaseGestureRecognizer recognizer)
		{
			Recognizer = recognizer;
		}

		public void Update()
		{
			if (!hasStarted && CanStart())
			{
				Start();
				return;
			}
			justStarted = false;
			if (hasStarted && UpdateGesture() && this.onUpdated != null)
			{
				this.onUpdated(this);
			}
		}

		protected abstract bool CanStart();

		protected abstract void OnStart();

		protected abstract bool UpdateGesture();

		protected abstract void OnCancel();

		protected abstract void OnFinish();

		public void Cancel()
		{
			wasCancelled = true;
			OnCancel();
			Complete();
		}

		protected void Complete()
		{
			hasFinished = true;
			if (hasStarted)
			{
				OnFinish();
				if (this.onFinished != null)
				{
					this.onFinished(this);
				}
			}
		}

		private void Start()
		{
			hasStarted = true;
			justStarted = true;
			OnStart();
			if (this.onStart != null)
			{
				this.onStart(this);
			}
		}
	}
}
