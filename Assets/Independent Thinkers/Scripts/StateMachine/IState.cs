using UnityEngine;
public interface IState
{
    GameObject PlayerObject {get; set;}   
    string[] NextStates {get; set;}
    IStateMachine StateMachine {get; set;}
    void BeginTransition();
    void Execute(float deltaTime, AbstractInput input);
    void EndTransition();
}
