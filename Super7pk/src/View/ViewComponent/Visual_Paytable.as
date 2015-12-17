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
		private const x_symble:String = "x_symble"
		
		//res
		private const paytable:String = "paytable_main";		
		private const paynum:String = "pay_num";
		private const paytable_baridx:String = "paytable_bar_idx";
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{			
			//賠率提示
			var ptable:MultiObject = create(paytable, [paytable,paytable_baridx]);			
			ptable.container.x = 80;
			ptable.container.y =  111;
			ptable.Create_(2);			
			put_to_lsit(ptable);
			
			//X
			var x_sym:MultiObject = create(x_symble, [paynum]);
			x_sym.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			x_sym.Post_CustomizedData = [12, 0, 36];
			x_sym.container.x = 380;
			x_sym.container.y =  118;
			x_sym.Create_(12);
			
			put_to_lsit(x_sym);
			
			//odd
			var p_num:MultiObject = create(paynum, [ResName.emptymc]);			
			p_num.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			p_num.Post_CustomizedData = [12, 0, 36];
			p_num.container.x = 630;
			p_num.container.y =  118;			
			p_num.Create_(12);
			put_to_lsit(p_num);
			
		}
		
		public function payodd(mc:MovieClip, idx:int, data:Array):void
		{
			var num:String = data[idx];
			var arr:Array = utilFun.arrFormat(data[idx], num.length);
			//Log("pay odd = " + mc.parent.name);
			
			var p_num:MultiObject = create_dynamic(mc.parent.name + "_" + idx, [paynum], mc);			
			p_num.CustomizedFun = FrameSetting
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function pre_open():void
		{
			disappear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			appear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function opencard_parse():void
		{
			appear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle")]
		public function settle():void
		{
			appear();
		}
		
		public function disappear():void
		{
			setFrame(paytable, 1);
			setFrame(x_symble, 1);
			
			Get(paynum).CleanList();
		}
		
		public function appear():void
		{
			//TODO settle or not settle
			GetSingleItem(paytable).gotoAndStop(2);			
			setFrame(x_symble, 12);
			
			//TODO better way ?
			var mu:MultiObject = Get(paynum);			
			mu.CustomizedFun = payodd;
			mu.CustomizedData = [10000, 1000, 200, 100, 50, 30, 15, 8, 5, 3, 2, 1,0];
			mu.Create_(12);
		}
		
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint(winstr:StringObject):void
		{
			var wintype:String = winstr.Value;
			utilFun.Log("winst = " + wintype);
			
			if ( wintype == "") return ;			
			
			var y:int = 0;
			if (wintype == "WSBWStraight") y = 7;
			if ( wintype == "WSBWFlush") y = 6;
			if (wintype == "WSBWFullHouse") y = 5;
			if ( wintype == "WSBWFourOfAKind")y = 4;
			if ( wintype == "WSBWStraightFlush") y = 3;
			if ( wintype == "WSBWRoyalFlush") y = 2;		
						
			GetSingleItem(x_symble,y).gotoAndStop(23);
			
			//utilFun.Log("GetSingleItem =" + GetSingleItem("pay_text"));						
			//GetSingleItem("pay_text",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			//GetSingleItem("pay_mark",y).getChildByName("Dy_Text").textColor = 0xFFFF00;			
			//GetSingleItem("pay_odd",y).getChildByName("Dy_Text").textColor = 0xFFFF00;
			
		}
		
		
	}

}