package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	import View.ViewBase.VisualHandler;	
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import View.GameView.gameState;
	
	/**
	 * betzone present way
	 * @author Dyson0913
	 */
	public class Visual_betZone_Sence  extends VisualHandler
	{		
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_betZone_Sence() 
		{
			
		}
		
		public function init():void
		{			
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);			
			
			
			var res:Array = ["zone_dark"]
			var betzone_dark:MultiObject = create("betzone_dark", res);
			betzone_dark.container.x = 1560;
			betzone_dark.container.y = 791;
			betzone_dark.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			betzone_dark.Post_CustomizedData = [[0, 0] , [ -300, 0] , [ -600, 0] , [ -910, 0] , [ -1222, 0], [ -1536, 0], [ -31, -171], [ -312, -175], [ -597, -175], [ -892, -177], [ -1186, -177], [ -1481, -176]];	
			betzone_dark.Create_(12);
			
			put_to_lsit(betzone_dark);
			
			//for ( var i:int = 0; i < 12; i++)
			//{
				//var mc:MovieClip = GetSingleItem("betzone_dark", i);
				//mc.gotoAndStop(i + 2);
				//mc["_dark"].alpha = 0.5;
			//}
			
			
			var avaliblezone_s:Array =  ["zone_sense"];		
			var playerzone_s:MultiObject = create("betzone_s", avaliblezone_s);
			playerzone_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 1, 2, 1]);
			playerzone_s.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone_s.Post_CustomizedData = [[0, 0] , [ -300, 0] , [ -600, 0] , [ -910, 0] , [ -1222, 0], [ -1536, 0], [ -31, -171], [ -312, -175], [ -597, -175], [ -892, -177], [ -1186, -177], [ -1481, -176]];				
			playerzone_s.mousedown = null;
			playerzone_s.mouseup = null;
			playerzone_s.rollout = null;
			playerzone_s.rollover = null;
			playerzone_s.container.x = 1560;
			playerzone_s.container.y = 791;
			playerzone_s.Create_(12);
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = bet_sencer;
			betzone.mouseup = bet_sencer;
			betzone.rollout = bet_sencer;
			betzone.rollover = bet_sencer;
			
			var avaliblezone:Array = _model.getValue("round_paytable");			
			for ( var i:int = 0; i < avaliblezone.length ; i++)
			{
				var al:Number = 0;			
				if ( avaliblezone[i] == -1) al = 0.5;				
				
				var mc:MovieClip = GetSingleItem("betzone_dark", i);
				mc.gotoAndStop(i + 2);
				mc["_dark"].alpha = al;
				
				var sense:MovieClip = betzone.ItemList[i];
				sense.gotoAndStop(i + 2);
			}
		}
		
		override public function disappear():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = null;
			betzone.mouseup = null;
			betzone.rollout = null;
			betzone.rollover = null;
			
			var avaliblezone:Array = _model.getValue("round_paytable");			
			for ( var i:int = 0; i < avaliblezone.length ; i++)
			{
				var al:Number = 0;
				var mc:MovieClip = GetSingleItem("betzone_dark", i);
				mc.gotoAndStop(i + 2);
				mc["_dark"].alpha = al;
			}
		}
		
		public function bet_sencer(e:Event,idx:int):Boolean
		{
			var avaliblezone:Array = _model.getValue("round_paytable");
			if ( avaliblezone != null)
			{				
				if ( avaliblezone[idx] == -1) 
				{
					//utilFun.Log("bet reject");
					return false;
				}
			}
			
//			Log("betsence type =" + e.type);
			if ( e.type == MouseEvent.MOUSE_DOWN)
			{
				//玩家手動第一次下注,取消上一局的betinfo
				Log("bet_sencer = "+_betCommand.need_rebet());
				if ( _betCommand.need_rebet() )
				{
					_betCommand.clean_hisotry_bet();
				}
				
				//utilFun.Log("bet idx = " + idx );
				if ( CONFIG::debug ) 
				{				
					_betCommand.betTypeMain(e, idx);
				}		
				else
				{				
					_betCommand.betTypeMain(e, idx);
				}
			}
			
			var betzone:MultiObject = Get("betzone");
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(e.type, true, false));			
			
			return false;
		}
	}

}