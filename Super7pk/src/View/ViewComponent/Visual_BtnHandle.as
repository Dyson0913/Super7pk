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
	
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;		
		
		private var _rule_table:MultiObject ;
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function init():void
		{
			var btnlist:Array = [ResName.paytable_btn];// , ResName.rebet_btn];// , ResName.betcancel_btn];
			//patable說明
			var btn_group:MultiObject = create("btn_group", btnlist);
			btn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			btn_group.container.x = -4;
			btn_group.container.y = 952;
			btn_group.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			btn_group.Post_CustomizedData = [[0, 0], [1580, -10], [1780, -10]];
			btn_group.Create_(btnlist.length, "btn_group");
			btn_group.rollout = test_reaction;
			btn_group.rollover = test_reaction;
			btn_group.mousedown = table_true;
			btn_group.mouseup = test_reaction;
			
			//rebet
			var mylist:Array = [ ResName.rebet_btn];// , ResName.betcancel_btn];
			var mybtn_group:MultiObject = create("mybtn_group", mylist);
			mybtn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			mybtn_group.container.x = 1710;
			mybtn_group.container.y = 950;
			//mybtn_group.CustomizedFun = scal;			
			mybtn_group.Create_(mylist.length, "mybtn_group");
			mybtn_group.rollout = test_reaction;
			mybtn_group.rollover = test_reaction;
			mybtn_group.mousedown = rebet_fun;
			mybtn_group.mouseup = test_reaction;
			
			
			_rule_table  = create("rule_table", [ResName.ruletable]);
			_rule_table.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);
			_rule_table.mousedown = table_true;
			_rule_table.mouseup = test_reaction;
			_rule_table.container.x = -10;
			_rule_table.container.y = 50;			
			_rule_table.Create_(1, "rule_table");
			_rule_table.container.visible = false;
			
			put_to_lsit(_rule_table);
		}		
		
		//public function scal(mc:MovieClip, idx:int, data:Array):void
		//{		
			//utilFun.scaleXY(mc, 0.68, 0.68);
		//}
		
		public function test_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}
				
		public function table_true(e:Event, idx:int):Boolean
		{
			_rule_table.container.visible = !_rule_table.container.visible;				
			return true;
		}
		
		public function rebet_fun(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("mybtn_group");
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
			
			_betCommand.re_bet();
			dispatcher(new StringObject("sound_rebet","sound" ) );
			return false;
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			utilFun.Log("_betCommand.need_rebet() ="+_betCommand.need_rebet());
			if ( !_betCommand.need_rebet() )
			{
				can_not_rebet()				
			}
			else
			{
				can_rebet();
			}		
			
		}
		
		public function can_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(1);
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
			betzone.mousedown = rebet_fun;
			betzone.mouseup = _betCommand.empty_reaction;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "can_not_rebet")]
		public function can_not_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = false;		
		}
		
	}

}