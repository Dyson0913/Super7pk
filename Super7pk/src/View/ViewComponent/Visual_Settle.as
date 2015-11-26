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
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect;
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = create("zone", [ResName.emptymc]);		
			zoneCon.Create_(3, "zone");			
			
			put_to_lsit(zoneCon);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pre_open")]
		public function pre_open():void
		{
			setFrame("zone", 1);		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle_bigwin")]
		public function settle_bigwin():void
		{
			var bigwin:int = 3;// _model.getValue("bigwin");
			//TODO like model filter
			Log("bigwin =" + bigwin);
			//大獎
			if ( bigwin!=-1 && bigwin >=1)
			{				
				_Bigwin_Effect.hitbigwin(bigwin);
			}
			else settle(new Intobject(1, "settle_step"));
		}
		
		public function settle_powerbar():void
		{
			var hintJp:int =  _model.getValue("hintJp");
			var sigwin:int =  _model.getValue("sigwin");			
			//2對,3條集氣吧
			if ( hintJp != -1 && (sigwin == 1 || sigwin == 0)) 
			{
				dispatcher(new Intobject(sigwin, "power_up"));
			}
		}
		
			
		[MessageHandler(type="Model.valueObject.Intobject",selector="settle_step")]
		public function settle(v:Intobject):void
		{
			//patytable提示框			
			dispatcher(new StringObject(_model.getValue("winstr"), "winstr_hint"));
			
			utilFun.Log("jj " + _opration.getMappingValue(modelName.BIG_POKER_MSG, _model.getValue("winstr")));
			if ( _opration.getMappingValue(modelName.BIG_POKER_MSG, _model.getValue("winstr")) == null)
			{
				//show誰贏
				dispatcher(new Intobject(1, "show_who_win"));		
			}
			
			dispatcher(new ModelEvent("show_settle_table"));
			//結算表
			//_regular.Call(this, { onComplete:this.showAni}, 2, 1, 1, "linear");
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "show_who_win")]
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