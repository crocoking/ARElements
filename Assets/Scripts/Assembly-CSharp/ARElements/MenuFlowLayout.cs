using UnityEngine;

namespace ARElements{

public class MenuFlowLayout : MenuLayout
{
	public float border = 360f;

	public float firstItemPadding = 19f;

	public float verticalPadding = 19f;

	public float horizontalPadding = 23f;

	public float itemSize = 46f;

	public RectTransform scrollableArea;

	public RectTransform contentArea;

	public override void BeginMenuLayout(MenuListData menuData)
	{
	}

	public override void LayoutMenuItem(MenuListData menuData, MenuItemData item, int index, GameObject thumbnail)
	{
		if (scrollableArea == null)
		{
			Debug.LogError("Failed to get RectTransform for the scrollableArea");
			return;
		}
		if (contentArea == null)
		{
			Debug.LogError("Failed to get RectTransform for the contentArea");
			return;
		}
		RectTransform component = thumbnail.GetComponent<RectTransform>();
		if (component == null)
		{
			Debug.LogError("Failed to get RectTransform for the thumbnail");
			return;
		}
		float num = firstItemPadding + (itemSize + horizontalPadding) * (float)(index + 1);
		float num2 = itemSize + 2f * verticalPadding;
		float inset = firstItemPadding + (itemSize + horizontalPadding) * (float)index + border;
		scrollableArea.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Left, 0f, num);
		scrollableArea.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Top, 0f - num2, num2 * 2f);
		contentArea.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Left, 0f - border, num + border * 2f);
		contentArea.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Top, num2, num2 + border);
		component.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Left, inset, itemSize);
		component.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Top, verticalPadding, itemSize);
	}

	public override void EndMenuLayout(MenuListData menuData)
	{
	}
}
}
