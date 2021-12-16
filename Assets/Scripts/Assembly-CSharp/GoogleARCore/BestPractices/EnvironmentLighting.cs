using UnityEngine;
using UnityEngine.Rendering;

namespace GoogleARCore.BestPractices{

public class EnvironmentLighting : MonoBehaviour
{
	public struct SkyLightState
	{
		public Color skyColor;

		public Color equatorColor;

		public Color groundColor;

		public Color averageColor => (skyColor + equatorColor + groundColor) / 3f;

		public float averageBrightness
		{
			get
			{
				Color color = averageColor;
				return (color.r + color.g + color.b) / 3f;
			}
		}

		public void ApplyToScene()
		{
			RenderSettings.ambientMode = AmbientMode.Trilight;
			RenderSettings.ambientSkyColor = skyColor;
			RenderSettings.ambientEquatorColor = equatorColor;
			RenderSettings.ambientGroundColor = groundColor;
		}

		public static SkyLightState Lerp(SkyLightState a, SkyLightState b, float ratio)
		{
			SkyLightState result = default(SkyLightState);
			result.skyColor = Color.Lerp(a.skyColor, b.skyColor, ratio);
			result.equatorColor = Color.Lerp(a.equatorColor, b.equatorColor, ratio);
			result.groundColor = Color.Lerp(a.groundColor, b.groundColor, ratio);
			return result;
		}

		public static SkyLightState Pow(SkyLightState state, float power)
		{
			state.skyColor = ColorPow(state.skyColor, power);
			state.equatorColor = ColorPow(state.equatorColor, power);
			state.groundColor = ColorPow(state.groundColor, power);
			return state;
		}

		private static Color ColorPow(Color color, float power)
		{
			color.r = Mathf.Pow(color.r, power);
			color.g = Mathf.Pow(color.g, power);
			color.b = Mathf.Pow(color.b, power);
			return color;
		}

		public static SkyLightState Multiply(SkyLightState state, float scaler)
		{
			state.skyColor *= scaler;
			state.equatorColor *= scaler;
			state.groundColor *= scaler;
			return state;
		}

		public static SkyLightState Saturate(SkyLightState state, float saturation)
		{
			state.skyColor = SaturateColor(state.skyColor, saturation);
			state.equatorColor = SaturateColor(state.equatorColor, saturation);
			state.groundColor = SaturateColor(state.groundColor, saturation);
			return state;
		}

		private static Color SaturateColor(Color color, float saturation)
		{
			float b = (color.r + color.g + color.b) / 3f;
			color.r = Mathf.LerpUnclamped(color.r, b, saturation);
			color.g = Mathf.LerpUnclamped(color.g, b, saturation);
			color.b = Mathf.LerpUnclamped(color.b, b, saturation);
			return color;
		}

		public static SkyLightState MatchLuminosity(SkyLightState state, Color otherSkyColor, Color otherEquatorColor, Color otherGroundColor)
		{
			state.skyColor = MatchColorLuminosity(state.skyColor, otherSkyColor);
			state.equatorColor = MatchColorLuminosity(state.equatorColor, otherEquatorColor);
			state.groundColor = MatchColorLuminosity(state.groundColor, otherGroundColor);
			return state;
		}

		private static Color MatchColorLuminosity(Color color, Color color2)
		{
			float colorLuminosity = GetColorLuminosity(color2);
			color = SetColorLuminosity(color, colorLuminosity);
			return color;
		}

		private static Color SetColorLuminosity(Color color, float luminosity)
		{
			float colorLuminosity = GetColorLuminosity(color);
			if (colorLuminosity > 0f)
			{
				float num = luminosity / colorLuminosity;
				color.r *= num;
				color.g *= num;
				color.b *= num;
			}
			else
			{
				color.r = 0f;
				color.g = 0f;
				color.b = 0f;
			}
			return color;
		}

		private static float GetColorLuminosity(Color color)
		{
			return (color.r + color.g + color.b) / 3f;
		}
	}

	private static EnvironmentLighting _current;

	public bool showDebugTextures;

	[Range(0f, 1f)]
	public float matchSkyboxLuminocity;

	public float brightness = 1f;

	public float contributionWeightMin = 0.25f;

	public float adaptationRate = 5f;

	[ColorUsage(false, true)]
	public Color skyTint = Color.white;

	[ColorUsage(false, true)]
	public Color equatorTint = Color.white;

	[ColorUsage(false, true)]
	public Color groundTint = Color.white;

	private RenderTexture cameraTexture;

	private RenderTexture tinyTexture;

	private RenderTexture tinyTextureSwap;

	private RenderTexture finalRampTexture;

	private Texture2D finalRampReadTexture;

	private Material debugMaterial;

	private Material blurMaterial;

	private SkyLightState skyboxColorState;

	private bool needsTextureRead;

	private bool hasReadTexture;

	public static EnvironmentLighting current => _current ? _current : (_current = Object.FindObjectOfType<EnvironmentLighting>());

	public bool hasFirstSkyLightState { get; private set; }

