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
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var hintmsg:MultiObject = create(modelName.HINT_MSG, [Hint]);
			hintmsg.Create_(1, "hintmsg");
			hintmsg.container.x = 960.3;
			hintmsg.container.y = 439.3;
			hintmsg.container.visible = false;
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(1);	
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);			
			dispatcher(new StringObject("sound_start_bet","sound" ) );
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if ( state == gameState.START_OPEN) 
			{
				
				GetSingleItem(modelName.HINT_MSG).gotoAndStop(4);
			}			
			if ( state == gameState.END_BET)
			{
				GetSingleItem(modelName.HINT_MSG).gotoAndStop(2);
				dispatcher(new StringObject("sound_stop_bet","sound" ) );
			}
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);			
			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "show_public_card_hint")]
		public function public_ard():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(5);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(3);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
		}
		
	}

}