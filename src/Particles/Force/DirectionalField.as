package Particles.Force
{
	import flash.geom.Point;
	
	public class DirectionalField implements IForceField
	{
		private var _forceVectorX:Number;
		private var _forceVectorY:Number;
		
		public function DirectionalField(forceX : Number, forceY : Number)
		{
			this._forceVectorY = forceY;
			this._forceVectorX = forceX;
		}
		
		public function forceInPoint(x:Number, y:Number):Point
		{
			return new Point(this.forceVectorX, this.forceVectorY);
		}
		
		public function get forceVectorX() : Number
		{
			return this._forceVectorX;
		}
		
		public function set forceVectorX(param1:Number) : void
		{
			this._forceVectorX = param1;
		}
		
		public function get forceVectorY() : Number
		{
			return this._forceVectorY;
		}
		
		public function set forceVectorY(param1:Number) : void
		{
			this._forceVectorY = param1;
		}
	}
}