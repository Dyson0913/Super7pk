package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.valueObject.Intobject;
	import util.DI;
	import View.ViewBase.ViewBase;	
	import View.Viewutil.MouseBehavior;;
	import Model.*;
	import util.utilFun;
	import View.Viewutil.Visual_package_replayer;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class HudView extends ViewBase
	{
		[Inject]
		public var _replayer:Visual_package_replayer;
		
		public function HudView()  
		{
			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
			_replayer.init();
		}
		
	
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
		}
		
		
	}

}