using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;
public class PlayerStateMachine : NetworkBehaviour, IStateMachine
{
    private Dictionary<string, IState> _states;
    private IState _currentState;
    private string _startingState;

    public override void OnStartServer()
    {
        _states = new Dictionary<string, IState>{
            
        };
    }

    [ServerCallback]
    public void Execute() {
    
    }
    
    [ServerCallback]
    public void Transist(string nextState) {

    }

    private class PlayerStateInput : AbstractInput {
        public Vector2 UnitVector {get;set;}
        public Vector2 PointerDirection {get;set;}
        public bool LeftAttackState{get;set;}
        public bool BlockState{get;set;}
    }
}
