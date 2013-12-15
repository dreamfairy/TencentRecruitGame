package Core.Actor
{
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import Core.Manager.ActorManager;
	import Core.Manager.LayerManager.IStageEvent;
	import Core.Manager.LayerManager.LayerManager;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class Hero extends ActorBase implements IStageEvent
	{
		[Embed(source="../../../test.jpg")]
		private var testClass : Class;
		
		public function Hero()
		{
			super();
			m_speed = 5;
			
			LayerManager.instance.addEvent(this);
			var bm : Bitmap = new testClass();
			var texture : Texture = Texture.fromBitmapData(bm.bitmapData);
			m_displayObject = new Image(texture);
			m_jumpState = new JumpState(0.58,15, this);
		}
		
		public function onKeyDown(code:uint):void
		{
			if(code in m_key) return;
			
			m_key[code] = true;
			
			if(code == Keyboard.D || code == Keyboard.A){
				if(!m_needRush){
					if(!m_waitSecondHit){
						m_waitSecondHit = true;
						m_lastRushKey = code;
						m_firstRushKeyDownTime = getTimer();
						return;
					}
					
					if(m_waitSecondHit && m_lastRushKey == code){
						if(getTimer() - m_firstRushKeyDownTime <= m_rushCheckInterval){
							m_needRush = true;
						}
					}else{
						m_waitSecondHit = false;
					}
				}
			}
		}
		
		public function onKeyUp(code:uint):void
		{
			delete m_key[code];
			
			if(m_needRush && (code == Keyboard.D || code == Keyboard.A)){
				m_needRush = false;
				m_waitSecondHit = false;
				m_lastRushKey = 0;
			}
		}
		
		public function onResize(width:uint, height:uint):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public override function update(time:Number):void
		{
			if(m_key[Keyboard.A]){
				move(-m_speed);
			}
			
			if(m_key[Keyboard.D]){
				move(m_speed);
			}
			
			if(m_key[Keyboard.W]){
				checkTarget();
			}
			
			if(m_jumpState.isJumpping){
				checkHitFloor();
			}
			
			m_jumpState.update(time);
		}
		
		private function checkHitFloor():void
		{
			
		}
		
		private function checkTarget():void
		{
			ActorManager.instance.checkTargets(checkFunc);
		}
		
		private function checkFunc(target : ActorBase, index : int, list : Vector.<ActorBase>) : void
		{
			switch(target.type)
			{
				default:
					m_jumpState.jump();
					break;
			}
		}
		
		private function move(speed : Number) : void
		{
			m_displayObject.x += m_needRush ? speed * 2 : speed;
		}
		
		protected var m_key : Object = new Object();
		
		private var m_rushCheckInterval : Number = 500;
		private var m_needRush : Boolean = false;
		private var m_lastRushKey : uint;
		private var m_firstRushKeyDownTime : uint;
		private var m_waitSecondHit : Boolean;
		
		//jump
		private var m_jumpState : JumpState;
	}
}