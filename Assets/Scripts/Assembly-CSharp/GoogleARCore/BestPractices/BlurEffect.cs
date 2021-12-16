using UnityEngine;

namespace GoogleARCore.BestPractices{

[ExecuteInEditMode]
public class BlurEffect : MonoBehaviour
{
	public int initialDownSample = 1;

	public float blurSize;

	public Color tintColor = Color.white;

	private RenderTexture bluredTexture;

	private RenderTexture bluredTextureSwap;

	private Material blurMaterial;

	private Material mipBlitMaterial;

	private Material tintMaterial;

	private int mipMapCount;

	private void OnEnable()
	{
		blurMaterial = new Material(Shader.Find("Hidden/ARCoreBestPractices/SeparableBlur"));
		blurMaterial.hideFlags = HideFlags.DontSave;
		mipBlitMaterial = new Material(Shader.Find("Hidden/ARCoreBestPractices/MipBlit"));
		mipBlitMaterial.hideFlags = HideFlags.DontSave;
		tintMaterial = new Material(Shader.Find("Hidden/ARCoreBestPractices/Tint"));
		tintMaterial.hideFlags = HideFlags.DontSave;
	}

	private void OnDisable()
	{
		if ((bool)bluredTexture)
		{
			Object.DestroyImmediate(bluredTexture);
		}
		if ((bool)bluredTextureSwap)
		{
			Object.DestroyImmediate(bluredTextureSwap);
		}
		if ((bool)blurMaterial)
		{
			Object.DestroyImmediate(blurMaterial);
		}
		if ((bool)mipBlitMaterial)
		{
			Object.DestroyImmediate(mipBlitMaterial);
		}
		if ((bool)tintMaterial)
		{
			Object.DestroyImmediate(tintMaterial);
		}
	}

	private void OnRenderImage(RenderTexture source, RenderTexture destination)
	{
		if (blurSize <= 0f)
		{
			Graphics.Blit(source, destination);
			return;
		}
		ValidateTextures(source);
		RenderTexture active = RenderTexture.active;
		bluredTextureSwap.DiscardContents();
		Graphics.Blit(source, bluredTextureSwap);
		bluredTexture.DiscardContents();
		if ((tintColor.r != 1f || tintColor.g != 1f || tintColor.b != 1f) && tintColor.a != 0f)
		{
			tintMaterial.SetColor("_Color", tintColor);
			Graphics.Blit(bluredTextureSwap, bluredTexture, tintMaterial);
		}
		else
		{
			Graphics.Blit(bluredTextureSwap, bluredTexture);
		}
		int value = Mathf.FloorToInt(blurSize);
		value = Mathf.Clamp(value, 0, mipMapCount);
		float num = blurSize - (float)value;
		for (int i = 0; i < mipMapCount && i <= value; i++)
		{
			float num2 = 1f;
			if (i == value)
			{
				num2 = num;
			}
			if (i > 0)
			{
				BlitIntoMipLevel(bluredTextureSwap, bluredTexture, i - 1, i);
			}
			if (num2 > 0f)
			{
				BlurMipMap(i, 2f * num2);
				BlurMipMap(i, 1f * num2);
			}
			BlitIntoMipLevel(bluredTexture, bluredTextureSwap, i, i);
		}
		RenderTexture.active = active;
		mipBlitMaterial.SetFloat("_MipLevel", value);
		Graphics.Blit(bluredTexture, destination, mipBlitMaterial);
	}

	private void BlitIntoMipLevel(RenderTexture source, RenderTexture target, int sourceMipLevel, int destMipLevel)
	{
		mipBlitMaterial.SetFloat("_MipLevel", sourceMipLevel);
		target.DiscardContents();
		Graphics.SetRenderTarget(target, destMipLevel);
		Graphics.Blit(source, mipBlitMaterial);
	}

	private void BlurMipMap(int mipLevel, float size)
	{
		int num = (int)Mathf.Pow(2f, mipLevel);
		int num2 = bluredTexture.width / num;
		int num3 = bluredTexture.height / num;
		blurMaterial.SetFloat("_MipLevel", mipLevel);
		bluredTextureSwap.DiscardContents();
		blurMaterial.SetVector("_BlurVector", new Vector4(1f / (float)num2 * size, 0f));
		Graphics.SetRenderTarget(bluredTextureSwap, mipLevel);
		Graphics.Blit(bluredTexture, blurMaterial);
		bluredTexture.DiscardContents();
		blurMaterial.SetVector("_BlurVector", new Vector4(0f, 1f / (float)num3 * size));
		Graphics.SetRenderTarget(bluredTexture, mipLevel);
		Graphics.Blit(bluredTextureSwap, blurMaterial);
	}

	private void ValidateTextures(RenderTexture source)
	{
		int num = source.width / initialDownSample;
		int num2 = source.height / initialDownSample;
		bool flag = !bluredTexture;
		if (!flag && (bluredTexture.width != num || bluredTexture.height != num2))
		{
			flag = true;
		}
		if (flag)
		{
			if ((bool)bluredTexture)
			{
				Object.DestroyImmediate(bluredTexture);
				Object.DestroyImmediate(bluredTextureSwap);
			}
			bluredTexture = new RenderTexture(num, num2, 0, source.format);
			bluredTexture.useMipMap = true;
			bluredTexture.autoGenerateMips = false;
			bluredTexture.hideFlags = HideFlags.DontSave;
			bluredTextureSwap = new RenderTexture(num, num2, 0, source.format);
			bluredTextureSwap.useMipMap = true;
			bluredTextureSwap.autoGenerateMips = false;
			bluredTexture.hideFlags = HideFlags.DontSave;
			mipMapCount = 1 + Mathf.FloorToInt(Mathf.Log(Mathf.Max(num, num2), 2f));
		}
	}
}
}
