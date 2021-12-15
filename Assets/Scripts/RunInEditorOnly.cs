using UnityEngine;

public class RunInEditorOnly : MonoBehaviour
{
	private void Awake()
	{
		base.gameObject.SetActive(Application.isEditor);
	}
}
