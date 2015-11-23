package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import org.spicefactory.parsley.core.view.lifecycle.AutoremoveLifecycle;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	

	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_Game_Info  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = create("game_title_info" ,[ResName.TextInfo]);
			bet.CustomizedFun = _text.textSetting;
			bet.CustomizedData = [{size:22,color:0xCCCCCC}, "局號:",_model.getValue("game_round").toString()];
			bet.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting
			bet.Post_CustomizedData = [2,50,0];
			bet.Create_(2, "game_title_info");
			bet.container.x = 302;
			bet.container.y = 48;		
			
			put_to_lsit(bet);			
		}
			
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function show():void
		{			
			var round_code:int = _model.getValue("game_round");
			flush_round_code(round_code);
		}	
		
		public function flush_round_code(round_code:int): void
		{
			GetSingleItem("game_title_info", 1).getChildByName("Dy_Text").text = round_code.toString();	
		}
		
	}

}