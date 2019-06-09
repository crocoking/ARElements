using System;
using UnityEngine;

namespace ARElements
{
    public abstract class BaseSelectionVisualizer : MonoBehaviour
    {
        public abstract void ApplySelectionVisula(SelectableItem item);
        public abstract void RemoveSelectionVisual(SelectableItem item);
    }
}
