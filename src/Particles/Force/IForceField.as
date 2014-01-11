package Particles.Force
{
	import flash.geom.Point;

	public interface IForceField
	{
		function forceInPoint(x:Number, y:Number):Point;
	}
}