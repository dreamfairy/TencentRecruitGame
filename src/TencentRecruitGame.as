package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import Core.Manager.StateMachine.StateMachineManager;
	
	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-9 下午4:44:28
	 */
	[SWF(frameRate="60",width="480",height="320")]
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
			
			var tf : TextField = new TextField();
			tf.text = "W,D 左右移动\n空格 加速,\nW,S 跳跃/上下楼梯\n与机器人重叠后按 W 可对话\n博客:http://www.dreamfairy.cn";
			tf.textColor = 0xFFFFFF;
			tf.width = tf.textWidth + 10;
			tf.filters = [new GlowFilter()];
			addChild(tf);
			tf.selectable = false;
		}
	}
}