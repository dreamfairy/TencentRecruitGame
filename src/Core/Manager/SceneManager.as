package Core.Manager
{
	import Core.Actor.ActorBase;
	import Core.Manager.LayerManager.LayerManager;
	
	import starling.display.Sprite;

	public class SceneManager
	{
		public function SceneManager()
		{
		}
		
		public function init(mapUrl : String) : void
		{
			m_sceneLayer = new Sprite();
			m_sceneLayer.touchable = false;
			
			m_mapLayer = new Sprite();
			m_mapLayer.touchable = false;
			
			m_farLayer = new Sprite();
			m_farLayer.touchable = false;
			
			m_middleLayer = new Sprite();
			m_middleLayer.touchable = false;
			
			m_nearLayer = new Sprite();
			m_nearLayer.touchable = false;
			
			m_actorLayer = new Sprite();
			m_actorLayer.touchable = false;
			
			m_middleLayer.addChild(m_mapLayer);
			m_middleLayer.addChild(m_actorLayer);
			
			m_sceneLayer.addChild(m_farLayer);
			m_sceneLayer.addChild(m_middleLayer);
			m_sceneLayer.addChild(m_nearLayer);
			
			LayerManager.instance.starlingLayer.addChild(m_sceneLayer);
		}
		
		public function addActor(actor : ActorBase) : void
		{
			if(!m_actorLayer.contains(actor.displayObject)){
				m_actorLayer.addChild(actor.displayObject);
			}
		}
		
		public function removeActor(actor : ActorBase) : void
		{
			actor.displayObject.removeFromParent();
		}
		
		public function dispose() : void
		{
			
		}
		
		public static function get instance() : SceneManager
		{
			return m_instance ||= new SceneManager();
		}
		
		private static var m_instance : SceneManager;
		private var m_sceneLayer : Sprite;
		private var m_mapLayer : Sprite;
		private var m_actorLayer : Sprite;
		private var m_farLayer : Sprite;
		private var m_middleLayer : Sprite;
		private var m_nearLayer : Sprite;
	}
}