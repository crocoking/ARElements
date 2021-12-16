using UnityEngine;

namespace ARElements{

[RequireComponent(typeof(TransformableItem))]
public abstract class BaseTransformationController<T> : CoordinatorReceiver, ITransformationController where T : BaseGesture
{
	private T m_ActiveGesture;

	protected TransformableItem Item { get; private set; }

	protected T ActiveGesture
	{
		get
		{
			return m_ActiveGesture;
		}
		set
		{
			if (m_ActiveGesture != value)
			{
				if (m_ActiveGesture != null)
				{
					m_ActiveGesture.onUpdated -= OnUpdated;
					m_ActiveGesture.onFinished -= OnFinished;
				}
				m_ActiveGesture = value;
				if (m_ActiveGesture != null)
				{
					m_ActiveGesture.onUpdated += OnUpdated;
					m_ActiveGesture.onFinished += OnFinished;
				}
			}
		}
	}

	public virtual bool isTransforming => ActiveGesture != null;

	public virtual bool isTransformationFinishing => false;

	public virtual bool isTransformationValid => true;

	protected virtual bool CanStartTransformationForGesture(T gesture)
	{
		return Item.isSelected;
	}

	protected virtual void OnStartTransformation(T gesture)
	{
	}

	protected abstract void OnContinueTransformation(T gesture);

	protected virtual void OnEndTransformation(T gesture)
	{
	}

	protected virtual void Awake()
	{
		Item = GetComponent<TransformableItem>();
		ConnectToRecognizer();
	}

	protected virtual void OnDestroy()
	{
		DisconnectFromRecognizer();
	}

	protected BaseGestureRecognizer GetRecognizer()
	{
		GestureCoordinator coordinator = GetCoordinator<GestureCoordinator>();
		if (coordinator == null)
		{
			return null;
		}
		return coordinator.GetGestureRecognizer<T>();
	}

	private void ConnectToRecognizer()
	{
		BaseGestureRecognizer recognizer = GetRecognizer();
		if (!(recognizer == null))
		{
			recognizer.onGestureStarted += OnGestureStarted;
		}
	}

	private void DisconnectFromRecognizer()
	{
		BaseGestureRecognizer recognizer = GetRecognizer();
		if (!(recognizer == null))
		{
			recognizer.onGestureStarted -= OnGestureStarted;
		}
	}

	private void OnGestureStarted(BaseGesture gesture)
	{
		T val = gesture as T;
		if (!isTransforming && CanStartTransformationForGesture(val))
		{
			ActiveGesture = val;
			OnStartTransformation(ActiveGesture);
		}
	}

	private void OnUpdated(BaseGesture gesture)
	{
		if (!Item.isSelected)
		{
			ActiveGesture = (T)null;
		}
		else
		{
			OnContinueTransformation(ActiveGesture);
		}
	}

	private void OnFinished(BaseGesture gesture)
	{
		OnEndTransformation(ActiveGesture);
		ActiveGesture = (T)null;
	}
}
}
