package Core.Actor
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.textures.TextureAtlas;

	public class ActorBase
	{
		public function ActorBase(textureAtlas : TextureAtlas)
		{
			m_atals = textureAtlas;
		}
		
		public function get displayObject() : DisplayObject
		{
			return m_displayObject;
		}
		
		public function get type() : int
		{
			return 1;
		}
		
		public function get bounds() : Rectangle
		{
			return m_bounds;
		}
		
		public function update(time : Number) : void
		{
			
		}
		
		public function dispose() : void
		{
			
		}
		
		public function set userData(value : Object) : void
		{
			m_userData = value;
		}
		
		public function get userData() : Object
		{
			return m_userData;
		}
		
		protected var m_bounds : Rectangle = new Rectangle();
		protected var m_displayObject : DisplayObject;
		protected var m_atals : TextureAtlas;
		protected var m_speed : Number = 1;
		protected var m_userData : Object;
	}
}