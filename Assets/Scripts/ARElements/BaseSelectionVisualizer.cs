using UnityEngine;

namespace ARElements
{

	public abstract class BaseSelectionVisualizer : MonoBehaviour
	{
		public abstract void ApplySelectionVisual(SelectableItem item);

		public abstract void RemoveSelectionVisual(SelectableItem item);
	}
}
