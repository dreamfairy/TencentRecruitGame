package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import Core.Manager.StateMachine.StateMachineManager;
	
	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-9 下午4:44:28
	 */
	[SWF(frameRate="60",width="1024",height="768")]
	public class TencentRecruitGame extends Sprite
	{
		public function TencentRecruitGame()
		{
			stage ? init() : addEventListener(Event.ADDED_TO_STAGE, init);	
		}
		
		private function init(e:Event = null) : void
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))
				removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;
			stage.stageFocusRect = false;
			stage.showDefaultContextMenu = false;
			
			if(stage.stageWidth > 0 && stage.stageHeight > 0){
				startup();
			}else{
				stage.addEventListener(Event.RESIZE, onResize);
			}
		}
		
		private function onResize(e:Event) : void
		{
			if(stage.stageWidth == 0 && stage.stageHeight == 0) return;
			
			stage.removeEventListener(Event.RESIZE, onResize);
			startup();
		}
		
		private function startup():void
		{
			StateMachineManager.instance.init(this);
			//没有其他的界面了，直接进入游戏
			StateMachineManager.instance.changeState(StateMachineManager.instance.playState);
		}
	}
}