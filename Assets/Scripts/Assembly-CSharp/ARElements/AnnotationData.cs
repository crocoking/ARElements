using UnityEngine;

namespace ARElements
{

	[CreateAssetMenu(menuName = "ARElements/Annotations/Annotation Data")]
	public class AnnotationData : ScriptableObject
	{
		[Tooltip("Icon displayed on card.")]
		public Sprite icon;

		[Header("Annotation Info")]
		[Tooltip("Title text.")]
		public string title = "Title";

		[TextArea]
		[Tooltip("Short summary message that is 1-2 lines long.")]
		public string summary = "This is a short message shown on large sized cards.";

		[Tooltip("Extended information that is shown on screen space cards when tapped.")]
		[TextArea]
		public string detail = "This is longer more detailed information message on the card.";

		[Header("Card Style")]
		[Tooltip("Color of the annotation mesh. This is a tint color if a texture is supplied.")]
		public Color cardColor = Color.blue;

		[Tooltip("Texture applied to the card mesh.")]
		public Texture2D cardTexture;

		[Tooltip("If supplied, this will be the screen card used to display information when annotation is tapped.")]
		public AnnotationScreenCard screenCardPrefab;

		[Tooltip("If true the annotation can show small size.")]
		public bool supportsSmallCardSize = true;

		[Tooltip("If true the annotation can show medium size.")]
		public bool supportsMediumCardSize = true;

		[Tooltip("If true the annotation can show large size.")]
		public bool supportsLargeCardSize = true;

		[Tooltip("If true, the detail text will be displayed on a screen space card.")]
		public bool supportsScreenSpaceViewing = true;
	}
}
