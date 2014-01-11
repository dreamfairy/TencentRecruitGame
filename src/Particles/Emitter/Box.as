package Particles.Emitter
{
	import flash.geom.Point;

	public class Box implements IEmitter
	{
		
		private var minPoint:Point;
		private var maxPoint:Point;
		
		public function Box(minX : Number, minY : Number, maxX  : Number, maxY : Number)
		{
			this.minPoint = new Point(minX, minY);
			this.maxPoint = new Point(maxX, maxY);
		}
		
		public function generatePosition():Point {
			var randomX:Number = Math.random() * (maxPoint.x - minPoint.x) + minPoint.x;
			var randomY:Number = Math.random() * (maxPoint.y - minPoint.y) + minPoint.y;
			return new Point(randomX, randomY);
		}
	}
}