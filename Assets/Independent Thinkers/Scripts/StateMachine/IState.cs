
public interface IState
{
    IState NextState {get; set;}
    void BeginTransition();
    void Execute(float deltaTime);
    void EndTransition();
}
