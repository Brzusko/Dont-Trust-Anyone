using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CursorManager : MonoBehaviour
{
    [SerializeField]
    private Texture2D defaultCursor;
    private static CursorManager _instance;
    public static CursorManager Instance {
        get {
            if(_instance != null) return _instance;
            else throw new System.NullReferenceException();
        }
    }
    private void Awake() {
        if (_instance != null)
        {
            Destroy(this);
            return;
        }
        _instance = this;
        DontDestroyOnLoad(this);
    }

    private void Start() {
        var textureDimensions = new Vector2(defaultCursor.width, defaultCursor.height);
        var hotspot = new Vector2(textureDimensions.x/2, textureDimensions.y/2);
        Cursor.SetCursor(defaultCursor, hotspot, CursorMode.Auto);
    }
}
