using System;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

namespace ARElements
{
    public class SelectableItem:CoordinatorReceiver
    {
        public virtual bool isBusy
        {
            get
            {
                return false;
            }
        }

        public bool isSelected
        {
            get
            {
                //return base.GetCoordinator<selectioncoo.>
            }
        }
    }
}
