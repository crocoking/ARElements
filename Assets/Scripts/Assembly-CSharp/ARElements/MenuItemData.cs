using UnityEngine;

namespace ARElements{

[CreateAssetMenu]
public class MenuItemData : ScriptableObject
{
	public string title;

	public float thumbnailWidth = 100f;

	public float thumbnailHeight = 100f;

	public GameObject thumbnailPrefab;

	public Sprite thumbnailImage;

	public GameObject modelPrefab;

	public GameObject objectPrefab;
}
}
