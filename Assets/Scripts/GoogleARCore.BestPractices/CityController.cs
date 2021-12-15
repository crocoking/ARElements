using System;
using System.Collections.Generic;
using UnityEngine;

namespace GoogleARCore.BestPractices{

public class CityController : MonoBehaviour
{
	public delegate void OnDayNightChangeDelegate(bool isDay);

	public bool useLightEstimation = true;

	public float transitionRate = 10f;

	public float minDayNightSwitchThreshold = 10f;

	public float maxDayNightSwitchThreshold = 50f;

	public float smoothAverageLightRate = 1f;

	public float lightsOnLight = 1.5f;

	public float lightsOffLight = 0.5f;

	public int lightRangeIncrements = 100;

	public AudioSource dayAudioSource;

	public AudioSource nightAudioSource;

	public float maxAmbientAudioVolume = 1f;

	public List<MeshRenderer> meshRenderers;

	public MeshRenderer shadowLightRenderer;

	public List<CityCar> carPrefabs;

	public List<CityCar> specialCars;

	public Transform carPivot;

	public int carCount = 20;

	public float editorTestLight = 1f;

	[NonSerialized]
	public List<CityCar> cars = new List<CityCar>();

	private List<Material> cityMaterials = new List<Material>();

	private float dayNightAudioWeight;

	private float smoothAverageLight;

	private string[] infoCardStrings;

	public bool isDay { get; private set; }

	public event OnDayNightChangeDelegate onDayNightChange;

	private void Awake()
	{
		isDay = true;
		dayAudioSource.volume = 1f;
		nightAudioSource.volume = 0f;
	}

	private void Start()
	{
		InfoCard infoCard = SceneArea.current.infoCard;
		infoCardStrings = new string[lightRangeIncrements];
		string text = infoCard.expandedTextComponent.text.Replace("MAXLIGHTVALUE", lightRangeIncrements.ToString());
		for (int i = 0; i < lightRangeIncrements; i++)
		{
			infoCardStrings[i] = text.Replace("LIGHTVALUE", (i + 1).ToString());
		}
		infoCard.expandedTextComponent.text = infoCardStrings[0];
		Dictionary<Material, Material> dictionary = new Dictionary<Material, Material>();
		foreach (MeshRenderer meshRenderer in meshRenderers)
		{
			Material[] sharedMaterials = meshRenderer.sharedMaterials;
			for (int j = 0; j < sharedMaterials.Length; j++)
			{
				Material material = sharedMaterials[j];
				if (!dictionary.TryGetValue(material, out var value))
				{
					value = UnityEngine.Object.Instantiate(material);
					dictionary.Add(material, value);
					cityMaterials.Add(value);
				}
				sharedMaterials[j] = value;
			}
			meshRenderer.sharedMaterials = sharedMaterials;
		}
		shadowLightRenderer.sharedMaterial = UnityEngine.Object.Instantiate(shadowLightRenderer.sharedMaterial);
		Color color = shadowLightRenderer.sharedMaterial.color;
		color.a = 0f;
		shadowLightRenderer.sharedMaterial.color = color;
		RoadNetworkSpan[] componentsInChildren = base.gameObject.GetComponentsInChildren<RoadNetworkSpan>();
		for (int k = 0; k < carCount; k++)
		{
			RoadNetworkSpan span = componentsInChildren[UnityEngine.Random.Range(0, componentsInChildren.Length)];
			MakeCar(span, carPrefabs[UnityEngine.Random.Range(0, carPrefabs.Count)]);
		}
		for (int l = 0; l < specialCars.Count; l++)
		{
			RoadNetworkSpan span2 = componentsInChildren[UnityEngine.Random.Range(0, componentsInChildren.Length)];
			MakeCar(span2, specialCars[l]);
		}
		smoothAverageLight = GetLightLevel();
		isDay = smoothAverageLight >= (lightsOnLight + lightsOffLight) / 2f;
	}

	private void MakeCar(RoadNetworkSpan span, CityCar carPrefab)
	{
		CityCar cityCar = UnityEngine.Object.Instantiate(carPrefab, carPivot);
		cars.Add(cityCar);
		cityCar.currentSpan = span;
		cityCar.direction = ((UnityEngine.Random.value > 0.5f) ? 1 : (-1));
		cityCar.position = UnityEngine.Random.Range(0f, 1f);
		cityCar.UpdatePosition();
	}

	private void Update()
	{
		float lightLevel = GetLightLevel();
		float num = Mathf.Clamp01((lightLevel - lightsOffLight) / (lightsOnLight - lightsOffLight));
		bool flag = lightLevel >= lightsOnLight;
		bool flag2 = lightLevel <= lightsOffLight;
		if (!isDay && !flag2 && (flag || lightLevel - smoothAverageLight > Mathf.Lerp(minDayNightSwitchThreshold, maxDayNightSwitchThreshold, num)))
		{
			isDay = true;
			this.onDayNightChange(isDay);
		}
		else if (isDay && !flag && (flag2 || lightLevel - smoothAverageLight < 0f - Mathf.Lerp(maxDayNightSwitchThreshold, minDayNightSwitchThreshold, num)))
		{
			isDay = false;
			this.onDayNightChange(isDay);
		}
		int num2 = Mathf.Clamp((int)(num * (float)lightRangeIncrements), 0, lightRangeIncrements - 1);
		if (SceneArea.current.infoCard.expandedTextComponent.text != infoCardStrings[num2])
		{
			SceneArea.current.infoCard.expandedTextComponent.text = infoCardStrings[num2];
		}
		int num3 = (isDay ? 1 : 0);
		foreach (Material cityMaterial in cityMaterials)
		{
			float @float = cityMaterial.GetFloat("_DayWeight");
			float value = Mathf.Lerp(@float, num3, Time.deltaTime * transitionRate);
			cityMaterial.SetFloat("_DayWeight", value);
		}
		Color color = shadowLightRenderer.sharedMaterial.color;
		color.a = Mathf.Lerp(color.a, 1f - (float)num3, Time.deltaTime * transitionRate);
		shadowLightRenderer.sharedMaterial.color = color;
		float target = ((!isDay) ? 1 : 0);
		dayNightAudioWeight = Mathf.MoveTowards(dayNightAudioWeight, target, 2f * Time.deltaTime);
		dayAudioSource.volume = (1f - dayNightAudioWeight) * maxAmbientAudioVolume;
		nightAudioSource.volume = dayNightAudioWeight * maxAmbientAudioVolume;
		smoothAverageLight = Mathf.Lerp(smoothAverageLight, lightLevel, smoothAverageLightRate * Time.deltaTime);
	}

	private float GetLightLevel()
	{
		if (Application.isEditor)
		{
			return editorTestLight;
		}
		return Frame.LightEstimate.PixelIntensity;
	}
}
}
