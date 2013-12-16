package Core.Actor.Entity
{
	import Core.Actor.ActorBase;
	import Core.Actor.ActorType;
	import Core.Manager.ActorManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	public class Dialog extends ActorBase
	{
		public function Dialog(textureAtlas:TextureAtlas, content : String)
		{
			super(textureAtlas);
			
			m_image = new Image(textureAtlas.getTexture("dialog"));
			m_tf = new TextField(m_image.width,m_image.height, content);
			m_container = new Sprite();
			m_container.touchable = false;
			m_container.addChild(m_image);
			m_container.addChild(m_tf);
			
			userData = content;
			m_displayObject = m_container;
		}
		
		public override function dispose():void
		{
			ActorManager.instance.removeActor(this);
			m_image.removeFromParent(true);
			m_tf.removeFromParent(true);
			m_container.removeFromParent(true);
		}
		
		public override function get type():int
		{
			return ActorType.DIALOG;
		}
		
		private var m_image : Image;
		private var m_tf : TextField;
		private var m_container : Sprite;
	}
}