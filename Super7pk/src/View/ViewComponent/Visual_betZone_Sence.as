package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;	
	
	/**
	 * betzone present way
	 * @author ...
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
			var avaliblezone_s:Array = _model.getValue(modelName.AVALIBLE_ZONE_S);
			
			var playerzone_s:MultiObject = create("betzone_s", avaliblezone_s);
			playerzone_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 1, 2, 1]);
			playerzone_s.mousedown = null;
			playerzone_s.mouseup = null;
			playerzone_s.rollout = null;
			playerzone_s.rollover = null;
			playerzone_s.container.x = 3;
			playerzone_s.container.y = 605;
			playerzone_s.Create_(avaliblezone_s.length);
		}
		
		public function bet_sencer(e:Event,idx:int):Boolean
		{				
//			Log("betsence type =" + e.type);
			if ( e.type == MouseEvent.MOUSE_DOWN)
			{
				//玩家手動第一次下注,取消上一局的betinfo
				Log("bet_sencer = "+_betCommand.need_rebet());
				if ( _betCommand.need_rebet() )
				{
					_betCommand.clean_hisotry_bet();
				}
				
				if ( CONFIG::debug ) 
				{				
					_betCommand.bet_local(e, idx);
				}		
				else
				{				
					_betCommand.betTypeMain(e, idx);
				}
			}
			
			var betzone:MultiObject = Get("betzone");
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(e.type, true, false));			
			
			return true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = bet_sencer;
			betzone.mouseup = bet_sencer;
			betzone.rollout = bet_sencer;
			betzone.rollover = bet_sencer;
			
			//TODO zone dock
			var avaliblezone:Array = _model.getValue("round_paytable");
			//[-1, -1, -1, -1, -1, -1, 15, 21, 24, 10, 0.9, 1.7]
			var dark_zone: Array = [];
			for ( var i:int = 0; i < avaliblezone.length ; i++)
			{
				if ( avaliblezone[i] == -1) dark( GetSingleItem("betzone", i));//dark_zone.push[i];
			}
			
		}
		
		private function dark(mc:MovieClip):void
		{
			//var mc:MovieClip = GetSingleItem(type, 2);

			var color:uint = 0x000000;
			var mul:Number = 70 / 100;
			var ctMul:Number=(1-mul);
			var ctRedOff:Number=Math.round(mul*extractRed(color));
			var ctGreenOff:Number=Math.round(mul*extractGreen(color));
			var ctBlueOff:Number=Math.round(mul*extractBlue(color));
			var ct:ColorTransform = new ColorTransform(ctMul,ctMul,ctMul,1,ctRedOff,ctGreenOff,ctBlueOff,0);
			mc.transform.colorTransform=ct;
		}
		
			function extractRed(c:uint):uint {
		return (( c >> 16 ) & 0xFF);
		}
		 
		function extractGreen(c:uint):uint {
		return ( (c >> 8) & 0xFF );
		}
		 
		function extractBlue(c:uint):uint {
		return ( c & 0xFF );
		}
		
	}

}