using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

public class IdleState : IState
{
    public string[] NextStates { get; set; } // 0 - IdleAttack, 1 - MoveState
    public GameObject PlayerObject { get; set; }
    public IStateMachine StateMachine { get; set; }

    public void BeginTransition()
    {
        Debug.Log("Starts Idle");
    }

    public void EndTransition()
    {
        Debug.Log("Ends Idle");
    }
    public void Execute(float deltaTime, AbstractInput input)
    {
       PlayerStateMachine.PlayerStateInput _input = (PlayerStateMachine.PlayerStateInput)input;
       if(_input.UnitVector.magnitude != 0) {
           StateMachine.Transist(NextStates[1]);
           return;
       }
       if(_input.LeftAttackState) {
           StateMachine.Transist(NextStates[0]);
           return;
       }
    }
}
