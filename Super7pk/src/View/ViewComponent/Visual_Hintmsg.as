package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Hintmsg  extends VisualHandler
	{
		public const Hint:String = "HintMsg";
		
		private var frame_start_bet:int = 2;
		private var frame_stop_bet:int = 3;
		private var frame_pre_open:int = 4;
		private var frame_open_card:int = 5;
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var Hintmsg:MultiObject = create(Hint, [Hint]);
			Hintmsg.Create_(1);
			Hintmsg.container.x = 951.65;
			Hintmsg.container.y = 517.80;		
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function pre_open():void
		{
			GetSingleItem(Hint).gotoAndStop(frame_pre_open);
			//_regular.FadeIn( GetSingleItem(Hint), 2, 2, _regular.Fadeout);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			GetSingleItem(Hint).gotoAndStop(frame_start_bet);
			_regular.FadeIn( GetSingleItem(Hint), 2, 2, _regular.Fadeout);
			play_sound("sound_start_bet");
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			GetSingleItem(Hint).gotoAndStop(frame_stop_bet);
			_regular.FadeIn( GetSingleItem(Hint), 2, 2, _regular.Fadeout);
			play_sound("sound_stop_bet");			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function openCard():void
		{			
			GetSingleItem(Hint).gotoAndStop(frame_open_card);			
			_regular.FadeIn( GetSingleItem(Hint), 2, 2, _regular.Fadeout);			
		}	
		
	}

}