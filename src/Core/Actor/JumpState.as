package Core.Actor
{
	public class JumpState
	{
		public function JumpState(gravity : Number, power : Number, target : ActorBase)
		{
			m_target = target;
			m_gravity = gravity;
			m_power = power;
			m_state = JUMP_STATE_EXIT;
		}
		
		public function jump() : void
		{
			if(!m_isJumpping) onEnter();
		}
		
		public function update(t : Number) : void
		{
			if(m_state == JUMP_STATE_ENTER){
				m_velocity += m_gravity;
				m_velocity >= 0 ? onTop() : m_target.displayObject.y += m_velocity;
			}else if(m_state == JUMP_STATE_TOP){
				m_velocity += m_gravity;
				m_target.displayObject.y += m_velocity;
				
				if(m_target.displayObject.y >= m_jumpY) onExit();
			}
		}
		
		private function onEnter() : void
		{
			m_state = JUMP_STATE_ENTER;
			m_velocity = -m_power;
			m_jumpY = m_target.displayObject.y;
			m_isJumpping = true;
		}
		
		private function onTop() : void
		{
			m_state = JUMP_STATE_TOP;
			m_velocity = 0;
		}
		
		private function onExit() : void
		{
			m_state = JUMP_STATE_EXIT;
			m_target.displayObject.y = m_jumpY;
			m_isJumpping = false;
		}
		
		public function stop() :void
		{
			m_jumpY = m_target.displayObject.y;
			onExit();
		}
		
		public function get isJumpping() : Boolean
		{
			return m_isJumpping;
		}
		
		private var m_state : uint;
		private var m_target : ActorBase;
		private var m_gravity : Number;
		private var m_power : Number;
		private var m_velocity : Number;
		private var m_jumpY : Number;
		private var m_isJumpping : Boolean;
		
		private static const JUMP_STATE_ENTER : uint = 0;
		private static const JUMP_STATE_TOP : uint = 1;
		private static const JUMP_STATE_EXIT : uint = 2;
	}
}