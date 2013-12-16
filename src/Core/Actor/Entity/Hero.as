package Core.Actor.Entity
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import Core.Actor.ActorActionType;
	import Core.Actor.ActorBase;
	import Core.Actor.ActorType;
	import Core.Actor.JumpState;
	import Core.Manager.ActorManager;
	import Core.Manager.LayerManager.IStageEvent;
	import Core.Manager.LayerManager.LayerManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.RectangleUtil;

	public class Hero extends ActorBase implements IStageEvent
	{
		public function Hero(textureAtlas : TextureAtlas)
		{
			super(textureAtlas);
			m_speed = 2;
			m_clampSpeed = 1;
			
			LayerManager.instance.addEvent(this);
			
			addActionCache("hero_idle",ActorActionType.IDLE);
			addActionCache("hero_walk",ActorActionType.WALK);
			
			m_container = new Sprite();
			m_displayObject = m_container;
			changeAction(ActorActionType.IDLE);
			m_jumpState = new JumpState(0.58,15, this);
			m_jumpState.onJumpping();
			
			var test : BitmapData = new BitmapData(16,16,false,0xFF0000);
			var t : Texture = Texture.fromBitmapData(test);
			var img : Image = new Image(t);
			m_container.addChild(img);
		}
		
		public override function get bounds():Rectangle
		{
			m_bounds.width = m_currentAction.texture.width;
			m_bounds.height = m_currentAction.texture.height;
			m_bounds.x = m_displayObject.x - m_bounds.width/2;
			m_bounds.y = m_displayObject.y - m_bounds.height;
			return m_bounds;
		}
		
		public override function get type():int
		{
			return ActorType.HERO;
		}
		
		protected function changeAction(type : uint) : void
		{
			if(m_currentAction){
				Starling.juggler.remove(m_currentAction);
				m_currentAction.removeFromParent();
			}
			
			m_currentActionType = type;
			
			m_currentAction = m_actionCache[type];
			Starling.juggler.add(m_currentAction);
			m_container.addChild(m_currentAction);
			
			m_currentAction.x = m_container.scaleX == 1 ? -m_currentAction.width/2 : -m_currentAction.width/2;
			m_currentAction.y = -(m_currentAction.height - m_currentAction.texture.height/2);
		}
		
		protected function addActionCache(prefixName : String, type : uint) : void
		{
			var mc : MovieClip = new MovieClip(m_atals.getTextures(prefixName));
			m_actionCache[type] = mc;
		}
		
		public function onKeyDown(code:uint):void
		{
			if(code in m_key) return;
			
			m_key[code] = true;
			
			if(code == Keyboard.D || code == Keyboard.A){
				if(!m_needRush){
					if(m_waitSecondHit && m_lastRushKey == code){
						var nowTime : int = getTimer();
						if(nowTime - m_firstRushKeyDownTime <= m_rushCheckInterval){
							m_needRush = true;;
						}else{
							m_waitSecondHit = false;
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
			
			if(code == Keyboard.D || code == Keyboard.A){
				if(!m_waitSecondHit){
					m_waitSecondHit = true;
					m_lastRushKey = code;
					m_firstRushKeyDownTime = getTimer();
				}
				
				if(m_needRush){
					m_waitSecondHit = false;
					m_needRush = false;
				}
				
				changeAction(ActorActionType.IDLE);
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
				checkTarget(-m_clampSpeed);
			}
			
			if(m_key[Keyboard.S]){
				checkLadder(m_clampSpeed);
				checkHitFloor();
			}
			
			//只有开始下落时或者不再跳跃时，才检测地板
			if(m_jumpState.isInTop || m_currentActionType == ActorActionType.WALK){
				checkHitFloor();
			}
			
			m_jumpState.update(time);
		}
		
		protected function checkHitFloor():void
		{
			checkFloor(ActorManager.instance.getTargets(ActorType.FLOOR));
		}
		
		protected function checkFloor(list : Vector.<ActorBase>) : void
		{
			var len : int = list.length;
			for(var i : int = 0; i < len; i++){
				var target : ActorBase = list[i];
				RectangleUtil.intersect(bounds, target.bounds, m_helpRect);
				
				if(!m_helpRect.isEmpty()){
					m_jumpState.stop(target.bounds.y);
					return;
				}
				
				//如果遍历完找不到地面，切换到坠落状态
				m_jumpState.onJumpping();
			}
		}
		
		private function checkTarget(speed : Number):void
		{
			//优先寻找梯子
			if(checkLadder(speed)) return;
			
			//之后寻找npc
			
			//什么都找不到，开启跳跃
			m_jumpState.jump();
			changeAction(ActorActionType.IDLE);
		}
		
		private function checkLadder(speed : Number) : Boolean
		{
			var list : Vector.<ActorBase> = ActorManager.instance.getTargets(ActorType.LADDER);
			var len : int = list.length, i : int = 0;
			var target : ActorBase;
			
			
			for(i = 0; i < len; i++)
			{
				target = list[i];
				RectangleUtil.intersect(bounds, target.bounds, m_helpRect);
				
				trace(bounds, target.bounds);
				if(!m_helpRect.isEmpty()){
					trace("找到梯子啦", target.bounds.x, target.bounds.y);
					clampLadder(target, speed);
					return true;
				}
			}
			
			return false;
		}
		
		//爬梯子
		private function clampLadder(target : ActorBase, speed : Number) : void
		{
			this.displayObject.y += speed;
		}
		
		private function checkFunc(target : ActorBase, index : int, list : Vector.<ActorBase>) : void
		{
			switch(target.type)
			{
				default:
					m_jumpState.jump();
					changeAction(ActorActionType.IDLE);
					break;
			}
		}
		
		private function move(speed : Number) : void
		{
			m_displayObject.x += m_needRush ? speed * 2 : speed;
			
			var scaleX : int = speed > 0 ? 1 : -1;
			if(scaleX != m_container.scaleX) 
				m_container.scaleX = scaleX;
			
			if(m_currentActionType != ActorActionType.WALK && !m_jumpState.isJumpping){
				changeAction(ActorActionType.WALK);
			}
		}
		
		protected var m_key : Object = new Object();
		protected var m_actionCache : Dictionary = new Dictionary();
		protected var m_currentAction : MovieClip;
		protected var m_currentActionType : uint;
		protected var m_container : DisplayObjectContainer;
		
		//jump
		protected var m_jumpState : JumpState;
		
		//clamp
		protected var m_clampSpeed : Number;
		
		private var m_rushCheckInterval : Number = 500;
		private var m_needRush : Boolean = false;
		private var m_lastRushKey : uint;
		private var m_firstRushKeyDownTime : uint;
		private var m_waitSecondHit : Boolean;
		
		//helper
		protected var m_helpRect : Rectangle = new Rectangle();
	}
}