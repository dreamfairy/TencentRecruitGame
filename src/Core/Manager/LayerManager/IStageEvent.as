package Core.Manager.LayerManager
{
	public interface IStageEvent
	{
		function onKeyUp(code : uint) : void;
		function onKeyDown(code : uint) : void;
		function onResize(width : uint, height : uint) : void;
	}
}