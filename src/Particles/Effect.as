package Particles
{
	import flash.geom.Point;
	
	import Particles.Colldier.ICollider;
	import Particles.Emitter.IEmitter;
	import Particles.Force.IForceField;
	
	import starling.animation.IAnimatable;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Effect extends Sprite implements IAnimatable
	{
		private var _particlePool:Vector.<Particle>;
		private var _particles:Vector.<Particle>;
		private var _emitter:IEmitter;
		private var _texture:Texture;
		private var _spawPerSecond:Number;
		private var _setupParticle:Function;
		private var _forces:Vector.<IForceField>;
		private var _colliders:Vector.<ICollider>;
		private var _collisionResponse:Function;
		private var _spawnCounter:Number;
		
		public function Effect()
		{
			this._particlePool = new Vector.<Particle>;
			this._particles = new Vector.<Particle>;
			this._spawnCounter = 0;
			this._spawPerSecond = 10;
		}
		
		protected function requestParticle(createFun:Function) : Particle
		{
			return this._particlePool.length == 0 ? (createFun()) : (this._particlePool.pop());
		}
		
		protected function addParticleToThePool(param1:Particle) : void
		{
			this._particlePool.push(param1);
		}
		
		private function spawnParticle() : void
		{
			if (!this._texture || !this._emitter)
			{
				return;
			}
			var newParticle:* = this.requestParticle(function () : Particle
			{
				return new Particle(_texture);
			}
			);
			newParticle.init();
			var position:* = this._emitter.generatePosition();
			newParticle.x = position.x;
			newParticle.y = position.y;
			if (this._setupParticle != null)
			{
				this._setupParticle(newParticle);
			}
			this._particles.push(newParticle);
			this.addChild(newParticle);
		}
		
		private function calculateParticleAcceleration(particle:Particle) : Point
		{
			if (!this._forces)
			{
				return new Point();
			}
			var newPos : Point = new Point();
			for each (var force : IForceField in this._forces)
			{
				var velocoty : Point = force.forceInPoint(particle.x, particle.y);
				newPos.x = newPos.x + velocoty.x;
				newPos.y = newPos.y + velocoty.y;
			}
			newPos.x = newPos.x / particle.mass;
			newPos.y = newPos.y / particle.mass;
			return newPos;
		}

		
		public function advanceTime(time:Number):void
		{
			if(_emitter){
				_spawnCounter -= time;
				
				/// Using a loop to spawn multiple particles in a frame
				while (_spawnCounter <= 0) {
					/// Spawn the number of particles according to the passed time
					_spawnCounter += (1 / _spawPerSecond) * time;
					spawnParticle();
				}
			}

			var i:int = 0;
			
			/// using while loop so we can remove the particles from the container
			while (i < _particles.length) {
				var particle:Particle = _particles[i];
				
				/// Calculate particle accleration from all forces
				particle.acceleration = calculateParticleAcceleration(particle);
				
				/// Simulate particle
				particle.update(time);
				
				/// Go through the colliders and report collisions
				if (_colliders && _collisionResponse != null) {
					for each (var collider:ICollider in _colliders) {
						if (collider.collides(particle.x, particle.y)) {
							_collisionResponse(particle, collider);
						}
					}
				}
				
				/// remove particle if it's dead
				if (particle.isDead) {
					_particles.splice(i, 1);
					addParticleToThePool(particle);
					particle.removeFromParent();
				}
				else {
					/// We are in the while loop and need to increment the counter
					i++;   
				}
			}
		}
		
		public function get emitter() : IEmitter
		{
			return this._emitter;
		}
		
		public function set emitter(param1:IEmitter) : void
		{
			this._emitter = param1;
		}
		
		public function get texture() : Texture
		{
			return this._texture;
		}
		
		public function set texture(param1:Texture) : void
		{
			this._texture = param1;
		}
		
		public function get spawPerSecond() : Number
		{
			return this._spawPerSecond;
		}
		
		public function set spawPerSecond(param1:Number) : void
		{
			this._spawPerSecond = param1;
		}
		
		public function get setupParticle() : Function
		{
			return this._setupParticle;
		}
		
		public function set setupParticle(param1:Function) : void
		{
			this._setupParticle = param1;
		}
		
		public function get forces() : Vector.<IForceField>
		{
			return this._forces;
		}
		
		public function set forces(param1:Vector.<IForceField>) : void
		{
			this._forces = param1;
		}
		
		public function get colliders() : Vector.<ICollider>
		{
			return this._colliders;
		}
		
		public function set colliders(param1:Vector.<ICollider>) : void
		{
			this._colliders = param1;
		}
		
		public function get collisionResponse() : Function
		{
			return this._collisionResponse;
		}
		
		public function set collisionResponse(param1:Function) : void
		{
			this._collisionResponse = param1;
		}
	}
}