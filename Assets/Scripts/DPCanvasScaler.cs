using System;
using UnityEngine;
using UnityEngine.EventSystems;

[ExecuteInEditMode]
[AddComponentMenu("Layout/DP Canvas Scaler")]
[RequireComponent(typeof(Canvas))]
public class DPCanvasScaler : UIBehaviour
{
	[Tooltip("If a sprite has this 'Pixels Per Unit' setting, then one pixel in the sprite will cover one unit in the UI.")]
	[SerializeField]
	protected float m_ReferencePixelsPerUnit = 100f;

	private const float kLogBase = 2f;

	[SerializeField]
	[Tooltip("The DPI to assume if the screen DPI is not known.")]
	protected float m_FallbackScreenDPI = 96f;

	[Tooltip("The pixels per inch to use for sprites that have a 'Pixels Per Unit' setting that matches the 'Reference Pixels Per Unit' setting.")]
	[SerializeField]
	protected float m_DefaultSpriteDPI = 96f;

	[SerializeField]
	[Tooltip("The amount of pixels per unit to use for dynamically created bitmaps in the UI, such as Text.")]
	protected float m_DynamicPixelsPerUnit = 1f;

	private Canvas m_Canvas;

	[NonSerialized]
	private float m_PrevScaleFactor = 1f;

	[NonSerialized]
	private float m_PrevReferencePixelsPerUnit = 100f;

	public float referencePixelsPerUnit
	{
		get
		{
			return m_ReferencePixelsPerUnit;
		}
		set
		{
			m_ReferencePixelsPerUnit = value;
		}
	}

	public float fallbackScreenDPI
	{
		get
		{
			return m_FallbackScreenDPI;
		}
		set
		{
			m_FallbackScreenDPI = value;
		}
	}

	public float defaultSpriteDPI
	{
		get
		{
			return m_DefaultSpriteDPI;
		}
		set
		{
			m_DefaultSpriteDPI = value;
		}
	}

	public float dynamicPixelsPerUnit
	{
		get
		{
			return m_DynamicPixelsPerUnit;
		}
		set
		{
			m_DynamicPixelsPerUnit = value;
		}
	}

	protected DPCanvasScaler()
	{
	}

	protected override void OnEnable()
	{
		base.OnEnable();
		m_Canvas = GetComponent<Canvas>();
		Handle();
	}

	protected override void OnDisable()
	{
		SetScaleFactor(1f);
		SetReferencePixelsPerUnit(100f);
		base.OnDisable();
	}

	protected virtual void Update()
	{
		Handle();
	}

	protected virtual void Handle()
	{
		if (!(m_Canvas == null) && m_Canvas.isRootCanvas)
		{
			if (m_Canvas.renderMode == RenderMode.WorldSpace)
			{
				HandleWorldCanvas();
			}
			else
			{
				HandleConstantPhysicalSize();
			}
		}
	}

	protected virtual void HandleWorldCanvas()
	{
		SetScaleFactor(m_DynamicPixelsPerUnit);
		SetReferencePixelsPerUnit(m_ReferencePixelsPerUnit);
	}

	protected virtual void HandleConstantPhysicalSize()
	{
		float dpi = Screen.dpi;
		float num = ((dpi != 0f) ? dpi : m_FallbackScreenDPI);
		float num2 = 160f;
		SetScaleFactor(num / num2);
		SetReferencePixelsPerUnit(m_ReferencePixelsPerUnit * num2 / m_DefaultSpriteDPI);
	}

	protected void SetScaleFactor(float scaleFactor)
	{
		if (scaleFactor != m_PrevScaleFactor)
		{
			m_Canvas.scaleFactor = scaleFactor;
			m_PrevScaleFactor = scaleFactor;
		}
	}

	protected void SetReferencePixelsPerUnit(float referencePixelsPerUnit)
	{
		if (referencePixelsPerUnit != m_PrevReferencePixelsPerUnit)
		{
			m_Canvas.referencePixelsPerUnit = referencePixelsPerUnit;
			m_PrevReferencePixelsPerUnit = referencePixelsPerUnit;
		}
	}
}
