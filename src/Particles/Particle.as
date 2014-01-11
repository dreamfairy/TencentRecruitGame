package Particles
{
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	public class Particle extends Image
	{
		private var _startingLife:Number;
		private var _currentLife:Number;
		private var _velocity:Point;
		private var _acceleration:Point;
		private var _mass:Number;
		private var _fadeInOut:Boolean;
		private var _movable:Boolean;
		private var _alphaModifier:Number;
		private var _angularVelocity:Number;
		
		public function Particle(texture:Texture)
		{
			super(texture);
			this.pivotX = this.width / 2;
			this.pivotY = this.height / 2;
		}
		
		public function init() : void
		{
			this._currentLife = 10;
			this._startingLife = 10;
			this._velocity = new Point();
			this._acceleration = new Point();
			this._fadeInOut = false;
			this._mass = 1;
			this._movable = true;
			this._alphaModifier = 1;
			this._angularVelocity = 0;
			this.alpha = 1;
			this.color = Color.WHITE;
			this.rotation = 0;
		}
		
		public function get isDead() : Boolean
		{
			return this._currentLife < 0;
		}
		
		public function get startingLife() : Number
		{
			return this._startingLife;
		}
		
		public function set startingLife(value:Number) : void
		{
			this._startingLife = value;
			this._currentLife = value;
		}
		
		public function get velocity() : Point
		{
			return this._velocity;
		}
		
		public function set velocity(param1:Point) : void
		{
			this._velocity = param1;
		}
		
		public function get fadeInOut() : Boolean
		{
			return this._fadeInOut;
		}
		
		public function set fadeInOut(param1:Boolean) : void
		{
			this._fadeInOut = param1;
		}
		
		public function get mass() : Number
		{
			return this._mass;
		}
		
		public function set mass(param1:Number) : void
		{
			this._mass = param1;
		}
		
		public function get acceleration() : Point
		{
			return this._acceleration;
		}
		
		public function set acceleration(param1:Point) : void
		{
			this._acceleration = param1;
		}
		
		public function get movable() : Boolean
		{
			return this._movable;
		}
		
		public function set movable(param1:Boolean) : void
		{
			this._movable = param1;
		}
		
		public function get alphaModifier() : Number
		{
			return this._alphaModifier;
		}
		
		public function set alphaModifier(param1:Number) : void
		{
			this._alphaModifier = param1;
		}
		
		public function get angularVelocity() : Number
		{
			return this._angularVelocity;
		}
		
		public function set angularVelocity(param1:Number) : void
		{
			this._angularVelocity = param1;
		}

		
		public function update(dt : Number) : void
		{
			this._currentLife = this._currentLife - dt;
			if(this._movable)
			{
				/// update position with velocity
				x += _velocity.x * dt;
				y += _velocity.y * dt;
				
				/// update velocity whith acceleration
				_velocity.x += _acceleration.x * dt;
				_velocity.y += _acceleration.y * dt;
				rotation = rotation + this._angularVelocity * dt;
			}
			
			var nowAniPercent : Number = 1 - this._currentLife / this._startingLife;
			if(this._fadeInOut)
			{
				if(nowAniPercent < .25)
					this.alpha = nowAniPercent / .25 * this._alphaModifier;
				else if(nowAniPercent < .75)
					this.alpha = this._alphaModifier;
				else
					this.alpha = (1 - nowAniPercent) / .25 * this.alphaModifier;
			}
		}
	}
}