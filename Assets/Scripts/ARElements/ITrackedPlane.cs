﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace ARElements
{
    public class ITrackedPlane
    {
        Vector3 position { get; }

        Quaternion rotation { get; }

        Vector2 size { get; }

        List<Vector3> boundaryPoints { get; }

        PlaneState planeState { get; }
    }
}
