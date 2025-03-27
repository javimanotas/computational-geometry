using System;
using UnityEngine;

public class Point : MonoBehaviour
{
    public Vector2 Pos => transform.position;

    public event Action OnDelete;

    void OnMouseDown()
    {
        Delete();
    }

    public void Delete(bool callback = true)
    {
        if (callback)
        {
            OnDelete();
        }

        Destroy(gameObject);
    }
}
