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
	import View.GameView.*;
	/**
	 * settlePanel present way
	 * @author Dyson0913
	 */
	public class Visual_SettlePanel  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		//tag
		private const settletable:String = "settle_table";
		private const bet_symble:String = "bet_symble";
		private const settle_symble:String = "settle_symble";
		
		//res
		private const paytable:String = "odd_title";		
		private const settlenum:String = "pay_num";		
		private const paytable_baridx:String = "paytable_bar_idx";
		
		public function Visual_SettlePanel() 
		{
			
		}
		
		public function init():void
		{
			//settle
			var settle_table:MultiObject = create(settletable, [paytable]);			
			settle_table.container.x = 1270;
			settle_table.container.y =  141;
			settle_table.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settle_table.Post_CustomizedData = [8, 0, 50];
			settle_table.Create_(9);
			
			put_to_lsit(settle_table);
			
			//bet_num
			var bet_num:MultiObject = create(bet_symble, [ResName.emptymc]);			
			bet_num.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			bet_num.Post_CustomizedData = [9, 0, 50];
			bet_num.container.x = 1600;
			bet_num.container.y =  148;
			
			put_to_lsit(bet_num);			
			
			//settle_num
			var settlesymble:MultiObject = create(settle_symble, [ResName.emptymc]);			
			settlesymble.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settlesymble.Post_CustomizedData = [9, 0, 50];
			settlesymble.container.x = 1830;
			settlesymble.container.y = bet_num.container.y;
			
			put_to_lsit(settlesymble);		
			
			//= clip or word ,font property push in to mapping,
			//Posi_CustzmiedFun  = _regular.Posi_xy_Setting;
			//Post_CustomizedData = [0,0],[150,0],[270,0];
			// CustomizedFun  = _text.textSetting;
			// CustomizedData =  [{size:22}, "投注內容","押分","得分"]  			
			
			// CustomizedFun  = _text.textSetting;
			// CustomizedData =  [ { size:22 }, "莊", "閒", "和", "莊對", "閒對", "特殊牌型", "合計"];
			//Post_CustomizedData Post_CustomizedData = [7, 30, 32];		
			
			//CustomizedData = [ { size:18,align:_text.align_right,color:0xFF0000 }, "100", "100", "1000", "0", "200", "100000","0"];
			//settletable_zone_bet.Post_CustomizedData = [7, 30, 32];		
			
			//CustomizedData = [ { size:18,align:_text.align_right }, "0", "0", "1000", "0", "0", "100000", "10000"];
			//settletable_zone_settle.Post_CustomizedData = [7, 30, 32];
			state_parse([gameState.END_BET,gameState.START_OPEN,gameState.END_ROUND]);
		}		
		
		override public function appear():void
		{
			//setFrame(settletable, 3);			
			var payframe:Array = _model.getValue("paytable_frame");
			var copyarr:Array = [];
			copyarr.push.apply(copyarr, payframe );
			copyarr.push(26);
			var settletable:MultiObject = Get(settletable);
			settletable.CustomizedData =  copyarr;
			settletable.CustomizedFun = _regular.FrameSetting;
			settletable.FlushObject();
			
			//
			var mylist:Array = _betCommand.bet_zone_amount();			
			var sortarr:Array = [];
			sortarr.push.apply(sortarr, mylist );
			sortarr.pop();
			sortarr.reverse();
			//Log("mylist = " +sortarr);			
			var display_idx:Array = _model.getValue("paytable_display_idx");
			//Log("display_idx = " +display_idx);			
			var display_list:Array = [];
			for (var i:int = 0; i < display_idx.length ; i++)
			{
				display_list.push( sortarr[display_idx[i]]);
			}
			display_list.reverse();
			display_list.push(mylist[mylist.length - 1]);
			//var mylist:Array = [100, 1000, 200, 100, 500, 300, 100, 800, 500, 300, 200, 100, 30000];
			var symbl:MultiObject = Get(bet_symble);
			symbl.CustomizedFun = settleodd;
			symbl.CustomizedData = display_list;
			symbl.Create_(9);
			//symbl.FlushObject();
			
			//var settle:Array = _model.getValue("result_settle_amount");
			//var mylist:Array = [100, 1000, 200, 100, 500, 300, 100, 800, 500, 300, 200, 100, 30000];
			//var symbl:MultiObject = Get(settle_symble);
			//symbl.CustomizedFun = settleodd;
			//symbl.CustomizedData = settle;
			//symbl.Create_(13);
			//
			//TODO word type setting
			//var font:Array = [{size:24,align:_text.align_right,color:0xFF0000}];
			//font = font.concat(mylist);
			//utilFun.Log("font = "+mylist);
			//Get("settletable_zone_bet").CustomizedData = font;
			//Get("settletable_zone_bet").Create_by_list(mylist.length, [ResName.TextInfo], 0 , 0, 1, 0, 30, "Bet_");	
		}
		
		override public function disappear():void
		{
			setFrame(settletable, 1);
			
			Get(bet_symble).CleanList();
			Get(settle_symble).CleanList();
		}
		
		public function sprite_idx_setting_player(mc:*, idx:int, data:Array):void
		{			
			var code:int  = pokerUtil.pokerTrans_s(data[idx]);			
			mc.x += 25;			
			//押暗
			//if ( history_win[Math.floor(idx / 5)] != ResName.angelball) mc.alpha =  0.5;			
			mc.drawTile(code);	
			//utilFun.scaleXY(mc, 2, 2);
		
		}
		
		public function settleodd(mc:MovieClip, idx:int, data:Array):void
		{			
			var num:String = data[idx];
			var arr:Array = utilFun.arrFormat(data[idx], num.length);
			//Log("pay odd = " + mc.parent.name);
			
			var p_num:MultiObject = create_dynamic(mc.parent.name + "_" + idx, [settlenum], mc);			
			p_num.CustomizedFun = FrameSetting;
			p_num.CustomizedData = arr.reverse();
			p_num.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			p_num.Post_CustomizedData = [num.length, -22, 0];		
			p_num.Create_(num.length);
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if ( data[idx] == 0) data[idx] = 10;
			var value:int = data[idx];
			value += 1;
			data[idx] = value;			
			
			mc.gotoAndStop(data[idx]);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "show_settle_table")]
		public function show_settle():void
		{			
			Log("show_settle");
			
			//押注
			var zone_amount:Array = _model.getValue("result_zonebet_amount");			
			//var zone_amount:Array = [100, 1000, 200, 100, 500, 300, 100, 800, 500, 300, 200, 100];
			//var mylist:Array = zone_amount;
			var bet_s:MultiObject = Get(bet_symble);
			bet_s.CustomizedFun = settleodd;
			bet_s.CustomizedData = zone_amount;
			bet_s.Create_(zone_amount.length);
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");	
			//var settle_amount:Array = [100, 1000, 200, 100, 500, 300, 100, 800, 500, 300, 200, 100, 30000];
			var settle_s:MultiObject = Get(settle_symble);
			settle_s.CustomizedFun = settleodd;
			settle_s.CustomizedData = settle_amount;
			settle_s.Create_(settle_amount.length);			
			
			//= clip or word ,font property push in to mapping,			
			//Get("settletable_zone_settle").CustomizedFun = _text.colortextSetting;
			//Get("settletable_zone_settle").CustomizedData = text_update("settletable_zone_settle", settle_amount);
			//Get("settletable_zone_settle").Create_(settle_amount.length, "settletable_zone_settle");
			
			if ( _betCommand.all_betzone_totoal() == 0) return;
			
			dispatcher(new StringObject("sound_get_point","sound" ) );
			
			//小牌結果
			//var historystr_model:Array = _model.getValue("result_str_list");
			//var add_parse:String = historystr_model.join("、");
			//add_parse = add_parse.slice(0, 0) + "(" + add_parse.slice(0);
			//add_parse = add_parse +")";			
		}	
		
		public function text_update(font_property:String,data:Array):Array
		{
			var font:Array = _model.getValue(font_property);
			font = font.concat(data);
			return font;
		}
		
	}

}