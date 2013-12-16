package Core.Actor.Entity
{
	import flash.geom.Rectangle;
	
	import Core.Actor.ActorActionType;
	import Core.Actor.ActorType;
	import Core.Actor.JumpState;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-16 下午2:50:42
	 */
	public class Npc extends Hero
	{
		public function Npc(textureAtlas:TextureAtlas)
		{
			super(textureAtlas);
			
			addActionCache("robot_idle",ActorActionType.IDLE);
			addActionCache("robot_walk",ActorActionType.WALK);
			
			m_container = new Sprite();
			m_displayObject = m_container;
			changeAction(ActorActionType.IDLE);
			m_jumpState = new JumpState(0.58,15, this);
			m_jumpState.onJumpping();
		}
		
		protected override function changeAction(type : uint) : void
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
			m_currentAction.y = -m_currentAction.texture.height - 15;
		}
		
		public override function get bounds():Rectangle
		{
			m_bounds.width = m_currentAction.texture.width;
			m_bounds.height = m_currentAction.texture.height;
			m_bounds.x = m_displayObject.x + m_bounds.width/2;
			m_bounds.y = m_displayObject.y;
			return m_bounds;
		}
		
		public override function update(time:Number):void
		{
			//只有开始下落时或者不再跳跃时，才检测地板
			if(m_jumpState.isInTop || m_currentActionType == ActorActionType.WALK){
				checkHitFloor();
			}
			
			m_jumpState.update(time);
		}
		
		public override function get type():int
		{
			return ActorType.NPC;
		}
	}
}