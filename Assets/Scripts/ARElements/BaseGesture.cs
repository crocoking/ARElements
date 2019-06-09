using System;
using System.Diagnostics;
using UnityEngine;

namespace ARElements
{
    public abstract class BaseGesture
    {
        public BaseGesture(BaseGestureRecognizer recognizer)
        {
            Recognizer = recognizer;
        }

        //[DebuggerBrowsable(DebuggerBrowsableState.Never)]
        public event Action<BaseGesture> onStart;

        public event Action<BaseGesture> onUpdated;

        public event Action<BaseGesture> onFinished;

        public bool hasStarted { get; private set; }

        public bool justStarted { get; private set; }

        public bool hasFinished { get; private set; }

        public bool wasCancelled { get; private set; }

        public GameObject targetObject { get; private set; }

        protected BaseGestureRecognizer Recognizer { get; private set; }

        public void Update()
        {
            if(!hasStarted && CanStart())
            {
                Start();
                return;
            }
            justStarted = false;
            if(hasStarted && UpdateGesture() && onUpdated != null)
            {
                onUpdated(this);
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
            
        }

        protected void Complete()
        {
            hasFinished = true;
            if(hasStarted)
            {
                OnFinish();
                if(onFinished != null)
                {
                    onFinished(this);
                }
            }
        }

        private void Start()
        {
            hasStarted = true;
            justStarted = true;
            OnStart();
            if(onStart != null)
            {
                onStart(this);
            }
        }

    }
}
