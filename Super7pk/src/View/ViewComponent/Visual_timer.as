package View.ViewComponent 
{
	import flash.display.MovieClip;	
	import View.ViewBase.VisualHandler;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;	
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * timer present way
	 * @author Dyson0913
	 */
	public class Visual_timer  extends VisualHandler
	{
		public const Timer:String = "countDowntimer";
		
		public var Waring_sec:int;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _betTimer:Visual_betTimer;
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{
		   var countDown:MultiObject = create(Timer,[Timer]);
		   countDown.Create_(1);
		   countDown.container.x = 1165;
		   countDown.container.y = 490;
		   
		   Waring_sec = 7;
		   
		   state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			setFrame(Timer, 2);
			var time:int = _model.getValue(modelName.REMAIN_TIME);
			frame_setting_way(time);
			
			Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
		}
		
		override public function disappear():void
		{	
			setFrame(Timer, 1);			
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub, 1);
			if ( time < 0) 
			{
				return;
			}
			if ( time <= Waring_sec ) play_sound("sound_final");
			
			if (time == 0) {
				//注區停止押注
				var betzone:MultiObject = Get("betzone_s");
				betzone.mousedown = null;
				betzone.mouseup = null;
				betzone.rollout = null;
				betzone.rollover = null;
			
				//送出最後一張還在計時的注單
				_betTimer.send_bet(_betTimer.current_idx);
			}
			
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
		
		override public function test_suit():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if ( state == gameState.START_BET )
			{
				test_frame_Not_equal( GetSingleItem(Timer) , 2);	
			}
			else if ( state != 0)
			{
				test_frame_Not_equal( GetSingleItem(Timer) , 1);	
			}
			else
			{
				Log("Visual_timer not  handle");
			}
		}
	}

}