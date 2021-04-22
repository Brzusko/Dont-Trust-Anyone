using UnityEngine;
using UnityEngine.InputSystem;
using Mirror;

public class PlayerInputSystem : NetworkBehaviour
{
    #region ServerVars // s_ stands for server
    public Vector2 s_pointerPos {get; private set;}
    public Vector2 s_movementInput {get; private set;}
    #endregion
    public Vector2 LocalVelocity {get; private set;}
    public Vector2 PointerPos {get; private set;}
    private PlayerInput _playerInput;
    private InputAction _movementAction;
    private InputAction _pointerAction;
    private Camera _mainCamera;

    #region Server Methods
    #endregion

    #region Client Methods
    [Command]
    private void ReciveMovementInput(Vector2 unitVector) {
        Debug.Log("Reciving movement input from client");
        if (unitVector == s_movementInput) return;
        s_movementInput = unitVector;
    }

    [Command]
    private void ReciveMouseInput(Vector2 mousePos) {
        Debug.Log("Reciving mouse input from client");
        if (mousePos == s_pointerPos) return;
        s_pointerPos = mousePos;
    }
    #endregion
    public override void OnStartLocalPlayer() {
        CSetup();
    }

    [Client]
    private void CSetup() {
        _playerInput = GetComponent<PlayerInput>();
        var playerActions = _playerInput.actions;
        _pointerAction = playerActions.FindAction("Pointer");
        _movementAction = playerActions.FindAction("Movement");
        _mainCamera = Camera.main;

        if(_pointerAction != null && _movementAction != null) {
            _pointerAction.performed += ctx => {
                PointerPos = _mainCamera.ScreenToWorldPoint(ctx.ReadValue<Vector2>());
                ReciveMouseInput(PointerPos);
            };
            _movementAction.performed += ctx => {
                var unitVector = _movementAction.ReadValue<Vector2>();
                if (unitVector == LocalVelocity)
                    return;
                LocalVelocity = unitVector;
                ReciveMovementInput(LocalVelocity);
            };
            _movementAction.canceled += ctx => {
                LocalVelocity = Vector2.zero;
                ReciveMovementInput(LocalVelocity);
            };
        }
    }
}
