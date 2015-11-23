package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_game_text  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_game_text() 
		{
			
		}
		
		public function init():void
		{			
			
			//手寫賠率表 paytext.getValue("WSBWTripple"), paytext.getValue("WSBWTwoPair")
			//var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			//var bet_text:MultiObject = create("pay_text", [ResName.TextInfo]);
			//bet_text.CustomizedFun = _text.textSetting;
			//bet_text.CustomizedData = [ { size:24, color:0x00b4ff, bold:true }, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight")];		
			//bet_text.Post_CustomizedData = [8, 50, 50];
			//bet_text.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			//bet_text.Create_(bet_text.CustomizedData.length -1, "pay_text");
			//bet_text.container.x = 262;
			//bet_text.container.y = 165;
			//
			//var pay_mark:MultiObject = create("pay_mark", [ResName.TextInfo]);
			//pay_mark.CustomizedFun = _text.textSetting;
			//pay_mark.CustomizedData = [ { size:24, color:0x00b4ff, bold:true }, "X", "X", "X", "X", "X", "X"];
			//pay_mark.Post_CustomizedData = [8, 50, 50];
			//pay_mark.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			//pay_mark.Create_(bet_text.CustomizedData.length -1, "pay_mark");
			//pay_mark.container.x = 482;
			//pay_mark.container.y = 165;
			//
			//var pay_odd:MultiObject = create("pay_odd", [ResName.TextInfo]);
			//pay_odd.CustomizedFun = _text.textSetting;
			//pay_odd.CustomizedData = [ { size:24, color:0x00b4ff, bold:true, align:TextFormatAlign.RIGHT }, "200", "50", "20", "3", "2", "1"];
			//pay_odd.Post_CustomizedData = [8, 50, 50];
			//pay_odd.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			//pay_odd.Create_(bet_text.CustomizedData.length -1, "pay_odd");
			//pay_odd.container.x = 32;
			//pay_odd.container.y = 165;
			//
			//var pay_title:MultiObject = create("pay_title",[ResName.TextInfo]);	
			//pay_title.CustomizedFun = _text.textSetting;
			//pay_title.CustomizedData = [{size:24,color:0xCCCCCC,align:TextFormatAlign.CENTER},"主注特殊牌型賠率"];		
			//pay_title.Create_(1, "pay_title");
			//pay_title.container.x = 179;
			//pay_title.container.y = 129;
			
			//var betlimit:MultiObject = create("betlimit",  [ResName.betlimit]);
			//betlimit.container.x = 40;
			//betlimit.container.y = 150;	
			//betlimit.Create_(1, "betlimit");
			//
			//var realtimeinfo:MultiObject = create("realtimeinfo", [ResName.realtimeinfo]);	
			//realtimeinfo.container.x = 1722;
			//realtimeinfo.container.y = 151;	
			//realtimeinfo.Create_(1, "realtimeinfo");	
			
			//_tool.SetControlMc(bet_text.container);			
			//_tool.SetControlMc(game_info_data.ItemList[3]);			
			//_tool.y = 200;
			//add(_tool);	
			
			put_to_lsit(bet);
			put_to_lsit(game_info_data);
			put_to_lsit(bet_text);
			put_to_lsit(pay_mark);
			put_to_lsit(pay_odd);
			put_to_lsit(pay_title);
			put_to_lsit(betlimit);
			put_to_lsit(realtimeinfo);
			
		}
		
		
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function show():void
		{
			apper();
			Get("betlimit").container.visible = true;
			Get("realtimeinfo").container.visible = true;
			
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[1]);			
			var round_code:int = _opration.operator("game_round", DataOperation.add,1);
			var textfi:TextField = _text.dynamic_text(round_code.toString(),{size:18});
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("betlimit").container.visible = false;
			Get("realtimeinfo").container.visible = false;
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC,align:TextFormatAlign.CENTER},"主注特殊牌型機率"];		
			Get("pay_title").FlushObject();
						
		}
		
		public function apper():void
		{			
			
			utilFun.Clear_ItemChildren(GetSingleItem("pay_title"));
			
			Get("pay_title").CustomizedData = [{size:24,color:0xCCCCCC,align:TextFormatAlign.CENTER},"主注特殊牌型賠率"];		
			Get("pay_title").FlushObject();
			
			for ( var i:int = 0; i < Get("pay_text").ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("pay_text", i));
				utilFun.Clear_ItemChildren(GetSingleItem("pay_mark", i));
				utilFun.Clear_ItemChildren(GetSingleItem("pay_odd",i));
			}
			
			var paytext:DI = _model.getValue(modelName.BIG_POKER_TEXT );
			Get("pay_text").CustomizedData = [{size:24,color:0x00b4ff,bold:true}, paytext.getValue("WSBWRoyalFlush"), paytext.getValue("WSBWStraightFlush"), paytext.getValue("WSBWFourOfAKind"), paytext.getValue("WSBWFullHouse"), paytext.getValue("WSBWFlush"), paytext.getValue("WSBWStraight")];		
			Get("pay_text").FlushObject();			
			
			Get("pay_mark").CustomizedFun = _text.textSetting;
			Get("pay_mark").CustomizedData = [ { size:24, color:0x00b4ff, bold:true },"X", "X", "X", "X", "X", "X", "X", "X"];		
			Get("pay_mark").FlushObject();
			
			Get("pay_odd").CustomizedFun = _text.textSetting;
			Get("pay_odd").CustomizedData = [{size:24,color:0x00b4ff,bold:true,align:TextFormatAlign.RIGHT},"200","50","20","3","2","1"];		
			Get("pay_odd").FlushObject();
			
		}
		
	//	[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{
			
		}
		
		
	}

}