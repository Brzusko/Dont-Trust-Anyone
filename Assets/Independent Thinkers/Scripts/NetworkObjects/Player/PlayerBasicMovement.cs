using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
public class PlayerBasicMovement : NetworkBehaviour
{
    private PlayerInputSystem _pis;

    public override void OnStartLocalPlayer()
    {
        _pis = GetComponent<PlayerInputSystem>();
    }

    private void Update() {
        if(_pis == null) return;
        transform.position = transform.position + ((Vector3)_pis.Velocity * Time.deltaTime * 1.5f);
    }
}
