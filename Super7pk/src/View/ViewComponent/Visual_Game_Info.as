package View.ViewComponent 
{	
	import View.ViewBase.VisualHandler;		
	import util.*;
	
	import View.Viewutil.*;
	import Res.ResName;	
	import View.GameView.gameState;

	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_Game_Info  extends VisualHandler
	{
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
			bet.Create_(2);
			bet.container.x = 132;
			bet.container.y = 48;
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
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