using UnityEngine.UI;

namespace GoogleARCore.BestPractices{

public class EmptyGraphic : Graphic
{
	protected override void OnPopulateMesh(VertexHelper vh)
	{
		vh.Clear();
	}
}
}
