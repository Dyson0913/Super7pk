package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import View.GameView.gameState;
	
	/**
	 * betzone present way
	 * @author Dyson0913
	 */
	public class Visual_betZone  extends VisualHandler
	{	
		public const bet_tableitem:String = "bet_table_item";
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			
			var tableitem:MultiObject = create(bet_tableitem, [bet_tableitem]);	
			tableitem.container.x = 3;
			tableitem.container.y = 575;
			tableitem.Create_(1);			
			
			put_to_lsit(tableitem);
			
			var res:Array = ["zone_total"]
			//下注區
			var pz:MultiObject = create("betzone", res);
			pz.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 0]);			
			//pz.CustomizedData = [2,3,4,5,6,7,8,9,10,11,12,13];
			//pz.CustomizedFun = _regular.FrameSetting;
			pz.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			pz.Post_CustomizedData = [[0, 0] , [ -300, 0] , [ -600, 0] , [ -910, 0] , [ -1222, 0], [ -1536, 0], [ -31, -171], [ -312, -175], [ -597, -175], [ -892, -177], [ -1186, -177], [ -1481, -176]];			
			pz.container.x = tableitem.container.x + 1556;
			pz.container.y = tableitem.container.y + 214;
			pz.Create_(12);
			
			put_to_lsit(pz);
			
			var effect:MultiObject = create("zone_effect", ["zone_effect"]);		
			effect.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			effect.Post_CustomizedData = [[0, 0] , [ -300, 0] , [ -600, 0] , [ -910, 0] , [ -1222, 0], [ -1536, 0], [ -31, -171], [ -312, -175], [ -597, -175], [ -892, -177], [ -1186, -177], [ -1481, -176]];			
			effect.container.x = tableitem.container.x + 1556;
			effect.container.y = tableitem.container.y + 214;
			effect.Create_(12);
			
			state_parse([gameState.START_BET]);
		}		
		
		override  public function appear():void
		{			
			
			setFrame(bet_tableitem, 2);
			
			var betzone:MultiObject = Get("betzone");			
			betzone.mousedown = bet_sencer;	
			betzone.rollout = empty_reaction;
			betzone.rollover = bet_sencer;
			
			var high_odd_ind:int = _model.getValue("highest_idx");
			var odd_high:MovieClip = GetSingleItem("zone_effect", high_odd_ind);
			odd_high.gotoAndStop(high_odd_ind+2);			
			odd_high["effect"].gotoAndPlay(2);			
		}
		
		override public function disappear():void
		{
			setFrame(bet_tableitem, 1);
			
			var betzone:MultiObject = Get("betzone");			
			betzone.mousedown = null;	
			betzone.rollout = null;
			betzone.rollover = null;
			
			setFrame("betzone", 1);
			
			var high_odd_ind:int = _model.getValue("highest_idx");
			var odd_high:MovieClip = GetSingleItem("zone_effect", high_odd_ind);
			odd_high.gotoAndStop(high_odd_ind+2);			
			odd_high["effect"].gotoAndStop(1);		
			
		}
		
		public function bet_sencer(e:Event, idx:int):Boolean
		{		
			e.currentTarget.gotoAndStop(idx + 2);			
			return false;
		}
	}

}