package View.ViewComponent 
{
	import asunit.framework.Assert;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Settle  extends VisualHandler
	{
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zoneCon:MultiObject = create("zone", [ResName.playerScore, ResName.bankerScore, ResName.TieScore]);
			zoneCon.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			zoneCon.Post_CustomizedData = [[0, 0], [1018, 0], [560, 0]];
			zoneCon.Create_(3, "zone");
			zoneCon.container.x = 358;
			zoneCon.container.y = 560;		
			
			put_to_lsit(zoneCon);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{
			setFrame("zone", 1);			
		}
		
		//move to model command to parse ,then send event
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_():void
		{
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var idx_to_result_idx:DI = _model.getValue("idx_to_result_idx");
			var betZone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var bigwin:int = -1;			
			var sigwin:int = -1;
						
			var settle_amount:Array = [0,0,0,0,0,0];
			var zonebet_amount:Array = [0, 0, 0, 0, 0, 0];			
			var total:int = 0;
			
			var odd:int = -1;			
			var winst:String = "";			
			var hintJp:int = -1;
			
			var playerPoint:int = pokerUtil.ca_point(_model.getValue(modelName.POKER_1));
			var bankerPoint:int = pokerUtil.ca_point(_model.getValue(modelName.POKER_2));
			var clean:Array = [];
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				utilFun.Log("bet_type=" + resultob.bet_type  + "  " + resultob.win_state + " bigwin= " + bigwin);				
				
				//coin 清除區
				if ( resultob.win_state == "WSLost") clean.push (name_to_idx.getValue(resultob.bet_type));
				else
				{					
					if ( resultob.bet_type == "BetBWPlayer" ) 
					{						
						//大獎
						if ( resultob.win_state != "WSBWNormalWin" && resultob.win_state !="WSWin")
						{						
							bigwin = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state);
						}						
						winst = resultob.win_state;
						odd = resultob.odds;
					}
					
					if ( resultob.bet_type == "BetBWSpecial" ) 
					{						
						sigwin = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state);						
					}
					
					//{"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTripple", "settle_amount": 0},
					//{"bet_attr": "BetAttrBonus", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTwoPair", "settle_amount": 0}
					if( resultob.bet_type =="BetBWBonusTwoPair") 
					{
						var extra:int = resultob.bet_amount * resultob.odds;
						if ( extra > 0)
						{
							var array:Array = _model.getValue("power_jp");
							array[0] = resultob.bet_amount * resultob.odds;
							hintJp = 1;
						}
						continue;
					}
					if( resultob.bet_type =="BetBWBonusTripple") 
					{
						var extra_two:int = resultob.bet_amount * resultob.odds;
						if ( extra_two )
						{
							var array2:Array = _model.getValue("power_jp");
							array2[1] = resultob.bet_amount * resultob.odds;
							hintJp = 1;
						}
						continue;
					}
					
				}
				
				//總押注和贏分
				settle_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type) )] =  resultob.settle_amount;
				zonebet_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type)) ]  = resultob.bet_amount;
				total += resultob.settle_amount;
			}			
			
			
			
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total);			
			_model.putValue("winstr", winst);
			_model.putValue("win_odd", odd);
			
			
			var wintzone:Array = utilFun.Get_restItem(betZone, clean);
			utilFun.Log("clean zone =" + clean);
			utilFun.Log("wintzone =" + wintzone);
			utilFun.Log("result_settle_amount =" + settle_amount);
			utilFun.Log("result_zonebet_amount =" + zonebet_amount);
			utilFun.Log("result_total =" + total);
			utilFun.Log("bigwin =" + bigwin);			
			
			//大獎 (排除2對,3條和11以上J對)
			if ( bigwin!=-1 && bigwin >=2)
			{				
				_Bigwin_Effect.hitbigwin(bigwin);
			}
			else
			{
				//2對,3條集氣吧				
				if ( hintJp !=-1 && (sigwin ==1 || sigwin ==0)) dispatcher(new Intobject(sigwin, "power_up"));
				else settle(new Intobject(1, "settle_step"));
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