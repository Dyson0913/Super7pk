package View.ViewComponent 
{
	import flash.display.MovieClip;		
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * settle present way
	 * @author ...
	 */
	public class Visual_Settle  extends VisualHandler
	{
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = create("zone", [ResName.emptymc]);		
			zoneCon.Create_(3);			
			
			put_to_lsit(zoneCon);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function pre_open():void
		{
			setFrame("zone", 1);
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="settle_step")]
		public function settle(v:Intobject):void
		{
			//patytable提示框			
			dispatcher(new StringObject(_model.getValue("winstr"), "winstr_hint"));
			
			//TODO customelize
			//utilFun.Log("jj " + _opration.getMappingValue(modelName.BIG_POKER_MSG, _model.getValue("winstr")));
			//if ( _opration.getMappingValue(modelName.BIG_POKER_MSG, _model.getValue("winstr")) == null)
			//{
				//show誰贏
				//dispatcher(new Intobject(1, "show_who_win"));		
			//}
			
			dispatcher(new ModelEvent("show_settle_table"));			
		}
		
		//[MessageHandler(type = "Model.valueObject.Intobject", selector = "show_who_win")]
		public function show_who_win():void
		{
			var ppoker:Array =   _model.getValue(modelName.POKER_1);
			var bpoker:Array =   _model.getValue(modelName.POKER_2);
			
			var ppoint:int = pokerUtil.ca_point(ppoker);
			var bpoint:int = pokerUtil.ca_point(bpoker);			
			if ( ppoint > bpoint ) 
			{
				utilFun.Log("p>b");
				GetSingleItem("zone", 0 ).gotoAndStop(3);
				if ( ppoint == 0) ppoint = 10;
				GetSingleItem("zone", 0)["_num0"].gotoAndStop(ppoint);
				dispatcher(new StringObject("sound_player_win", "sound" ) );
			}
			else if ( ppoint < bpoint )
			{
				utilFun.Log("b>p");
				GetSingleItem("zone", 1 ).gotoAndStop(3);
				if ( bpoint == 0) bpoint = 10;
				GetSingleItem("zone", 1)["_num0"].gotoAndStop(bpoint);
				dispatcher(new StringObject("sound_deal_win", "sound" ) );
			}
			else
			{
				utilFun.Log("tie");				
				GetSingleItem("zone", 2).gotoAndStop(2);
				dispatcher(new StringObject("sound_tie_win", "sound" ) );
			}
		}
		
	}
	
	

}