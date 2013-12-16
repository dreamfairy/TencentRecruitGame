package Core.Actor.Entity
{
	import Core.Actor.ActorActionType;
	import Core.Actor.ActorType;
	import Core.Actor.JumpState;
	
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