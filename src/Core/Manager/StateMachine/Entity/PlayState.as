package Core.Manager.StateMachine.Entity
{
	import flash.system.Capabilities;
	
	import Core.Actor.ActorBase;
	import Core.Manager.ActorManager;
	import Core.Manager.SceneManager;
	import Core.Manager.LayerManager.LayerManager;
	import Core.Manager.LayerManager.StarlingRootLayer;
	import Core.Manager.StateMachine.IGameState;
	
	import starling.core.Starling;
	import starling.events.Event;
	
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
			
		}
		
		public function Start():void
		{
			m_starling = new Starling(StarlingRootLayer, LayerManager.instance.stage);
			m_starling.enableErrorChecking = false;
			m_starling.showStats = Capabilities.isDebugger;
			m_starling.addEventListener(Event.ROOT_CREATED, onCreated);
			m_starling.start();	
		}
		
		private function onCreated():void
		{
			SceneManager.instance.init(null);
			ActorManager.instance.init("./resource/PrompaDroid.xml");
			var hero : ActorBase = ActorManager.instance.createHero();
			hero.displayObject.y = 200;
		}
		
		public function Update(t:Number):void
		{
			ActorManager.instance.update(t);
		}
		
		public function Quit():void
		{
		}
		
		private var m_starling : Starling;
	}
}