package View.ViewComponent 
{	
	import View.ViewBase.VisualHandler;
	import View.Viewutil.*;
	import util.*;
	
	import View.GameView.gameState;
	
	
	/**
	 * differ theme
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
			//賠率提示
			var theme:MultiObject = create("theme", [theme]);	
			theme.Create_(1);
			
			put_to_lsit(theme);
			
			//Zonetitle
			var Zonetitle:MultiObject = create("Zonetitle", [Zonetitle]);
			Zonetitle.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			Zonetitle.Post_CustomizedData = [2,1204.0];
			Zonetitle.container.x = 266.15;
			Zonetitle.container.y = 83.35;
			Zonetitle.Create_(2);
			
			put_to_lsit(Zonetitle);
			
			state_parse([gameState.NEW_ROUND,gameState.START_BET]);
		}
		
		override public function appear():void
		{	
			GetSingleItem("theme").gotoAndStop(1);
			GetSingleItem("theme")["Logo"].gotoAndStop(1);
			
			GetSingleItem("Zonetitle", 0).gotoAndStop(1);
			GetSingleItem("Zonetitle", 1).gotoAndStop(2);
			
			//more and more
			//  xxx. setting ....
		}
		
		override public function disappear():void
		{
			GetSingleItem("theme").gotoAndStop(2);
			GetSingleItem("theme")["Logo"].gotoAndStop(1);
			
			GetSingleItem("Zonetitle", 0).gotoAndStop(4);
			GetSingleItem("Zonetitle", 1).gotoAndStop(3);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle")]
		public function settle_cutomized():void
		{			
			//跑燈
			GetSingleItem("theme")["Logo"].gotoAndPlay(2);
			
			GetSingleItem("Zonetitle", 0).gotoAndStop(4);			
			GetSingleItem("Zonetitle", 1).gotoAndStop(5);
			
			//more and more
			//  xxx. setting ....
		}
		
	}

}