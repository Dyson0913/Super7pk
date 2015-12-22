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
			var avaliblezone_d:Array = _model.getValue(modelName.AVALIBLE_ZONE_d);
			
			var betzone_dark:MultiObject = create("betzone_dark", avaliblezone_d);
			betzone_dark.container.x = 3;
			betzone_dark.container.y = 605;
			betzone_dark.Create_(avaliblezone_s.length);
			
		
			
			
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
				var avaliblezone:Array = _model.getValue("round_paytable");
				if ( avaliblezone != null)
				{				
					if ( avaliblezone[idx] == -1) 
					{
						utilFun.Log("bet reject");
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
			
			return true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function pre_open():void
		{
			disappear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			disappear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{
			appear();			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function openCard():void
		{			
			disappear();		
		}	
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle")]
		public function settle():void
		{
			disappear();
		}
		
		public function appear():void
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
				mc["_dark"].alpha = al;
			}
		}
		
		public function disappear():void
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
				mc["_dark"].alpha = al;
			}
		}
		
		
	}

}