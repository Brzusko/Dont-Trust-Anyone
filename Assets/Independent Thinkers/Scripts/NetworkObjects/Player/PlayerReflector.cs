using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Indepndent.Enums;
using Mirror;
public class PlayerReflector : NetworkBehaviour
{
    private PlayerInputSystem _pis;
    private SpriteRenderer _spriteRenderer;

    private void Start() {
        _pis = GetComponent<PlayerInputSystem>();
        _spriteRenderer = GetComponent<SpriteRenderer>();
    }

    [ServerCallback]
    private void Update() {
        if(_pis.pointerDir == LookDirection.LEFT)
            Reflect(true);
        else
            Reflect(false);
    }

    [ClientRpc]
    private void Reflect(bool reflection) {
        if(_spriteRenderer != null) _spriteRenderer.flipX = reflection;
    }
}
