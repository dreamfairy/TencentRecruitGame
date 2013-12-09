package Core.Manager.StateMachine.Entity
{
	import flash.system.Capabilities;
	
	import Core.Manager.LayerManager.LayerManager;
	import Core.Manager.StateMachine.IGameState;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	
	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-9 下午5:37:08
	 */
	public class PlayState implements IGameState
	{
		public function PlayState()
		{
		}
		
		public function Awake():void
		{
			m_starling = new Starling(Sprite, LayerManager.instance.stage);
			m_starling.enableErrorChecking = false;
			m_starling.showStats = Capabilities.isDebugger;
			m_starling.root = LayerManager.instance.starlingLayer as DisplayObjectContainer;
			m_starling.start();
		}
		
		public function Start():void
		{
		}
		
		public function Update(t:Number):void
		{
		}
		
		public function Quit():void
		{
		}
		
		private var m_starling : Starling;
	}
}