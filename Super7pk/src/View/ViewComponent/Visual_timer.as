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
		   countDown.Create_(1,Timer);
		   countDown.container.x = 1188;
		   countDown.container.y = 528;
		   countDown.container.visible = false;
		   
		   //TODO item test model put in here ?
		   //_model.putValue(modelName.REMAIN_TIME, 10);
		   				
			Waring_sec = 7;
			
			put_to_lsit(countDown);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			Get(Timer).container.visible = true;	
			var time:int = _model.getValue(modelName.REMAIN_TIME);
			frame_setting_way(time);
			
			Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pre_open")]
		public function pre_open():void
		{
			hide();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function timer_hide():void
		{			
			hide();
		}
		
		public function hide():void
		{
			Get(Timer).container.visible = false;
		}
		
	}

}