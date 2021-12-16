using UnityEngine;

namespace ARElements{

public class TransformableItem : SelectableItem
{
	private ITransformationController[] m_CachedControllers;

	public override bool isBusy => isTransforming;

	public bool isTransforming
	{
		get
		{
			ITransformationController[] controllers = GetControllers();
			if (controllers == null)
			{
				return false;
			}
			foreach (ITransformationController transformationController in controllers)
			{
				if (transformationController.isTransforming)
				{
					return true;
				}
			}
			return false;
		}
	}

	public bool isTransformationFinishing
	{
		get
		{
			ITransformationController[] controllers = GetControllers();
			if (controllers == null)
			{
				return false;
			}
			foreach (ITransformationController transformationController in controllers)
			{
				if (transformationController.isTransformationFinishing)
				{
					return true;
				}
			}
			return false;
		}
	}

	public bool isTransformationValid
	{
		get
		{
			ITransformationController[] controllers = GetControllers();
			if (controllers == null)
			{
				return true;
			}
			foreach (ITransformationController transformationController in controllers)
			{
				if (!transformationController.isTransformationValid)
				{
					return false;
				}
			}
			return true;
		}
	}

	private ITransformationController[] GetControllers()
	{
		if (m_CachedControllers == null || m_CachedControllers.Length == 0)
		{
			m_CachedControllers = GetComponents<ITransformationController>();
		}
		return m_CachedControllers;
	}

	private Vector3 GetShadowPosition()
	{
		TranslationController component = GetComponent<TranslationController>();
		if (component == null)
		{
			return base.transform.position;
		}
		return component.FootprintPosition;
	}
}
}
