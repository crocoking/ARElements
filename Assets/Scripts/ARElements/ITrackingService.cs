using System.Collections.Generic;
using GoogleARCore;

namespace ARElements{

public interface ITrackingService
{
	SessionStatus trackingState { get; }

	bool enabledOnPlatform { get; }

	void GetNewPlanes(ref List<ITrackedPlane> planes);

	void GetUpdatedPlanes(ref List<ITrackedPlane> planes);
}
}
