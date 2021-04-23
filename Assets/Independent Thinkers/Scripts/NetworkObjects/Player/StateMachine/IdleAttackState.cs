using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

public class IdleAttackState : IState
{
    public string[] NextStates { get; set; }
    public GameObject PlayerObject { get; set; }
    public IStateMachine StateMachine { get => throw new System.NotImplementedException(); set => throw new System.NotImplementedException(); }

    public void BeginTransition()
    {
        throw new System.NotImplementedException();
    }

    public void EndTransition()
    {
        throw new System.NotImplementedException();
    }
    public void Execute(float deltaTime, AbstractInput input)
    {
        throw new System.NotImplementedException();
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
