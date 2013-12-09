package Core.Manager.StateMachine
{
	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-9 下午5:33:59
	 */
	public interface IGameState
	{
		function Awake() : void;
		function Start() : void;
		function Update(t : Number) : void;
		function Quit() : void;
	}
}