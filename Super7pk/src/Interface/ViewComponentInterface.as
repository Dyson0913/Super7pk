package Interface 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author hhg4092
	 */
	public interface ViewComponentInterface 
	{
		function getDisplayobject():DisplayObjectContainer
		function getName():String;
		function setContainer(sp:DisplayObjectContainer):void;
		function getContainer():DisplayObjectContainer;
		function OnExit():void;
	}
	
}