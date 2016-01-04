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
	import caurina.transitions.Tweener;
	
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
		
		//tag
		private const tag_paytable:int = 0;		
		private const tag_paytable_win_tag:int = 1;		
		
		private var tween_frame:int;
		
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
			var num:Number = data[idx];
			if ( num == -1 ) num= 0;
			
			var s_num:String = num.toString();			
			var arr:Array = s_num.toString().split("");
			//Log("pay odd = " + mc.parent.name);
			
			var p_num:MultiObject = create_dynamic(mc.parent.name + "_" + idx, [paynum], mc);			
			p_num.CustomizedFun = FrameSetting;
			p_num.CustomizedData = arr.reverse();
			p_num.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			p_num.Post_CustomizedData = [s_num.length, -22, 0];		
			p_num.Create_(s_num.length);
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if ( data[idx] == 0) data[idx] = 10;
			if ( data[idx] == ".") data[idx] = 12;
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
		public function settle2():void
		{
			appear();
		}
		
		override public function disappear():void
		{
			setFrame(paytable, 1);
			setFrame(x_symble, 1);
			
			Get(paynum).CleanList();
			
			Tweener.pauseTweens( GetSingleItem(paytable, tag_paytable_win_tag) );
			Tweener.pauseTweens( GetSingleItem(x_symble, tween_frame));
		}
		
		override public function appear():void
		{			
			GetSingleItem(paytable).gotoAndStop(2);			
			setFrame(x_symble, 12);
			
			
			var total:Array = _model.getValue("round_paytable");
			var copyarr:Array = [];
				copyarr.push.apply(copyarr,total );
			var mu:MultiObject = Get(paynum);
			mu.CustomizedFun = payodd;
			mu.CustomizedData = copyarr.reverse();
			mu.Create_(12);
		}
		
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint(winstr:StringObject):void
		{
			var wintype:String = winstr.Value;
			utilFun.Log("winst = " + wintype);
			
			if ( wintype == "") return ;
			
			var frame:int = parseInt(wintype);
			tween_frame = frame -2;
			_regular.Twinkle_by_JumpFrame(GetSingleItem(paytable, tag_paytable_win_tag), 25, 60, 1, frame);
			_regular.Twinkle_by_JumpFrame(GetSingleItem(x_symble, tween_frame), 25, 60, 12, 24);
		}
		
		
	}

}