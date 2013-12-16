package Core.Actor.Entity
{
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import Core.Actor.ActorActionType;
	import Core.Actor.ActorBase;
	import Core.Actor.ActorType;
	import Core.Actor.JumpState;
	import Core.Manager.ActorManager;
	import Core.Manager.LayerManager.IStageEvent;
	import Core.Manager.LayerManager.LayerManager;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	import starling.textures.TextureSmoothing;
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
			m_jumpState = new JumpState(0.58,10, this);
			m_jumpState.onJumpping();
			m_jumpState.onComplete = onJumpOver;
		}
		
		public function onJumpOver() : void
		{
			var list : Vector.<ActorBase> = ActorManager.instance.getTargets(ActorType.FLOOR);
			var len : int = list.length;
			for(var i : int = 0; i < len; i++){
				var target : Floor = list[i];
				if(target.bounds.y <= (bounds.y + bounds.height - 10)) continue;
				RectangleUtil.intersect(bounds, target.bounds, m_helpRect);
				
				if(!m_helpRect.isEmpty()){
							return;
				}
			}
			
			m_jumpState.onJumpping();
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
			m_currentAction.smoothing = TextureSmoothing.NONE;
			Starling.juggler.add(m_currentAction);
			m_container.addChild(m_currentAction);
			
			m_currentAction.x = -m_currentAction.width/2;
			m_currentAction.y = -m_currentAction.height/2 - m_currentAction.texture.height/2;
		}
		
		protected function addActionCache(prefixName : String, type : uint) : void
		{
			var mc : MovieClip = new MovieClip(m_atals.getTextures(prefixName), 6);
			m_actionCache[type] = mc;
		}
		
		public function onKeyDown(code:uint):void
		{
			if(code in m_key) return;
			
			m_key[code] = true;
		}
		
		public function onKeyUp(code:uint):void
		{
			delete m_key[code];
			
			if(code == Keyboard.D || code == Keyboard.A){
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
				checkHitFloor(true);
			}
			
			m_needRush = Keyboard.SPACE in m_key;
			
			//只有开始下落时或者不再跳跃时，才检测地板
			if(m_jumpState.isInTop || m_currentActionType == ActorActionType.WALK){
				checkLadder(0);
				checkHitFloor();
			}
			
			m_jumpState.update(time);
		}
		
		protected function checkHitFloor(needCheckEnd : Boolean = false):void
		{
			var list : Vector.<ActorBase> = ActorManager.instance.getTargets(ActorType.FLOOR);
			var len : int = list.length;
			for(var i : int = 0; i < len; i++){
				var target : Floor = list[i];
				if(target.bounds.y <= (bounds.y + bounds.height - 10)) continue;
				RectangleUtil.intersect(bounds, target.bounds, m_helpRect);
				
				if(!m_helpRect.isEmpty()){
					if(needCheckEnd){
						if(target.userData != "true") continue;
						else{
							m_jumpState.stop(target.bounds.y);
							m_isOnLadder = false;
							return;
						}
					}else{
						m_jumpState.stop(target.bounds.y);
						return;
					}
				}
			}
			
			//如果遍历完找不到地面，切换到坠落状态
			if(!m_isOnLadder)
				m_jumpState.onJumpping();
		}
		
		protected function checkFloor(list : Vector.<ActorBase>, needCheckEnd : Boolean) : void
		{
			
		}
		
		protected function checkNpc() : Boolean
		{
			var list : Vector.<ActorBase> = ActorManager.instance.getTargets(ActorType.NPC);
			var len : int = list.length, i : int = 0;
			var target : ActorBase;
			
			for(i = 0; i < len; i++)
			{
				target = list[i];
				
				RectangleUtil.intersect(bounds, target.bounds, m_helpRect);
				
				if(!m_helpRect.isEmpty()){
					if(m_currentDialog && m_currentDialog.userData == target.userData) return true;
					m_currentDialog = ActorManager.instance.createDialog(target,target.displayObject.x, target.displayObject.y - target.displayObject.height);
					return true;
				}
			}
			
			return false;
		}
		
		private function checkTarget(speed : Number):void
		{
			//优先寻找梯子
			if(checkLadder(speed)) return;
			
			//之后寻找npc
			if(checkNpc()) return;
			
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
				
				if(!m_helpRect.isEmpty()){
					m_isOnLadder = true;
					clampLadder(target, speed);
					return true;
				}
			}
			
			m_isOnLadder = false;
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
			m_displayObject.x += m_needRush ? speed * 2.5 : speed;
			
			var scaleX : int = speed > 0 ? 1 : -1;
			if(scaleX != m_container.scaleX) 
				m_container.scaleX = scaleX;
			
			if(m_currentActionType != ActorActionType.WALK && !m_jumpState.isJumpping){
				changeAction(ActorActionType.WALK);
			}
			
			//移动后销毁对话窗口
			if(m_currentDialog){
				m_currentDialog.dispose();
				m_currentDialog = null;
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
		protected var m_isOnLadder : Boolean;

		//rush
		private var m_needRush : Boolean = false;
		
		//helper
		protected var m_helpRect : Rectangle = new Rectangle();
		
		private var m_currentDialog : ActorBase;
	}
}