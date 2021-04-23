using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

public class MoveState : IState
{
    public string[] NextStates { get; set; } // 0 - Idle, 1 - MoveAttack, 2 - MoveBlock
    public GameObject PlayerObject { get; set; }
    public IStateMachine StateMachine { get; set; }
    private Transform _playerTransform;
    private Animator _animator;
    private bool firstRun = true;
    public void BeginTransition()
    {
        if(firstRun) {
            _playerTransform = PlayerObject.GetComponent<Transform>();
            _animator = PlayerObject.GetComponent<Animator>();
            firstRun = false;
        }
        _animator.SetBool("isRunning", true);
        Debug.Log("Start Running State");
    }

    public void EndTransition()
    {
        _animator.SetBool("isRunning", false);
        Debug.Log("Ends Walking Transition");
    }

    public void Execute(float deltaTime, AbstractInput input)
    {
        var _input = (PlayerStateMachine.PlayerStateInput)input;
        if(_input.UnitVector.magnitude == 0) {
            StateMachine.Transist(NextStates[0]);
            return;
        }
        if(_input.LeftAttackState){
            StateMachine.Transist(NextStates[1]);
            return;
        }
        if(_input.BlockState) {
            StateMachine.Transist(NextStates[2]);
            return;
        }
        _playerTransform.position = _playerTransform.position + ((Vector3)_input.UnitVector * deltaTime * 0.15f);   
    }
}
