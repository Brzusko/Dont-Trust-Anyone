using UnityEngine;
public interface IState
{
    GameObject PlayerObject {get; set;}   
    IState NextState {get; set;}
    void BeginTransition();
    void Execute(float deltaTime, AbstractInput input);
    void EndTransition();
}
