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
			history_bg.container.x = 1253;
			history_bg.container.y =  175;
			history_bg.Create_(1, historybg);
			
			var history_symble:MultiObject = create(historysymble,  [historysymble] , history_bg.container);
			history_symble.container.x = 8;
			history_symble.container.y = 8;
			history_symble.Post_CustomizedData = [6, 60, 58.5 ];
			history_symble.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			history_symble.Create_(60, historysymble);
			
			put_to_lsit(history_bg);	
			put_to_lsit(history_symble);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pre_open")]
		public function pre_open():void
		{
			Get(historybg).container.visible = true;
			update_history();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			Get(historybg).container.visible = true;			
			update_history();
		}
		
		public function update_history():void
		{			
			for ( var i:int = 0; i < 60; i ++)
			{
				GetSingleItem(historysymble, i).gotoAndStop(1);			
			}
			
			var history_model:Array = _model.getValue("history_list");			
			Get(historysymble).CustomizedData = history_model;
			Get(historysymble).CustomizedFun = _regular.FrameSetting;
			Get(historysymble).FlushObject();			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function open_card():void
		{
			hide();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle")]
		public function settle():void
		{
			hide();
		}
		
		public function hide():void
		{
			Get(historybg).container.visible = false;
		}
		
	}

}