	public SkyLightState currentSkyLightState { get; private set; }

	private void Awake()
	{
		cameraTexture = new RenderTexture(256, 256, 0, RenderTextureFormat.ARGBHalf);
		cameraTexture.useMipMap = true;
		cameraTexture.autoGenerateMips = true;
		cameraTexture.Create();
		tinyTexture = new RenderTexture(8, 8, 0, RenderTextureFormat.ARGBHalf);
		tinyTextureSwap = new RenderTexture(8, 8, 0, RenderTextureFormat.ARGBHalf);
		finalRampTexture = new RenderTexture(1, 8, 0, RenderTextureFormat.ARGBHalf);
		finalRampReadTexture = new Texture2D(1, 8, TextureFormat.RGBAHalf, mipChain: false);
		finalRampReadTexture.wrapMode = TextureWrapMode.Clamp;
		debugMaterial = new Material(Shader.Find("Hidden/BlitCopy"));
		blurMaterial = new Material(Shader.Find("Hidden/ARCoreBestPractices/SeparableBlur"));
		Cubemap cubemap = (Cubemap)RenderSettings.skybox.GetTexture("_Tex");
		skyboxColorState = default(SkyLightState);
		skyboxColorState.skyColor = GetCubemapFaceColor(cubemap, CubemapFace.PositiveY);
		skyboxColorState.equatorColor = GetCubemapFaceColor(cubemap, CubemapFace.PositiveX);
		skyboxColorState.equatorColor += GetCubemapFaceColor(cubemap, CubemapFace.NegativeX);
		skyboxColorState.equatorColor += GetCubemapFaceColor(cubemap, CubemapFace.PositiveZ);
		skyboxColorState.equatorColor += GetCubemapFaceColor(cubemap, CubemapFace.NegativeZ);
		skyboxColorState.equatorColor /= 4f;
		skyboxColorState.groundColor = GetCubemapFaceColor(cubemap, CubemapFace.NegativeY);
		Vector4 vector = RenderSettings.skybox.GetVector("_Tex_HDR");
		skyboxColorState.skyColor = DecodeHDR(skyboxColorState.skyColor, vector);
		skyboxColorState.equatorColor = DecodeHDR(skyboxColorState.equatorColor, vector);
		skyboxColorState.groundColor = DecodeHDR(skyboxColorState.groundColor, vector);
	}

	private void FixedUpdate()
	{
	}

	private void Update()
	{
		if (needsTextureRead)
		{
			RenderTexture active = RenderTexture.active;
			RenderTexture.active = finalRampTexture;
			finalRampReadTexture.ReadPixels(new Rect(0f, 0f, 1f, 8f), 0, 0, recalculateMipMaps: false);
			RenderTexture.active = active;
			hasReadTexture = true;
			needsTextureRead = false;
		}
		if (hasReadTexture)
		{
			Color black = Color.black;
			for (int i = 0; i < finalRampReadTexture.height; i++)
			{
				black += finalRampReadTexture.GetPixel(0, i);
			}
			black /= (float)finalRampReadTexture.height;
			float num = (black.r + black.g + black.b) / 3f;
			Camera main = Camera.main;
			float b = Mathf.Clamp(Vector3.Dot(Vector3.up, Camera.main.ViewportPointToRay(new Vector3(0.5f, 1f, 0f)).direction), 0f, 1f);
			float b2 = 1f - Mathf.Abs(Vector3.Dot(Vector3.up, Camera.main.ViewportPointToRay(new Vector3(0.5f, 0.5f, 0f)).direction));
			float b3 = Mathf.Clamp(Vector3.Dot(Vector3.down, Camera.main.ViewportPointToRay(new Vector3(0.5f, 0f, 0f)).direction), 0f, 1f);
			b = Mathf.Max(contributionWeightMin, b);
			b2 = Mathf.Max(contributionWeightMin, b2);
			b3 = Mathf.Max(contributionWeightMin, b3);
			SkyLightState skyLightState = default(SkyLightState);
			skyLightState.skyColor = finalRampReadTexture.GetPixelBilinear(0.5f, 1f);
			skyLightState.equatorColor = finalRampReadTexture.GetPixelBilinear(0.5f, 0.5f);
			skyLightState.groundColor = finalRampReadTexture.GetPixelBilinear(0.5f, 0f);
			SkyLightState skyLightState2 = skyLightState;
			skyLightState2.skyColor *= skyTint;
			skyLightState2.equatorColor *= equatorTint;
			skyLightState2.groundColor *= groundTint;
			float averageBrightness = skyboxColorState.averageBrightness;
			averageBrightness = Mathf.Max(averageBrightness, 0.0001f);
			SkyLightState skyLightState3 = SkyLightState.Multiply(skyboxColorState, 1f / averageBrightness * num * 1f);
			SkyLightState b4 = SkyLightState.MatchLuminosity(skyLightState2, skyLightState3.skyColor, skyLightState3.equatorColor, skyLightState3.groundColor);
			if (matchSkyboxLuminocity > 0f)
			{
				skyLightState2 = SkyLightState.Lerp(skyLightState2, b4, matchSkyboxLuminocity);
			}
			skyLightState2.skyColor = Color.Lerp(b4.skyColor, skyLightState2.skyColor, b * 4f);
			skyLightState2.equatorColor = Color.Lerp(b4.equatorColor, skyLightState2.equatorColor, b * 4f);
			skyLightState2.groundColor = Color.Lerp(b4.groundColor, skyLightState2.groundColor, b * 4f);
			skyLightState2 = SkyLightState.Multiply(skyLightState2, brightness);
			if (hasFirstSkyLightState)
			{
				float num2 = adaptationRate * Time.deltaTime;
				SkyLightState skyLightState4 = currentSkyLightState;
				skyLightState4.skyColor = Color.Lerp(skyLightState4.skyColor, skyLightState2.skyColor, num2 * Mathf.Clamp01(b + 0.025f));
				skyLightState4.equatorColor = Color.Lerp(skyLightState4.equatorColor, skyLightState2.equatorColor, num2 * Mathf.Clamp01(b2 + 0.025f));
				skyLightState4.groundColor = Color.Lerp(skyLightState4.groundColor, skyLightState2.groundColor, num2 * Mathf.Clamp01(b3 + 0.025f));
				currentSkyLightState = skyLightState4;
			}
			else
			{
				currentSkyLightState = skyLightState2;
				hasFirstSkyLightState = true;
			}
			currentSkyLightState.ApplyToScene();
		}
	}

