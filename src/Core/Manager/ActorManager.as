package Core.Manager
{
	import flash.utils.Dictionary;
	
	import Core.Actor.ActorBase;
	import Core.Actor.ActorType;
	import Core.Actor.Entity.Floor;
	import Core.Actor.Entity.Hero;
	import Core.Actor.Entity.Ladder;
	import Core.Actor.Entity.Npc;
	
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;

	public class ActorManager
	{
		public function ActorManager()
		{
		}
		
		public function init(atlasUrl : String, readyFunc : Function) : void
		{
			m_assetManager = new AssetManager();
			m_assetManager.enqueue(atlasUrl + ".xml");
			m_assetManager.enqueue(atlasUrl + ".png");
			m_assetManager.loadQueue(loadProgress);
			m_readyFunc = readyFunc;
		}
		
		private function loadProgress(ratio : Number) : void
		{
			if(ratio == 1){
				m_atlasTexture = m_assetManager.getTextureAtlas("prompa");
				if(null != m_readyFunc)m_readyFunc();
			}
		}
		
		public function createHero() : ActorBase
		{
			var hero : Hero = new Hero(m_atlasTexture);
			SceneManager.instance.addActor(hero);
			
			if(!(ActorType.HERO in m_actorList)) m_actorList[ActorType.HERO] = new Vector.<ActorBase>;
			m_actorList[ActorType.HERO].push(hero);
			
			//相机默认锁定英雄
			SceneManager.instance.followTarget(hero);
			
			return hero;
		}
		
		public function createNpc() : ActorBase
		{
			var npc : Npc = new Npc(m_atlasTexture);
			SceneManager.instance.addActor(npc);
			
			if(!(ActorType.NPC in m_actorList)) m_actorList[ActorType.NPC] = new Vector.<ActorBase>;
			m_actorList[ActorType.NPC].push(npc);
			
			return npc;
		}
		
		public function createFloor() : ActorBase
		{
			var floor : Floor = new Floor(m_atlasTexture);
			SceneManager.instance.addFloor(floor);
			
			if(!(ActorType.FLOOR in m_actorList)) m_actorList[ActorType.FLOOR] = new Vector.<ActorBase>;
			m_actorList[ActorType.FLOOR].push(floor);
			
			return floor;
		}
		
		public function createLadder() : ActorBase
		{
			var ladder : Ladder = new Ladder(m_atlasTexture);
			SceneManager.instance.addFloor(ladder);
			
			if(!(ActorType.LADDER in m_actorList)) m_actorList[ActorType.LADDER] = new Vector.<ActorBase>;
			m_actorList[ActorType.LADDER].push(ladder);
			
			return ladder;
		}
		
		public function update(t:Number):void
		{
			for each(var list : Vector.<ActorBase> in m_actorList)
			{
				var len : int = list.length;
				for(var i : int = 0; i < len; i++){
					list[i].update(t);
				}
			}
			
		}
		
		public function getTargets(type : uint) : Vector.<ActorBase>{
			return m_actorList[type];
		}
		
		public static function get instance() : ActorManager
		{
			return m_instance ||= new ActorManager();
		}
		
		private static var m_instance : ActorManager;
		private var m_readyFunc : Function;
		private var m_atlasTexture : TextureAtlas;
		private var m_assetManager : AssetManager;
		
		private var m_actorList : Dictionary = new Dictionary();
	}
}