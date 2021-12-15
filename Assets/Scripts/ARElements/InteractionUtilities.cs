using System;
using System.Linq;
using UnityEngine;

namespace ARElements{

public class InteractionUtilities
{
	public static SelectableItem MakeSelectable(GameObject obj)
	{
		SelectableItem component = obj.GetComponent<SelectableItem>();
		if (component != null)
		{
			Debug.LogError("Object is already selectable.");
			return component;
		}
		SelectableItem result = obj.AddComponent<SelectableItem>();
		obj.AddComponent<SelectionController>();
		obj.AddComponent<ScreenSpaceOutliner>();
		return result;
	}

	public static SelectableItem MakeInteractive(GameObject obj, InteractionType[] interactions)
	{
		if (interactions.Length == 0)
		{
			return MakeSelectable(obj);
		}
		SelectableItem component = obj.GetComponent<SelectableItem>();
		if (component != null)
		{
			UnityEngine.Object.Destroy(component);
			UnityEngine.Object.Destroy(obj.GetComponent<SelectionController>());
			UnityEngine.Object.Destroy(obj.GetComponent<ScreenSpaceOutliner>());
		}
		TransformableItem transformableItem = obj.GetComponent<TransformableItem>();
		if (transformableItem == null)
		{
			transformableItem = obj.AddComponent<TransformableItem>();
		}
		obj.AddComponent<SelectionController>();
		obj.AddComponent<ScreenSpaceOutliner>();
		if (interactions.Contains(InteractionType.Translate))
		{
			obj.AddComponent<TranslationController>();
		}
		else
		{
			UnityEngine.Object.Destroy(obj.GetComponent<TranslationController>());
		}
		if (interactions.Contains(InteractionType.Rotate))
		{
			obj.AddComponent<TwistRotationController>();
			obj.AddComponent<DragRotationController>();
		}
		else
		{
			UnityEngine.Object.Destroy(obj.GetComponent<TwistRotationController>());
			UnityEngine.Object.Destroy(obj.GetComponent<DragRotationController>());
		}
		if (interactions.Contains(InteractionType.Scale))
		{
			obj.AddComponent<ScaleController>();
		}
		else
		{
			UnityEngine.Object.Destroy(obj.GetComponent<ScaleController>());
		}
		if (interactions.Contains(InteractionType.Remove))
		{
		}
		return transformableItem;
	}

	public static SelectableItem MakeInteractive(GameObject obj, bool fullyInteractive = false)
	{
		InteractionType[] interactions = Array.Empty<InteractionType>();
		if (fullyInteractive)
		{
			interactions = new InteractionType[4]
			{
				InteractionType.Translate,
				InteractionType.Rotate,
				InteractionType.Scale,
				InteractionType.Remove
			};
			return MakeInteractive(obj, interactions);
		}
		return MakeInteractive(obj, interactions);
	}
}
}