	private void LateUpdate()
	{
		if (!needsTextureRead && Time.frameCount % 16 == 0)
		{
			CameraImageBLitter.Blit(cameraTexture, fixedOrientation: false);
			blurMaterial.SetVector("_ScreenSize", new Vector2(8f, 8f));
			blurMaterial.SetFloat("_MipLevel", 4f);
			tinyTextureSwap.DiscardContents();
			blurMaterial.SetVector("_BlurVector", new Vector2(1f, 0f) / 8f);
			Graphics.Blit(cameraTexture, tinyTextureSwap, blurMaterial);
			blurMaterial.SetFloat("_MipLevel", 0f);
			tinyTexture.DiscardContents();
			blurMaterial.SetVector("_BlurVector", new Vector2(0f, 1f) / 8f);
			Graphics.Blit(tinyTextureSwap, tinyTexture, blurMaterial);
			tinyTextureSwap.DiscardContents();
			blurMaterial.SetVector("_BlurVector", new Vector2(1f, 0f) / 8f);
			Graphics.Blit(tinyTexture, tinyTextureSwap, blurMaterial);
			tinyTexture.DiscardContents();
			blurMaterial.SetVector("_BlurVector", new Vector2(0f, 1f) / 8f);
			Graphics.Blit(tinyTextureSwap, tinyTexture, blurMaterial);
			finalRampTexture.DiscardContents();
			blurMaterial.SetVector("_ScreenSize", new Vector2(1f, 8f));
			blurMaterial.SetVector("_BlurVector", new Vector2(1f, 0f) / 8f);
			Graphics.Blit(tinyTexture, finalRampTexture, blurMaterial);
			needsTextureRead = true;
		}
	}

	private Color DecodeHDR(Color color, Vector4 decodeInstructions)
	{
		float num = decodeInstructions.w * (color.a - 1f) + 1f;
		if (QualitySettings.activeColorSpace == ColorSpace.Gamma)
		{
			float num2 = decodeInstructions.x * num;
			color.r *= num2;
			color.g *= num2;
			color.b *= num2;
		}
		else
		{
			color.r *= decodeInstructions.x;
			color.g *= decodeInstructions.x;
			color.b *= decodeInstructions.x;
		}
		return color;
	}

	private Color GetCubemapFaceColor(Cubemap cubemap, CubemapFace face)
	{
		Color[] pixels = cubemap.GetPixels(face, cubemap.mipmapCount - 1);
		return pixels[0];
	}

	private void OnPostRender()
	{
		if (showDebugTextures)
		{
			GL.PushMatrix();
			GL.LoadPixelMatrix(0f, 1f, 0f, 1f);
			debugMaterial.mainTexture = tinyTexture;
			debugMaterial.SetPass(0);
			DrawQuad(0f, 0f, 0.5f, 0.5f);
			debugMaterial.mainTexture = finalRampTexture;
			debugMaterial.SetPass(0);
			DrawQuad(0.5f, 0f, 0.5f, 0.5f);
			GL.PopMatrix();
		}
	}

	private void DrawQuad(float x, float y, float width, float height)
	{
		GL.Begin(7);
		GL.TexCoord2(0f, 0f);
		GL.Vertex3(x, y, 0f);
		GL.TexCoord2(0f, 1f);
		GL.Vertex3(x, y + height, 0f);
		GL.TexCoord2(1f, 1f);
		GL.Vertex3(x + width, y + height, 0f);
		GL.TexCoord2(1f, 0f);
		GL.Vertex3(x + width, y, 0f);
		GL.End();
	}
}
}
