using System;
using UnityEngine;

public class Point : MonoBehaviour
{
    public Vector2 Pos => transform.position;

    public event Action OnDelete;

    void OnMouseDown()
    {
        OnDelete();
        Destroy(gameObject);
    }
}
