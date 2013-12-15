package Core.Manager
{
	import Core.Actor.ActorBase;
	import Core.Actor.Hero;
	
	import starling.utils.AssetManager;

	public class ActorManager
	{
		public function ActorManager()
		{
		}
		
		public function init(atlasUrl : String) : void
		{
			m_assetManager = new AssetManager();
		}
		
		public function createHero() : ActorBase
		{
			var hero : Hero = new Hero();
			SceneManager.instance.addActor(hero);
			m_actorList.push(hero);
			return hero;
		}
		
		public function createNpc() : ActorBase
		{
			return null;
		}
		
		public function update(t:Number):void
		{
			var len : int = m_actorList.length;
			for(var i : int = 0; i < len; i++){
				m_actorList[i].update(t);
			}
		}
		
		public function checkTargets(func : Function) : void{
			m_actorList.forEach(func);
		}
		
		public static function get instance() : ActorManager
		{
			return m_instance ||= new ActorManager();
		}
		
		private static var m_instance : ActorManager;
		private var m_assetManager : AssetManager;
		private var m_actorList : Vector.<ActorBase> = new Vector.<ActorBase>();
	}
}