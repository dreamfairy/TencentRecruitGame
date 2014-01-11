package Particles.Colldier
{
	import flash.geom.Point;

	public class Box implements ICollider
	{
		private var _minPoint:Point;
		private var _maxPoint:Point;
		
		public function Box(minX : Number, minY : Number, maxX  : Number, maxY : Number)
		{
			this.minPoint = new Point(minX, minY);
			this.maxPoint = new Point(maxX, maxY);
		}
		
		public function collides(x:Number, y:Number):Boolean
		{
			var xInBounds:Boolean = this.minPoint.x < x && this.maxPoint.x > x;
			var yInBounds:Boolean = this.minPoint.y < y && this.maxPoint.y > y;
			return xInBounds && yInBounds;
		}
		
		public function get maxPoint() : Point
		{
			return this._maxPoint;
		}
		
		public function set maxPoint(param1:Point) : void
		{
			this._maxPoint = param1;
		}
		
		public function get minPoint() : Point
		{
			return this._minPoint;
		}
		
		public function set minPoint(param1:Point) : void
		{
			this._minPoint = param1;
		}
	}
}