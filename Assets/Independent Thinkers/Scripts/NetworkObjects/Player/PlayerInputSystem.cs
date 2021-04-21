using UnityEngine;
using UnityEngine.InputSystem;
using Mirror;

public class PlayerInputSystem : NetworkBehaviour
{
    public Vector2 Velocity {get; private set;}
    public Vector2 PointerPos {get; private set;}
    private PlayerInput _playerInput;
    private InputAction _movementAction;
    private InputAction _pointerAction;

    private Camera _mainCamera;

    public override void OnStartLocalPlayer() {
        CSetup();
    }

    private void CSetup() {
        _playerInput = GetComponent<PlayerInput>();
        var playerActions = _playerInput.actions;
        _pointerAction = playerActions.FindAction("Pointer");
        _movementAction = playerActions.FindAction("Movement");
        _mainCamera = Camera.main;

        if(_pointerAction != null) {
            _pointerAction.performed += ctx => {
                PointerPos = _mainCamera.ScreenToWorldPoint(ctx.ReadValue<Vector2>());
            };
        }
    }
    private void Update() {
        if(isLocalPlayer) {
            var velocity = _movementAction.ReadValue<Vector2>();
        }
    }
}
