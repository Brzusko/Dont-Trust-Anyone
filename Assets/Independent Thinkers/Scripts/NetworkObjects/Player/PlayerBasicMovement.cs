using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
public class PlayerBasicMovement : NetworkBehaviour
{
    private PlayerInputSystem _pis;

    public override void OnStartServer()
    {
        _pis = GetComponent<PlayerInputSystem>();
    }

    [ServerCallback]
    private void Update() {
        if(_pis == null) return;
        transform.position = transform.position + ((Vector3)_pis.s_movementInput * Time.deltaTime * 1.5f);
    }
}
