using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class TopBarUI : MonoBehaviour
{
	public bool disableNavigation;

	public Button overflowButton;

	public Button hideUIButton;

	public CanvasGroup canvasGroup;

	public OverflowMenu overflowMenu;

	public RectTransform overflowMenuAnchor;

	public string privacyUrl = string.Empty;

	public string tosUrl = string.Empty;

	[TextArea(3, 10)]
	public string licenseNoticesText = "<License texts>";

	public FullscreenDialog fullscreenDialogTemplate;

	protected virtual void Start()
	{
		overflowButton.onClick.AddListener(OnClickOverflowButton);
		hideUIButton.onClick.AddListener(OnClickHideUIButton);
	}

	protected void OnEnable()
	{
		SceneManager.sceneLoaded += OnSceneLoaded;
	}

	protected void OnDisable()
	{
		SceneManager.sceneLoaded -= OnSceneLoaded;
	}

	private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
	{
		if ((bool)SceneArea.current)
		{
			overflowButton.gameObject.SetActive(value: true);
		}
	}

	private void OnClickOverflowButton()
	{
		OverflowMenu overflowMenu = Object.Instantiate(this.overflowMenu, overflowMenuAnchor);
		overflowMenu.AddItem("Reanchor", OnPressedReanchor);
		overflowMenu.AddDivider();
		overflowMenu.AddItem("Privacy Policy", delegate
		{
			Application.OpenURL(privacyUrl);
		});
		overflowMenu.AddItem("Terms of Service", delegate
		{
			Application.OpenURL(tosUrl);
		});
		overflowMenu.AddItem("License Notices", OnPressLicenseNotices);
	}

	private void OnPressedReanchor()
	{
		if ((bool)SceneArea.current)
		{
			SceneArea.current.EnterReanchorMode();
		}
	}

	private void OnPressLicenseNotices()
	{
		FullscreenDialog fullscreenDialog = Object.Instantiate(fullscreenDialogTemplate);
		fullscreenDialog.titleTextComponent.text = "License Notices";
		fullscreenDialog.bodyTextComponent.text = licenseNoticesText;
	}

	private void OnClickHideUIButton()
	{
		canvasGroup.alpha = 0f;
		if (SceneArea.current.instructionCardPivot.gameObject.activeSelf)
		{
			SceneArea.current.SetPhysicalUIVisibility(visibility: false);
		}
	}
}
}
