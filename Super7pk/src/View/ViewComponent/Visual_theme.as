package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import caurina.transitions.properties.DisplayShortcuts;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import org.spicefactory.parsley.core.view.lifecycle.AutoremoveLifecycle;
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
	public class Visual_theme  extends VisualHandler
	{
		public const theme:String = "theme_7pk"		
		public const Zonetitle:String = "Zone_title"		
		
		public function Visual_theme() 
		{
			
		}
		
		public function init():void
		{
			//----------------------------------------------------------------bet
			//賠率提示
			var theme:MultiObject = create("theme", [theme]);			
			theme.container.x = 41.15;
			theme.container.y =  92.8;
			theme.Create_(1, "theme");
			
			put_to_lsit(theme);
			
			//Zonetitle
			var Zonetitle:MultiObject = create("Zonetitle", [Zonetitle]);
			Zonetitle.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			Zonetitle.Post_CustomizedData = [2,1204.0];
			Zonetitle.container.x = 266.15;
			Zonetitle.container.y = 67.35;
			Zonetitle.Create_(2, "theme");
			
			put_to_lsit(Zonetitle);			
			//----------------------------------------------------------------open_card			
			var table_hint:MultiObject = create("table_hint", [ResName.emptymc]);						
			table_hint.Create_(1, "table_hint");
			table_hint.container.x = 200;
			table_hint.container.y = 567;
			table_hint.container.visible = false;
			
			put_to_lsit(table_hint);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pre_open")]
		public function pre_open():void
		{
			GetSingleItem("theme").gotoAndStop(1);
			GetSingleItem("Zonetitle", 0).gotoAndStop(1);
			GetSingleItem("Zonetitle", 1).gotoAndStop(2);
			
			Get("table_hint").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			GetSingleItem("theme").gotoAndStop(1);
			GetSingleItem("Zonetitle", 0).gotoAndStop(1);
			GetSingleItem("Zonetitle", 1).gotoAndStop(2);
			
			Get("table_hint").container.visible = false;
			
			//more and more
			//  xxx. setting ....
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function opencard_parse():void
		{
			//TODO why to working
			//TODO open five or last 2
			//GetSingleItem("theme").gotoAndStop(2);
			GetSingleItem("theme")["Logo"].gotoAndPlay(2);
			
			//開牌中
			GetSingleItem("Zonetitle", 0).gotoAndStop(3);
			GetSingleItem("Zonetitle", 1).gotoAndStop(4);
			
			Get("table_hint").container.visible = true;
			
			//more and more
			//  xxx. setting ....
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			GetSingleItem("Zonetitle", 1).gotoAndStop(5);
			
			Get("table_hint").container.visible = false;
			
			//more and more
			//  xxx. setting ....
		}
		
	}

}