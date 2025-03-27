using UnityEngine;

/// <summary>
/// Don't forget to cap fps in Unity. Otherwise your app will be running at > 500fps
/// and your GPU won't be happy with that. :)
/// </summary>
public static class GameSettings
{
    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSceneLoad)]
    static void SetTargetFrameRate()
    {
        QualitySettings.vSyncCount = 0;
        Application.targetFrameRate = 30;
    }
}