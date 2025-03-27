using UnityEngine;

public static class Extensions
{
    public static Vector3 With(this Vector3 v, float? x = null, float? y = null, float? z = null)
        => new(x ?? v.x, y ?? v.y, z ?? v.z);

    public static float Phase(this Vector2 v)
        => Mathf.Atan2(v.y, v.x);
}