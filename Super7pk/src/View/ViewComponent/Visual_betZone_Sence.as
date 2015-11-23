package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
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
			playerzone_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,1,2,1]);
			playerzone_s.container.x = 457;
			playerzone_s.container.y = 662;
			playerzone_s.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone_s.Post_CustomizedData = zone_xy;
			playerzone_s.Create_(avaliblezone_s.length, "betzone_s");
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = bet_sencer;
			betzone.mouseup = bet_sencer_up;	
			betzone.rollout = bet_sencer_rollout;	
			betzone.rollover = bet_sencer_rollover;	
		}
		
		public function bet_sencer_rollout(e:Event,idx:int):Boolean
		{				
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false));			
			
			return true;
		}
		
		public function bet_sencer_rollover(e:Event,idx:int):Boolean
		{
			var mc:MovieClip = Get("betzone").ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false));			
			
			if ( idx == 5) 
			{
				Tweener.pauseTweens(GetSingleItem("betzone", 5));
				GetSingleItem("highpayrate").gotoAndStop(2);
			}
			
			return true;
		}
		
		public function bet_sencer(e:Event,idx:int):Boolean
		{	
			//玩家手動第一次下注,取消上一局的betinfo
			utilFun.Log("bet_sencer = "+_betCommand.need_rebet());
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
			
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));			
			
			return true;
		}
		
		public function bet_sencer_up(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false));			
			
			return true;
		}	
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = null;
			betzone.mouseup = null;
			betzone.rollout = null;
			betzone.rollover = null;
		}
		
		
	}

}