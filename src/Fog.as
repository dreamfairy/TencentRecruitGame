package
{
	import flash.geom.Point;
	
	import Particles.Effect;
	import Particles.Particle;
	import Particles.Emitter.Box;
	
	import starling.textures.Texture;
	
	public class Fog extends Effect
	{
		public function Fog()
		{
			this.texture = Texture.fromEmbeddedAsset(TencentRecruitGame.fogData);
			
			/// Cover large portion of the screen
			this.emitter = new Box(0, 40, 640, 400);
			
			/// We want just a few of the particles on screen at a time
			this.spawPerSecond = 0.05;
			
			this.setupParticle = function(particle:Particle):void {
				/// Move slowly in one direction
				particle.velocity = Point.polar(50, Math.random() * Math.PI * 2.0);
				
				particle.fadeInOut = true;
				
				/// [3, 4> seconds of life
				particle.startingLife = 3 + Math.random();
				
				particle.alphaModifier = 0.3;
				
				/// Random rotation [0, 360> degrees
				particle.rotation = Math.PI * 2.0 * Math.random();
				
				/// Rotate <-0.5, 0.5] radians per second
				particle.angularVelocity = (1 - Math.random() * 2) * 0.5;
				
				/// Set the scale to [1, 2>
				particle.scaleX = particle.scaleY = Math.random() + 1;
				
			};
		}
	}
}