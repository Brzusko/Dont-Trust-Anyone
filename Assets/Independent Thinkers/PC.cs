// GENERATED AUTOMATICALLY FROM 'Assets/Independent Thinkers/PC.inputactions'

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.Utilities;

public class @PC : IInputActionCollection, IDisposable
{
    public InputActionAsset asset { get; }
    public @PC()
    {
        asset = InputActionAsset.FromJson(@"{
    ""name"": ""PC"",
    ""maps"": [
        {
            ""name"": ""Movements"",
            ""id"": ""ce8bc83c-d215-4c80-bd64-2cd65b48bfe7"",
            ""actions"": [
                {
                    ""name"": ""Movement"",
                    ""type"": ""Value"",
                    ""id"": ""b8fe7422-118b-4e9d-9f2f-676eb5b26c8a"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                },
                {
                    ""name"": ""Pointer"",
                    ""type"": ""Value"",
                    ""id"": ""ab73d171-4f17-48b4-9447-2912c3a2a167"",
                    ""expectedControlType"": ""Vector2"",
                    ""processors"": """",
                    ""interactions"": """"
                }
            ],
            ""bindings"": [
                {
                    ""name"": ""Velocity WSAD"",
                    ""id"": ""1e4fc636-64e1-48ce-af29-168a77712226"",
                    ""path"": ""2DVector"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": true,
                    ""isPartOfComposite"": false
                },
                {
                    ""name"": ""up"",
                    ""id"": ""b7b57078-e250-470c-99a9-f54ba58a9a2f"",
                    ""path"": ""<Keyboard>/w"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""down"",
                    ""id"": ""288c82d2-8742-4791-9d8e-6dfb26f00a9f"",
                    ""path"": ""<Keyboard>/s"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""left"",
                    ""id"": ""ca8517a4-4402-4333-8d78-1c282b23eaca"",
                    ""path"": ""<Keyboard>/a"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": ""right"",
                    ""id"": ""445f9504-14a7-4ddc-9634-482c8a9ef0c4"",
                    ""path"": ""<Keyboard>/d"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Movement"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": true
                },
                {
                    ""name"": """",
                    ""id"": ""d5466de6-a431-4a1e-a918-61b740fa44d7"",
                    ""path"": ""<Mouse>/position"",
                    ""interactions"": """",
                    ""processors"": """",
                    ""groups"": """",
                    ""action"": ""Pointer"",
                    ""isComposite"": false,
                    ""isPartOfComposite"": false
                }
            ]
        }
    ],
    ""controlSchemes"": []
}");
        // Movements
        m_Movements = asset.FindActionMap("Movements", throwIfNotFound: true);
        m_Movements_Movement = m_Movements.FindAction("Movement", throwIfNotFound: true);
        m_Movements_Pointer = m_Movements.FindAction("Pointer", throwIfNotFound: true);
    }

    public void Dispose()
    {
        UnityEngine.Object.Destroy(asset);
    }

    public InputBinding? bindingMask
    {
        get => asset.bindingMask;
        set => asset.bindingMask = value;
    }

    public ReadOnlyArray<InputDevice>? devices
    {
        get => asset.devices;
        set => asset.devices = value;
    }

    public ReadOnlyArray<InputControlScheme> controlSchemes => asset.controlSchemes;

    public bool Contains(InputAction action)
    {
        return asset.Contains(action);
    }

    public IEnumerator<InputAction> GetEnumerator()
    {
        return asset.GetEnumerator();
    }

    IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public void Enable()
    {
        asset.Enable();
    }

    public void Disable()
    {
        asset.Disable();
    }

    // Movements
    private readonly InputActionMap m_Movements;
    private IMovementsActions m_MovementsActionsCallbackInterface;
    private readonly InputAction m_Movements_Movement;
    private readonly InputAction m_Movements_Pointer;
    public struct MovementsActions
    {
        private @PC m_Wrapper;
        public MovementsActions(@PC wrapper) { m_Wrapper = wrapper; }
        public InputAction @Movement => m_Wrapper.m_Movements_Movement;
        public InputAction @Pointer => m_Wrapper.m_Movements_Pointer;
        public InputActionMap Get() { return m_Wrapper.m_Movements; }
        public void Enable() { Get().Enable(); }
        public void Disable() { Get().Disable(); }
        public bool enabled => Get().enabled;
        public static implicit operator InputActionMap(MovementsActions set) { return set.Get(); }
        public void SetCallbacks(IMovementsActions instance)
        {
            if (m_Wrapper.m_MovementsActionsCallbackInterface != null)
            {
                @Movement.started -= m_Wrapper.m_MovementsActionsCallbackInterface.OnMovement;
                @Movement.performed -= m_Wrapper.m_MovementsActionsCallbackInterface.OnMovement;
                @Movement.canceled -= m_Wrapper.m_MovementsActionsCallbackInterface.OnMovement;
                @Pointer.started -= m_Wrapper.m_MovementsActionsCallbackInterface.OnPointer;
                @Pointer.performed -= m_Wrapper.m_MovementsActionsCallbackInterface.OnPointer;
                @Pointer.canceled -= m_Wrapper.m_MovementsActionsCallbackInterface.OnPointer;
            }
            m_Wrapper.m_MovementsActionsCallbackInterface = instance;
            if (instance != null)
            {
                @Movement.started += instance.OnMovement;
                @Movement.performed += instance.OnMovement;
                @Movement.canceled += instance.OnMovement;
                @Pointer.started += instance.OnPointer;
                @Pointer.performed += instance.OnPointer;
                @Pointer.canceled += instance.OnPointer;
            }
        }
    }
    public MovementsActions @Movements => new MovementsActions(this);
    public interface IMovementsActions
    {
        void OnMovement(InputAction.CallbackContext context);
        void OnPointer(InputAction.CallbackContext context);
    }
}
