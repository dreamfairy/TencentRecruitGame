package Core.Actor
{
	import starling.display.DisplayObject;

	public class ActorBase
	{
		public function ActorBase()
		{
		}
		
		public function get displayObject() : DisplayObject
		{
			return m_displayObject;
		}
		
		public function get type() : int
		{
			return 1;
		}
		
		public function update(time : Number) : void
		{
			
		}
		
		public function dispose() : void
		{
			
		}
		
		protected var m_displayObject : DisplayObject;
		protected var m_speed : Number = 1;
	}
}