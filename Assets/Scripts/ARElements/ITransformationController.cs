namespace ARElements{

public interface ITransformationController
{
	bool isTransforming { get; }

	bool isTransformationFinishing { get; }

	bool isTransformationValid { get; }
}
}
