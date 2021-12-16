using UnityEngine;

namespace ARElements
{

	public class NavBarManager : MonoBehaviour
	{
		public enum Decoration
		{
			None,
			AlwaysShowNavbar,
			Any
		}

		public Decoration portraitDecoration = Decoration.AlwaysShowNavbar;

		public Decoration landscapeDecoration;

		private void Update()
		{
			if (Input.GetKeyUp(KeyCode.Escape))
			{
				Application.Quit();
			}
			Decoration decoration = Decoration.Any;
			if (Screen.orientation == ScreenOrientation.Portrait || Screen.orientation == ScreenOrientation.PortraitUpsideDown)
			{
				decoration = portraitDecoration;
			}
			else if (Screen.orientation == ScreenOrientation.LandscapeLeft || Screen.orientation == ScreenOrientation.LandscapeRight)
			{
				decoration = landscapeDecoration;
			}
			if (decoration != Decoration.Any)
			{
				Screen.fullScreen = decoration != Decoration.AlwaysShowNavbar;
			}
		}
	}
}
