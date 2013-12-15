package Core.Manager.LayerManager
{
	import starling.display.Sprite;

	public class StarlingRootLayer extends Sprite
	{
		public function StarlingRootLayer()
		{
			LayerManager.instance.starlingLayer = this;
		}
	}
}