using System.Collections.Generic;
using UnityEngine;

public class SegmentDisplay : MonoBehaviour
{
    [SerializeField] GameObject Line;
    
    readonly List<GameObject> _segments = new();

    public void DeleteAllSegments()
    {
        _segments.ForEach(Destroy);
        _segments.Clear();
    }

    public void DrawSegment(Vector2 p, Vector2 q)
    {
        var mid = (p + q) / 2;
        var rot = Mathf.Atan2(q.y - p.y, q.x - p.x) * Mathf.Rad2Deg;

        var obj = Instantiate(Line, mid, Quaternion.Euler(0, 0, rot));
        obj.transform.localScale = obj.transform.localScale.With(x: (p - q).magnitude);
        _segments.Add(obj);
    }
}
