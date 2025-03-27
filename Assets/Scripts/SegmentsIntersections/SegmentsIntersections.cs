using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class SegmentsIntersections : MonoBehaviour
{
    [SerializeField] PointSpawner Spawner;

    [SerializeField] SegmentDisplay SegmentDisplay;

    readonly List<Point> _points = new();

    void Start()
    {
        Spawner.OnSpawn += _points.Add;
        Spawner.OnSpawn += DrawSegments;

        Spawner.OnDelete += DeleteEdge;
        Spawner.OnDelete += DrawSegments;
    }

    void DeleteEdge(Point p)
    {
        var i = _points.IndexOf(p);
        _points.RemoveAt(i);

        var points = Spawner.Points.ToList();

        if (i % 2 != 0)
        {
            i--;
        }
        else if (i >= points.Count)
        {
            return;
        }
        
        _points.RemoveAt(i);
        points[i].Delete(callback: false);
        Spawner.RemovePoint(i);
    }

    void DrawSegments(Point p)
    {
        SegmentDisplay.DeleteAllSegments();

        var points = Spawner.Points
            .Select(p => p.Pos)
            .ToArray();

        for (var i = 0; i < points.Length - 1; i += 2)
        {
            SegmentDisplay.DrawSegment(points[i], points[i + 1]);
        }
    }
}
