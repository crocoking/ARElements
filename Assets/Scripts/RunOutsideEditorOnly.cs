using UnityEngine;

public class RunOutsideEditorOnly : MonoBehaviour
{
	private void Awake()
	{
		base.gameObject.SetActive(!Application.isEditor);
	}
}
