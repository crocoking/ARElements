using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

public class FeaturePointLineSettings : MonoBehaviour
{
	public Slider minPointCount;

	private int m_MinPointCount;

	public Slider lineWidth;

	public Slider lineLength;

	public Slider lineSpeed;

	public Slider lineNum;

	public Text widthText;

	public Text lengthText;

	public Text speedText;

	public Text numText;

	private float m_LineWidth = 0.01f;

	private float m_LineLength = 1f;

	private float m_LineSpeed = 1.5f;

	private int m_LineNum = 3;

	[SerializeField]
	private FeaturePointLineVisualizer m_lineVisualizer;

	private void Start()
	{
		if (m_lineVisualizer == null)
		{
			m_lineVisualizer = Object.FindObjectOfType<FeaturePointLineVisualizer>();
		}
	}

	public void OnLineWidthChange()
	{
		m_LineWidth = lineWidth.value;
		widthText.text = m_LineWidth.ToString();
		m_lineVisualizer.SetWidth(m_LineWidth);
	}

	public void OnLineLengthChange()
	{
		m_LineLength = lineLength.value;
		lengthText.text = m_LineLength.ToString();
		m_lineVisualizer.SetLength(m_LineLength);
	}

	public void OnLineSpeedChange()
	{
		m_LineSpeed = lineSpeed.value;
		speedText.text = m_LineSpeed.ToString();
		m_lineVisualizer.SetSpeed(m_LineSpeed);
	}

	public void OnLineNumChange()
	{
		m_LineNum = (int)lineNum.value;
		numText.text = m_LineNum.ToString();
		m_lineVisualizer.SetNum(m_LineNum);
	}
}
}
