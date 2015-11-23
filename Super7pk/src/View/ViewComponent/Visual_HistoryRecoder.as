package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
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
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_HistoryRecoder  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_HistoryRecoder() 
		{
			
		}
		
		public function init():void
		{
			//歷史記錄
			var historytable:MultiObject = create("Historytable", [ResName.historytable]);
			historytable.container.x = 1290;
			historytable.container.y =  140;
			historytable.Create_(1, "Historytable");
			
			//結果歷史記錄		
			var historyball:MultiObject = create("historyball",  [ResName.historyball] ,   historytable.container);
			historyball.container.x = 6.5;
			historyball.container.y = 8.7;
			historyball.Post_CustomizedData = [6, 37.8, 37.9 ];
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Create_(60, "historyball");
			
			put_to_lsit(historytable);	
			put_to_lsit(historyball);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get("Historytable").container.visible = true;			
			update_history();
		}
		
		public function update_history():void
		{			
			for ( var i:int = 0; i < 60; i ++)
			{
				GetSingleItem("historyball", i).gotoAndStop(1);
				GetSingleItem("historyball", i)["_Text"].text = "";
				GetSingleItem("historyball", i)["_Special"].text = "";
				GetSingleItem("historyball", i)["_pair"].gotoAndStop(1);
			}
			
			var history_model:Array = _model.getValue("history_list");			
			Get("historyball").CustomizedData = history_model;
			Get("historyball").CustomizedFun = history_ball_Setting;
			Get("historyball").FlushObject();			
		}
		
		//{"player_pair": false, "winner": "BetBWPlayer", "banker_pair": false, "point": 4}
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{		
			//2,player  3,banker,4 tie ,5 sp
			var info:Object = data[idx];
			
			if ( _opration.getMappingValue(modelName.BIG_POKER_MSG,  info.winner) >= 2	)
			{
				var str:DI = _model.getValue(modelName.HIS_SHORT_MSG);	
				mc.gotoAndStop(5);
				mc["_Special"].text = str.getValue( info.winner);				
				return;
			}
			
			var frame:int = 0;
			if ( info.winner == "BetBWPlayer") frame = 2;			
			if ( info.winner == "BetBWBanker") frame = 3;
			if ( info.winner == "None") frame = 4;			
			mc.gotoAndStop(frame);
			mc["_Text"].text =  info.point;			
			
			if( info.banker_pair && info.player_pair) mc["_pair"].gotoAndStop(4);
			else if( info.banker_pair) mc["_pair"].gotoAndStop(2);
			else if ( info.player_pair) mc["_pair"].gotoAndStop(3);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("Historytable").container.visible = false;
		}
		
	}

}