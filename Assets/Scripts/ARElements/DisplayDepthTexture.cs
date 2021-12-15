using UnityEngine;
using UnityEngine.UI;

namespace ARElements{

[RequireComponent(typeof(RawImage))]
public class DisplayDepthTexture : MonoBehaviour
{
	public ShadowMapController shadowMapController;

	private RawImage m_RawImage;

	private void Start()
	{
		m_RawImage = GetComponent<RawImage>();
	}

	private void Update()
	{
		if (!(shadowMapController == null) && !(shadowMapController.shadowMap == null))
		{
			m_RawImage.texture = shadowMapController.shadowMap;
		}
	}
}
}
