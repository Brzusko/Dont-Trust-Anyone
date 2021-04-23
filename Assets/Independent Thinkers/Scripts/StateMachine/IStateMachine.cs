
public interface IStateMachine
{
    void Execute();
    void Transist(string nextState);
}
