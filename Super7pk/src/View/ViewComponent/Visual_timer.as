package View.ViewComponent 
{
	import flash.display.MovieClip;	
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_timer  extends VisualHandler
	{
		public const Timer:String = "countDowntimer";
		
		public var Waring_sec:int;
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{
		   var countDown:MultiObject = create(Timer,[Timer]);
		   countDown.Create_(1);
		   countDown.container.x = 1188;
		   countDown.container.y = 528;
		   
		   put_to_lsit(countDown);
		   disappear();
		   
		   Waring_sec = 7;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			disappear();
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			appear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function opencard_parse():void
		{
			disappear();
		}
		
		public function appear():void
		{
			Get(Timer).container.visible = true;	
			var time:int = _model.getValue(modelName.REMAIN_TIME);
			frame_setting_way(time);
			
			Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
		}
		
		public function disappear():void
		{
			Get(Timer).container.visible = false;			
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub, 1);
			if ( time < 0) return;
			if ( time <= Waring_sec ) dispatcher(new StringObject("sound_final", "sound" ) );
			
			
			frame_setting_way(time);			
		}
		
		public function frame_setting_way(time:int):void
		{
			var arr:Array = utilFun.arrFormat(time, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem(Timer)["_num_0"].gotoAndStop(arr[0]);
			GetSingleItem(Timer)["_num_1"].gotoAndStop(arr[1]);
		}		
		
	}

}