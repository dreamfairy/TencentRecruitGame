package
{
	import flash.geom.Point;
	
	import Particles.Effect;
	import Particles.Particle;
	import Particles.Colldier.Box;
	import Particles.Colldier.ICollider;
	import Particles.Emitter.Box;
	import Particles.Force.DirectionalField;
	import Particles.Force.IForceField;
	
	import starling.textures.Texture;

	public class SnowStorm extends Effect
	{
		private var _counter:Number;
		private var _wind:DirectionalField;
		
		public function SnowStorm(colliders : Vector.<ICollider> = null)
		{
			var worldCollision : Vector.<ICollider> = colliders;
			_counter = 0;
			this.texture = Texture.fromEmbeddedAsset(TencentRecruitGame.snowData);
			this.emitter = new Particles.Emitter.Box(-50,-40,640,100);
			this.spawPerSecond = 4;
			
			/// -20 is arbitrary number which worked well when testing
			/// (9.81m/s/s is the actual acceleration due to gravity on Earth)
			var gravity:DirectionalField = new DirectionalField(0, -9.81 * -20);
			
			/// Initialization is not important; values will change in time
			_wind = new DirectionalField(1, 0);
			
			/// set forces to the effect
			this.forces = new <IForceField>[gravity, _wind];
			this.colliders = worldCollision;
			this.collisionResponse = function (particle : Particle, colldier : ICollider) : void
			{
				if(colldier is Particles.Colldier.Box){
					var box : Particles.Colldier.Box = colldier as Particles.Colldier.Box;
					var dis : Number = box.maxPoint.y - box.minPoint.y;
					var speed : Number = (particle.y - box.minPoint.y) / speed;
					var scale : Number = (particle.scaleX - .5)  / .5;
					if(speed >= scale){
						particle.movable = false;
					}
				}
			};
			
			this.setupParticle = function (param1:Particle) : void
			{
				param1.fadeInOut = true;
				param1.startingLife = 3 + Math.random();
				param1.velocity = Point.polar(30, Math.random() * Math.PI * 2);
				param1.rotation = Math.PI * 2 * Math.random();
				param1.scaleY = Math.random() * 0.5 + 0.5;
				param1.scaleX = Math.random() * 0.5 + 0.5;
			}
		}
		
		override public function advanceTime(param1:Number) : void
		{
			this._counter = this._counter + param1;
			this._wind.forceVectorX = Math.pow(Math.sin(this._counter) * 0.5 + 0.5, 4) * 150;
			this._wind.forceVectorY = Math.sin(this._counter * 100) * 20;
			super.advanceTime(param1);
		}
	}
}