using UnityEngine;

namespace ARElements{

public abstract class MenuItemHandler : MonoBehaviour
{
	public abstract void PrepareMenuItemThumbnail(GameObject thumnailObj, MenuItemData itemData);

	public abstract void DidSelectMenuItem(MenuItem thumbnailObj);
}
}