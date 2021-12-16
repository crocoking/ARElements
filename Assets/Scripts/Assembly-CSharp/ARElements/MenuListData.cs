using System.Collections.Generic;
using UnityEngine;

namespace ARElements
{

	[CreateAssetMenu]
	public class MenuListData : ScriptableObject
	{
		public GameObject thumbnailPrefab;

		public List<MenuItemData> items = new List<MenuItemData>();
	}
}
