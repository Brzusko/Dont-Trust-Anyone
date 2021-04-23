using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
using Indepndent.Enums;
public class PlayerStateMachine : NetworkBehaviour, IStateMachine
{
    private Dictionary<string, IState> _states;
    private IState _currentState;
    private PlayerInputSystem _pis;
    private string _startingState;

    public override void OnStartServer()
    {
        _pis = GetComponent<PlayerInputSystem>();
        _states = new Dictionary<string, IState>{
            { 
                typeof(IdleState).Name, new IdleState {
                    StateMachine = this,
                    PlayerObject = this.gameObject,
                    NextStates = new string[] { typeof(IdleAttackState).Name, typeof(MoveState).Name }
                }
            },
        };
        Transist(typeof(IdleState).Name);
    }

    [ServerCallback]
    public void Execute() {
        _currentState?.Execute(Time.deltaTime, new PlayerStateInput{
            UnitVector = _pis.s_movementInput,
            PointerDirection = _pis.pointerDir,
        });
    }
    
    [ServerCallback]
    public void Transist(string nextState) {
        _currentState?.EndTransition();
        _currentState = _states[nextState];
        _currentState.BeginTransition();
    }

    [ServerCallback]
    private void Update() {
        if(_states == null) return;
        Execute();
    }
    public class PlayerStateInput : AbstractInput {
        public Vector2 UnitVector {get;set;}
        public LookDirection PointerDirection {get;set;}
        public bool LeftAttackState{get;set;}
        public bool BlockState{get;set;}
    }
}
