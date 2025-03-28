using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class ConvexHull : MonoBehaviour
{
    [SerializeField] PointSpawner Spawner;

    [SerializeField] SegmentDisplay SegmentDisplay;

    void Start()
    {
        Spawner.OnSpawn += DrawConvexHull;
        Spawner.OnDelete += DrawConvexHull;
    }
    
    void DrawConvexHull(Point _)
    {
        SegmentDisplay.DeleteAllSegments();

        var points = Spawner.Points
            .Select(p => p.Pos);

        var hull = ComputeHull(points).ToArray();

        for (var i = 0; i < hull.Length; i++)
        {
            SegmentDisplay.DrawSegment(hull[i], hull[(i + 1) % hull.Length]);
        }
    }

    static IEnumerable<Vector2> ComputeHull(IEnumerable<Vector2> points)
    {
        static bool IsRightTurn(Vector2 p0, Vector2 p1, Vector2 p2)
        {
            var u = p1 - p0;
            var v = p2 - p1;
            
            return u.x * v.y - u.y * v.x < 0;
        }

        // sort them in lexicographical order
        var sortedPoints = points
            .Distinct()
            .OrderBy(p => (p.x, p.y))
            .ToArray();

        if (sortedPoints.Length < 3)
        {
            return sortedPoints;
        }

        var upperHull = new List<Vector2>() { sortedPoints[0], sortedPoints[1] };

        for (var i = 2; i < sortedPoints.Length; i++)
        {
            upperHull.Add(sortedPoints[i]);

            while (upperHull.Count >= 3 && !IsRightTurn(upperHull[^3], upperHull[^2], upperHull[^1]))
            {
                // the middle of the last 3 gets removed
                upperHull.RemoveAt(upperHull.Count - 2);
            }
        }

        // do the same for the lower part
        var lowerHull = new List<Vector2>() { sortedPoints[^1], sortedPoints[^2] };

        for (var i = sortedPoints.Length - 3; i >= 0; i--)
        {
            lowerHull.Add(sortedPoints[i]);

            while (lowerHull.Count >= 3 && !IsRightTurn(lowerHull[^3], lowerHull[^2], lowerHull[^1]))
            {
                lowerHull.RemoveAt(lowerHull.Count - 2);
            }
        }

        // avoid duplicated points (belong to both the upper and lower hull)
        lowerHull.RemoveAt(0);
        lowerHull.RemoveAt(lowerHull.Count - 1);

        return upperHull.Concat(lowerHull);
    }
}
