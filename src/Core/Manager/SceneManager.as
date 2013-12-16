package Core.Manager
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import Core.Actor.ActorBase;
	import Core.Manager.LayerManager.LayerManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.extensions.fluocode.Fluocam;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class SceneManager
	{
		public function SceneManager()
		{
		}
		
		public function init(mapUrl : String) : void
		{
			m_urlString = mapUrl;
			
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
			
			m_loader = new URLLoader();
			m_loader.addEventListener(Event.COMPLETE, onLoadedData);
			m_loader.load(new URLRequest(mapUrl + "mapData.xml"));
			
			m_viewRect = new Rectangle(0,0,LayerManager.instance.stage.stageWidth,LayerManager.instance.stage.stageHeight);
			m_cam = new Fluocam(m_middleLayer, m_viewRect.width, m_viewRect.height * 1.5, true);
			m_sceneLayer.addChild(m_cam);
			
			m_assetManager = new AssetManager();
		}
		
		protected function onLoadedData(event:Event):void
		{
			m_loader.removeEventListener(Event.COMPLETE, onLoadedData);
			
			m_mapData = new XML(m_loader.data);
			m_loader = null;
			
			m_sceneW = m_mapData.@width;
			m_sceneH = m_mapData.@height;
			
			var farBgUrl : String = m_mapData.farLayer.@path;
			var nearBgUrl : String = m_mapData.nearLayer.@path;
			m_farTextureName = farBgUrl.substring(0,farBgUrl.lastIndexOf("."));
			m_nearTextureName = nearBgUrl.substr(0,nearBgUrl.lastIndexOf("."));
			m_assetManager.enqueue(m_urlString + farBgUrl);
			m_assetManager.enqueue(m_urlString + nearBgUrl);
			m_assetManager.loadQueue(onLoadedBg);
			
			var node : XML;
			for each(node in m_mapData.gameobject.children())
			{
				var nodeName : String = node.name();
				var subNode : XML;
				switch(nodeName)
				{
					case FLOOR_NODE:
					{
						for each(subNode in node.children()){
							createGameObject(subNode.@userData,subNode.@x,subNode.@y,FLOOR_NODE);
						}
						break;
					}
						
					case LADDER_NODE:
					{
						for each(subNode in node.children()){
							createGameObject(subNode.@userData,subNode.@x,subNode.@y,LADDER_NODE);
						}
						break;
					}
						
					case NPC_NODE:
					{
						for each(subNode in node.children()){
							createGameObject(subNode.@userData,subNode.@x,subNode.@y,NPC_NODE);
						}
						break;
					}
						
					case PLAYER_NODE:
					{
						createGameObject(subNode.@userData,node.@x,node.@y,PLAYER_NODE);
						break;
					}
						
						
					default:
					{
						break;
					}
				}
			}
		}
		
		private function onLoadedBg(ratio : Number) : void
		{
			if(ratio == 1){
				var image : Image = new Image(m_assetManager.getTexture(m_farTextureName));
				m_farLayer.addChild(image);
				
				image = new Image(m_assetManager.getTexture(m_nearTextureName));
				m_nearLayer.addChild(image);
			}
		}
		
		private function createGameObject(userData : String, x : Number, y : Number, type : String) : ActorBase
		{
			var actor : ActorBase;
			if(type == FLOOR_NODE)
				actor = ActorManager.instance.createFloor();
			else if(type == NPC_NODE)
				actor = ActorManager.instance.createNpc();
			else if(type == LADDER_NODE)
				actor = ActorManager.instance.createLadder();
			else if(type == PLAYER_NODE)
				actor = ActorManager.instance.createHero();
			
			actor.displayObject.x = x;
			actor.displayObject.y = y;
			actor.userData = userData;
			
			return actor;
		}
		
		public function update(t : Number) : void
		{
			updateViewPort();
		}
		
		private function updateViewPort():void
		{
			if(null == m_floowTarget) return;
			
			if(m_floowTarget.displayObject.x >= m_sceneW) m_floowTarget.displayObject.x = m_sceneW;
			if(m_floowTarget.displayObject.x <= 0) m_floowTarget.displayObject.x = 0;
			
			m_nearLayer.x = -m_floowTarget.displayObject.x/10;
			m_farLayer.x = -m_floowTarget.displayObject.x/20;
		}
		
		//相机锁定目标
		public function followTarget(actor : ActorBase) : void
		{
			m_floowTarget = actor;
			
			m_cam.working(null != actor);
			
			if(m_floowTarget) m_cam.goToTarget(actor.displayObject as Sprite);
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
		
		public function addStaticActor(actor : ActorBase) : void
		{
			if(!m_mapLayer.contains(actor.displayObject)){
				m_mapLayer.addChild(actor.displayObject);
			}
		}
		
		public function removeFloor(actor : ActorBase) : void
		{
			actor.displayObject.removeFromParent();
		}
		
		public function removeLadder(actor : ActorBase) : void
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
		
		private var m_mapData : XML;
		private var m_loader : URLLoader;
		private var m_sceneW : int;
		private var m_sceneH : int;
		private var m_floowTarget : ActorBase;
		private var m_cam : Fluocam;
		private var m_viewRect : Rectangle;
		private var m_assetManager : AssetManager;
		private var m_urlString : String;
		private var m_farTextureName : String;
		private var m_nearTextureName : String;
		
		private static const FLOOR_NODE : String = "floors";
		private static const LADDER_NODE : String = "ladders";
		private static const NPC_NODE : String = "npcs";
		private static const PLAYER_NODE : String = "player";
	}
}