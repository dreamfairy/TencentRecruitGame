package Core.Actor.Entity
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import Core.Actor.ActorBase;
	import Core.Actor.ActorType;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * Author : 苍白的茧
	 * Date : 2013-12-16 下午2:49:55
	 */
	public class Floor extends ActorBase
	{
		public function Floor(textureAtlas:TextureAtlas)
		{
			super(textureAtlas);
			
			m_image = new Image(textureAtlas.getTexture("floor"));
			m_displayObject = new Sprite();
			Sprite(m_displayObject).addChild(m_image);
			
			m_bounds.width = m_image.texture.width;
			m_bounds.height = m_image.texture.height;
			
//			var test : BitmapData = new BitmapData(16,16,false,0xFF0000);
//			var t : Texture = Texture.fromBitmapData(test);
//			var img : Image = new Image(t);
//			Sprite(m_displayObject).addChild(img);
		}
		
		public override function get bounds():Rectangle
		{
			m_bounds.x = m_displayObject.x;
			m_bounds.y = m_displayObject.y;
			return m_bounds;
		}
		
		public override function get type():int
		{
			return ActorType.FLOOR;
		}
		
		private var m_image : Image;
	}
}