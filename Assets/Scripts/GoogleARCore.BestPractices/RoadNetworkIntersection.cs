using System;
using System.Collections.Generic;

namespace GoogleARCore.BestPractices{

public class RoadNetworkIntersection : RoadNetworkNode
{
	[Serializable]
	public class Turn
	{
		public RoadNetworkSpan span;
	}

	public List<RoadNetworkSpan> spans = new List<RoadNetworkSpan>();

	protected override void OnDrawGizmos()
	{
	}
}
}
