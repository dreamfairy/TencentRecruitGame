package Core.Manager.StateMachine
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import Core.Manager.LayerManager.LayerManager;
	import Core.Manager.StateMachine.Entity.PlayState;

	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-9 下午5:31:45
	 */
	public class StateMachineManager
	{
		public function StateMachineManager()
		{
		}
		
		public static function get instance() : StateMachineManager
		{
			return m_instance||= new StateMachineManager();
		}
		
		public function init(root : DisplayObjectContainer) : void
		{
			LayerManager.instance.init(root);
			root.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function update(e:Event) : void
		{
			if(m_currentState) m_currentState.Update(new Date().time);
		}
		
		public function changeState(state : IGameState) : void
		{
			if(m_currentState == state) return;
			
			if(m_currentState) m_currentState.Quit();
			m_currentState = state;
			m_currentState.Awake();
			m_currentState.Start();
		}
		
		public function get playState() : IGameState
		{
			return m_playState;
		}
		
		private static var m_instance : StateMachineManager;
		
		private var m_playState : IGameState = new PlayState();
		private var m_currentState : IGameState;
	}
}