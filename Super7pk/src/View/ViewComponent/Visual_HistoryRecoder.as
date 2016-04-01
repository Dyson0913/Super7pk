package View.ViewComponent 
{	
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;	
	import Model.*;
	import util.*;	
	
	import View.Viewutil.*;
	import View.GameView.gameState;
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_HistoryRecoder  extends VisualHandler
	{	
		public const historybg:String = "history_table";
		public const historysymble:String = "history_ball";		
		
		public function Visual_HistoryRecoder() 
		{
			
		}
		
		public function init():void
		{
			var history_bg:MultiObject = create(historybg, [historybg]);			
			history_bg.Create_(1);
			history_bg.container.visible = false;
			
			var history_symble:MultiObject = create(historysymble,  [historysymble] , history_bg.container);
			history_symble.container.x = 1246.55;
			history_symble.container.y = 149.95;
			history_symble.Post_CustomizedData = [6, 62.2, 60.95 ];
			history_symble.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			history_symble.Create_(60);
			
			state_parse([gameState.NEW_ROUND, gameState.START_BET]);
		}
		
		override public function appear():void
		{
			Get(historybg).container.visible = true;
			update_history();
		}
		
		override public function disappear():void
		{
			Get(historybg).container.visible = false;	
		}
		
		public function update_history():void
		{			
			var history_model:Array = _model.getValue("history_list");
			
			//setFrame(historysymble, 1);		
			var history:MultiObject = Get(historysymble);
			var len:int = history.ItemList.length;
			for (var i:int =0; i < len; i++)
			{
				GetSingleItem(historysymble, i).gotoAndStop(1);
				//GetSingleItem(historysymble, i)["ghost"].gotoAndStop(1);
			}
			
			
			history.CustomizedData = history_model;
			history.CustomizedFun = history_ball_Setting;
			history.FlushObject();
		}
		
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			var info:Object = data[idx];
			var frame:int = _opration.getMappingValue(modelName.BIG_POKER_MSG,  info.winner);	
			mc.gotoAndStop(frame);
			
			//ghost
			//if ( info.ghost == 1)
			//mc["ghost"].gotoAndStop(2);
		}
		
		override public function test_suit():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if (  state == gameState.NEW_ROUND ||  state == gameState.START_BET )
			{
				test_visible( Get(historybg).container , true);	
			}
			else if ( state != 0)
			{
				test_visible( Get(historybg).container, false);	
			}
			else
			{
				Log("Visual_HistoryRecoder not  handle");
			}
		}
	}

}