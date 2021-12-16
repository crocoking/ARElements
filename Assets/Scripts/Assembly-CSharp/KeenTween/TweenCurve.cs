using System;
using System.Collections.Generic;
using System.Reflection;

namespace KeenTween
{

	public abstract class TweenCurve
	{
		private static Dictionary<string, Type> typeLookupDict;

		public TweenCurveMode easeMode { get; set; }

		public TweenCurve(TweenCurveMode easeMode)
		{
			this.easeMode = easeMode;
		}

		public abstract float SampleIn(float position);

		public abstract float SampleOut(float position);

		public abstract float SampleInOut(float position);

		public float Sample(float position)
		{
			if (easeMode == TweenCurveMode.In)
			{
				return SampleIn(position);
			}
			if (easeMode == TweenCurveMode.Out)
			{
				return SampleOut(position);
			}
			if (easeMode == TweenCurveMode.InOut)
			{
				return SampleInOut(position);
			}
			throw new Exception(string.Concat("Unknown EaseMode \"", easeMode, "\""));
		}

		private static void ValidateTypeLookupDict()
		{
			if (typeLookupDict != null)
			{
				return;
			}
			typeLookupDict = new Dictionary<string, Type>();
			Assembly[] assemblies = AppDomain.CurrentDomain.GetAssemblies();
			foreach (Assembly assembly in assemblies)
			{
				try
				{
					Type[] types = assembly.GetTypes();
					foreach (Type type in types)
					{
						try
						{
							if (typeof(TweenCurve).IsAssignableFrom(type))
							{
								string name = type.Name;
								if (name.StartsWith("Curve"))
								{
									name = name.Substring("Curve".Length);
									typeLookupDict.Add(name, type);
								}
							}
						}
						catch (Exception)
						{
						}
					}
				}
				catch (Exception)
				{
				}
			}
		}

		public static Type Find(string name)
		{
			ValidateTypeLookupDict();
			typeLookupDict.TryGetValue(name, out var value);
			return value;
		}

		public static TweenCurve FromName(string name, TweenCurveMode curveMode)
		{
			Type type = Find(name);
			if (type == null)
			{
				return null;
			}
			return (TweenCurve)Activator.CreateInstance(type, curveMode);
		}
	}
}
