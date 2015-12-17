package View.ViewComponent 
{	
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;	
	
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
			history_symble.container.y = 159.95;
			history_symble.Post_CustomizedData = [6, 62.2, 60.95 ];
			history_symble.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			history_symble.Create_(60);			
			
			put_to_lsit(history_bg);	
			put_to_lsit(history_symble);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function pre_open():void
		{
			Get(historybg).container.visible = true;
			update_history();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			Get(historybg).container.visible = false;
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{
			Get(historybg).container.visible = true;
			update_history();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function opencard_parse():void
		{
			Get(historybg).container.visible = false;
		}
		
		public function update_history():void
		{			
			var history_model:Array = _model.getValue("history_list");			
			
			Get(historysymble).CustomizedData = history_model;
			Get(historysymble).CustomizedFun = history_ball_Setting;
			Get(historysymble).FlushObject();
		}
		
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			var info:Object = data[idx];
			var frame:int = _opration.getMappingValue(modelName.BIG_POKER_MSG,  info.winner);	
			mc.gotoAndStop(frame);			
		}
	}

}