package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_Paytable  extends VisualHandler
	{
		private const settletable:String = "settle_table"
		private const x_symble:String = "x_symble"
		private const bet_symble:String = "bet_symble"
		
		//res
		private const paytable:String = "paytable_main"		
		private const paynum:String = "pay_num"		
		private const settlenum:String = "settle_num"		
		private const paytable_baridx:String = "paytable_bar_idx";
		
		
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{			
			//賠率提示
			var ptable:MultiObject = create(paytable, [paytable,paytable_baridx]);			
			ptable.container.x = 80;
			ptable.container.y =  101;
			ptable.Create_(2, paytable);
			
			put_to_lsit(ptable);
			
			//X
			var x_sym:MultiObject = create(x_symble, [paynum]);
			x_sym.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			x_sym.Post_CustomizedData = [12, 0, 36];
			x_sym.container.x = 380;
			x_sym.container.y =  108;
			x_sym.Create_(12, x_symble);
			
			put_to_lsit(x_sym);
			
			//odd
			var p_num:MultiObject = create(paynum, [ResName.emptymc]);
			//p_num.CustomizedFun = payodd;
			//p_num.CustomizedData = [10000, 1000, 200, 100, 50, 30, 15, 8, 5, 3, 2, 1,0];
			p_num.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			p_num.Post_CustomizedData = [12, 0, 36];
			p_num.container.x = 630;
			p_num.container.y =  108;
			p_num.Create_(12, paynum);
			
			put_to_lsit(p_num);
			
			var settle_table:MultiObject = create(settletable, [paytable]);			
			settle_table.container.x = 1270;
			settle_table.container.y =  101;
			settle_table.Create_(1, settletable);
			
			put_to_lsit(settle_table);
			
			var bet_num:MultiObject = create(bet_symble, [ResName.emptymc]);
			//bet_num.CustomizedFun = settleodd;
			//bet_num.CustomizedData = [100, 1000, 200, 100, 500, 300, 100, 800, 500, 300, 200, 100,30000];
			bet_num.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			bet_num.Post_CustomizedData = [13, 0, 33.5];
			bet_num.container.x = 1600;
			bet_num.container.y =  108;
			bet_num.Create_(13, bet_symble);
			
			put_to_lsit(bet_num);
			
		}
		
		public function payodd(mc:MovieClip, idx:int, data:Array):void
		{
			var num:String = data[idx];
			var arr:Array = utilFun.arrFormat(data[idx], num.length);
			Log("pay odd = " + mc.parent.name);
			
			var p_num:MultiObject = create(mc.parent.name + "_" + idx, [paynum], mc);			
			p_num.CustomizedFun = FrameSetting
			p_num.CustomizedData = arr.reverse();
			p_num.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			p_num.Post_CustomizedData = [num.length, -22, 0];		
			p_num.Create_(num.length, paynum + "_" + idx);
		}
		
		public function settleodd(mc:MovieClip, idx:int, data:Array):void
		{
			var num:String = data[idx];
			var arr:Array = utilFun.arrFormat(data[idx], num.length);
			//Log("pay odd = " + mc.parent.name);
			
			var p_num:MultiObject = create(mc.parent.name + "_" + idx, [settlenum], mc);			
			p_num.CustomizedFun = FrameSetting
			p_num.CustomizedData = arr.reverse();
			p_num.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			p_num.Post_CustomizedData = [num.length, -22, 0];		
			p_num.Create_(num.length, paynum + "_" + idx);
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if ( data[idx] == 0) data[idx] = 10;
			var value:int = data[idx];
			value += 1;
			data[idx] = value;
			
			
			mc.gotoAndStop(data[idx]);
		}
		
		public function hide():void
		{
			GetSingleItem(paytable).gotoAndStop(1);			
			GetSingleItem(paytable, 1).gotoAndStop(1);			
			
			GetSingleItem(settletable).gotoAndStop(1);
			setFrame(x_symble, 1);			
			Get(paynum).CleanList();
			Get(bet_symble).CleanList();
			
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "pre_open")]
		public function pre_open():void
		{
			hide();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			hide();			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			GetSingleItem(paytable).gotoAndStop(2);
			GetSingleItem(settletable).gotoAndStop(3);
			
			setFrame(x_symble, 12);
			
			//TODO better way ?
			Get(paynum).CustomizedFun = payodd;
			Get(paynum).CustomizedData = [10000, 1000, 200, 100, 50, 30, 15, 8, 5, 3, 2, 1,0];
			Get(paynum).Create_(12, paynum);
			
			Get(bet_symble).CustomizedFun = settleodd;
			Get(bet_symble).CustomizedData = [100, 1000, 200, 100, 500, 300, 100, 800, 500, 300, 200, 100,30000];			
			Get(bet_symble).Create_(13, bet_symble);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{			
			GetSingleItem(paytable).gotoAndStop(1);
		}
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint(winstr:StringObject):void
		{
			var wintype:String = winstr.Value;
			utilFun.Log("winst = " + wintype);
			
			if ( wintype == "") return ;
			if (wintype ==  "WSWin" || wintype == "WSBWNormalWin")  return;
			if (wintype ==  "WSBWOnePairBig")  return;
			
			var y:int = 0;
			if (wintype == "WSBWStraight") y = 7;
			if ( wintype == "WSBWFlush") y = 6;
			if (wintype == "WSBWFullHouse") y = 5;
			if ( wintype == "WSBWFourOfAKind")y = 4;
			if ( wintype == "WSBWStraightFlush") y = 3;
			if ( wintype == "WSBWRoyalFlush") y = 2;			
			
			GetSingleItem("paytable_baridx").gotoAndStop(y);
			
			//utilFun.Log("GetSingleItem =" + GetSingleItem("pay_text"));						
			//GetSingleItem("pay_text",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			//GetSingleItem("pay_mark",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			//GetSingleItem("pay_odd",y).getChildByName("Dy_Text").textColor = 0xFFFF00;
			
		}
		
		
	}

}