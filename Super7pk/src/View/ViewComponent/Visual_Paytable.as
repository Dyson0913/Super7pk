package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
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
	public class Visual_Paytable  extends VisualHandler
	{
		public const paytablemain:String = "paytable_main"		
		public const paytable_baridx:String = "paytable_bar_idx";
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{			
			//賠率提示
			var paytable:MultiObject = create("paytable", [paytablemain]);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 230;
			paytable.container.y =  124;
			paytable.Create_(1, "paytable");
			
			var paytable_baridx:MultiObject = create("paytable_baridx", [paytable_baridx]);
			paytable_baridx.container.x = paytable.container.x;
			paytable_baridx.container.y = paytable.container.y;
			paytable_baridx.Create_(1, "paytable_baridx");
			//paytable_baridx.ItemList[0].gotoAndStop(3);
			put_to_lsit(paytable);	
			put_to_lsit(paytable_baridx);	
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			GetSingleItem("paytable").gotoAndStop(1);
			GetSingleItem("paytable_baridx").gotoAndStop(1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			GetSingleItem("paytable").gotoAndStop(2);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			GetSingleItem("paytable").gotoAndStop(1);	
		}
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint(winstr:StringObject):void
		{
			var wintype:String = winstr.Value;
			utilFun.Log("winst = " + wintype);
			
			if ( wintype == "") return ;
			if (wintype ==  "WSWin" || wintype == "WSBWNormalWin")  return;
			if (wintype ==  "WSBWOnePairBig")  return;
			
			var y:int = 0;
			if (wintype == "WSBWStraight") y = 7;
			if ( wintype == "WSBWFlush") y = 6;
			if (wintype == "WSBWFullHouse") y = 5;
			if ( wintype == "WSBWFourOfAKind")y = 4;
			if ( wintype == "WSBWStraightFlush") y = 3;
			if ( wintype == "WSBWRoyalFlush") y = 2;			
			
			GetSingleItem("paytable_baridx").gotoAndStop(y);
			
			//utilFun.Log("GetSingleItem =" + GetSingleItem("pay_text"));						
			//GetSingleItem("pay_text",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			//GetSingleItem("pay_mark",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			//GetSingleItem("pay_odd",y).getChildByName("Dy_Text").textColor = 0xFFFF00;
			
		}
		
		
	}

}