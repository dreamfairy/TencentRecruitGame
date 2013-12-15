package Core.Manager.LayerManager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;

	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-9 下午5:43:35
	 */
	public class LayerManager
	{
		public function LayerManager()
		{
		}
		
		public static function get instance() : LayerManager
		{
			return m_instance||= new LayerManager();
		}
		
		public function init(root : flash.display.DisplayObjectContainer) : void
		{
			m_stage = root.stage;
			m_stage.addEventListener(Event.RESIZE, onResize);
			m_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			m_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			m_starlingLayer = new Sprite();
		}
		
		public function addEvent(event : IStageEvent) : void
		{
			if(m_stageEventList.indexOf(event) == -1)
				m_stageEventList.push(event);
		}
		
		public function removeEvent(event : IStageEvent) : void
		{
			var index : int = m_stageEventList.indexOf(event);
			if(-1 != index){
				m_stageEventList.splice(index, 1);
			}
		}
		
		public function get stage() : Stage
		{
			return m_stage;
		}
		
		public function get starlingLayer() : starling.display.DisplayObjectContainer
		{
			return m_starlingLayer;
		}
		
		public function set starlingLayer(layer : starling.display.DisplayObjectContainer) : void
		{
			m_starlingLayer = layer;
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			for each(var stageEvent : IStageEvent in m_stageEventList)
			{
				stageEvent.onKeyUp(event.keyCode);
			}
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			for each(var stageEvent : IStageEvent in m_stageEventList)
			{
				stageEvent.onKeyDown(event.keyCode);
			}
		}
		
		protected function onResize(event:Event):void
		{
			for each(var stageEvent : IStageEvent in m_stageEventList)
			{
				stageEvent.onResize(m_stage.stageWidth,m_stage.stageHeight);
			}
		}
		
		private static var m_instance : LayerManager;
		
		private var m_stageEventList : Vector.<IStageEvent> = new Vector.<IStageEvent>();
		private var m_stage : Stage;
		private var m_starlingLayer : starling.display.DisplayObjectContainer;
	}
}