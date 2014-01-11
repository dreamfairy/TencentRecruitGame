package
{
	import Particles.Colldier.Box;
	import Particles.Colldier.ICollider;
	import Particles.Force.PointField;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;

	public class SnowScene extends Sprite
	{
		private var _mouseForce:PointField;
		
		public function SnowScene()
		{
//			var bgImg : Image = new Image(Texture.fromEmbeddedAsset(TencentRecruitGame.bgData));
//			this.addChild(bgImg);
			var box : Box = new Box(0,320,640,390);
			var snowStorm  : SnowStorm = new SnowStorm(new <ICollider>[box]);
			_mouseForce = new PointField(320,200,0);
			snowStorm.forces.push(_mouseForce);
			Starling.juggler.add(snowStorm);
			addChild(snowStorm);
//			var fog : Fog = new Fog();
//			Starling.juggler.add(fog);
//			this.addChild(fog);
//			var lightMap : Image = new Image(Texture.fromEmbeddedAsset(TencentRecruitGame.lightMapData));
//			lightMap.blendMode = BlendMode.MULTIPLY;
//			lightMap.alpha = .5;
//			this.addChild(lightMap);
		}
	}
}