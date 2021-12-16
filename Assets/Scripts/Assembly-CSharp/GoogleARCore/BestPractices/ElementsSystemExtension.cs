using ARElements;

namespace GoogleARCore.BestPractices{

public static class ElementsSystemExtension
{
	private static CoordinatorContext coordinatorContextCache;

	public static CoordinatorContext GetCoordinatorContext(this ElementsSystem elementsSystem)
	{
		if (!coordinatorContextCache)
		{
			if (!elementsSystem)
			{
				return null;
			}
			if (!elementsSystem.selectionCoordinator)
			{
				return null;
			}
			coordinatorContextCache = elementsSystem.selectionCoordinator.gameObject.GetComponent<CoordinatorContext>();
		}
		return coordinatorContextCache;
	}

	public static GestureCoordinator GetGestureCoordinator(this ElementsSystem elementsSystem)
	{
		CoordinatorContext coordinatorContext = ElementsSystem.instance.GetCoordinatorContext();
		if (!coordinatorContext)
		{
			return null;
		}
		return coordinatorContext.GetCoordinator<GestureCoordinator>();
	}
}
}
