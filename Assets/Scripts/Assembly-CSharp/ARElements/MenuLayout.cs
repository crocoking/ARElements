using UnityEngine;

namespace ARElements{

public abstract class MenuLayout : MonoBehaviour
{
	public abstract void BeginMenuLayout(MenuListData menuData);

	public abstract void LayoutMenuItem(MenuListData menuData, MenuItemData item, int index, GameObject thumbnail);

	public abstract void EndMenuLayout(MenuListData menuData);
}
}
