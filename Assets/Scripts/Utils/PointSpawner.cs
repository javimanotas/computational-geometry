using System;
using System.Collections.Generic;
using UnityEngine;

public class PointSpawner : MonoBehaviour
{
    [SerializeField] Point Point;

    public event Action<Point> OnSpawn;

    public event Action<Point> OnDelete;

    public IEnumerable<Point> Points => _points;

    readonly List<Point> _points = new();

    Camera _cam;

    void Awake()
    {
        _cam = Camera.main;
        OnSpawn += _points.Add;
        OnDelete += p => _points.Remove(p);
    }

    public void RemovePoint(int idx)
    {
        _points.RemoveAt(idx);
    }

    void Update()
    {
        if (Input.GetMouseButtonDown(1))
        {
            var pos = _cam.ScreenToWorldPoint(Input.mousePosition).With(z: 0);
            var point = Instantiate(Point, pos, Quaternion.identity);
            point.OnDelete += () => OnDelete(point);
            OnSpawn(point);
        }
    }
}
