package Particles.Force
{
	import flash.geom.Point;
	
	public class PointField implements IForceField
	{
		private var _positionX:Number;
		private var _positionY:Number;
		private var _strength:Number;

		public function PointField(posX : Number, posY : Number, strength : Number)
		{
			_positionX = posX;
			_positionY = posY;
			_strength = strength;
		}
		
		/// x. y are the position of the particle
		public function forceInPoint(x:Number, y:Number):Point {
			/// Direction and distance
			var differenceX:Number = x - positionX;
			var differenceY:Number = y - positionY;
			
			var distance:Number = Math.sqrt(differenceX * differenceX + differenceY * differenceY);
			
			/// Falloff value which will reduce force strength
			var falloff:Number = 1.0 / (1.0 + distance);
			
			/// We normalize the direction, and use falloff and strength to calculate final force
			var forceX:Number = differenceX / distance * falloff * strength;
			var forceY:Number = differenceY / distance * falloff * strength;
			
			return new Point(forceX, forceY);
		}
		
		public function get positionX() : Number
		{
			return this._positionX;
		}
		
		public function set positionX(param1:Number) : void
		{
			this._positionX = param1;
		}
		
		public function get positionY() : Number
		{
			return this._positionY;
		}
		
		public function set positionY(param1:Number) : void
		{
			this._positionY = param1;
		}
		
		public function get strength() : Number
		{
			return this._strength;
		}
		
		public function set strength(param1:Number) : void
		{
			this._strength = param1;
		}

	}
}