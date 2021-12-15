using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

public class PatternChooser : MonoBehaviour
{
	public List<Material> materials;

	public GameObject target;

	public float tweenDuration = 0.33f;

	private bool m_isTransitioning;

	private Material m_DestMaterial;

	private Material m_SrcMaterial;

	private float m_startTime;

	private void Start()
	{
		populateDropdown();
		m_SrcMaterial = materials[0];
	}

	private void Update()
	{
		if (m_isTransitioning)
		{
			float num = Time.time - m_startTime;
			float num2 = num / tweenDuration;
			if (num2 > 1f)
			{
				num2 = 1f;
				m_isTransitioning = false;
				m_SrcMaterial = m_DestMaterial;
			}
			MeshRenderer component = target.GetComponent<MeshRenderer>();
			Material material = component.material;
			if (num2 > 0.5f)
			{
				material.shader = m_DestMaterial.shader;
			}
			Vector4 vector = material.GetVector("_FocalPointPosition");
			m_DestMaterial.SetVector("_FocalPointPosition", vector);
			material.Lerp(m_SrcMaterial, m_DestMaterial, num2 * num2);
		}
	}

	private void populateDropdown()
	{
		Dropdown component = GetComponent<Dropdown>();
		component.ClearOptions();
		List<string> list = new List<string>();
		foreach (Material material in materials)
		{
			list.Add(material.name);
		}
		component.AddOptions(list);
	}

	public void changeMaterial()
	{
		Dropdown component = GetComponent<Dropdown>();
		MeshRenderer component2 = target.GetComponent<MeshRenderer>();
		m_DestMaterial = materials[component.value];
		Vector4 vector = component2.material.GetVector("_FocalPointPosition");
		m_SrcMaterial.SetVector("_FocalPointPosition", vector);
		m_startTime = Time.time;
		m_isTransitioning = true;
	}
}
}
