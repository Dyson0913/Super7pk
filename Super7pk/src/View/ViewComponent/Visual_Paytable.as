package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;	
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import View.GameView.gameState;
	/**
	 * Paytable present way
	 * @author Dyson0913
	 */
	public class Visual_Paytable  extends VisualHandler
	{		
		private const x_symble:String = "x_symble"
		
		//res
		private const paytable:String = "odd_title";		
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
			var ptable:MultiObject = create(paytable, [paytable]);			
			ptable.container.x = 80;
			ptable.container.y = 141;
			ptable.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			ptable.Post_CustomizedData = [8, 0, 50];
			ptable.Create_(8);
			
			put_to_lsit(ptable);
			
			//X
			var x_sym:MultiObject = create(x_symble, [paynum]);
			x_sym.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			x_sym.Post_CustomizedData = [12, 0, 50];
			x_sym.container.x = 380;
			x_sym.container.y =  149;
			x_sym.Create_(8);
			
			put_to_lsit(x_sym);
			
			//odd
			var p_num:MultiObject = create(paynum, [ResName.emptymc]);			
			p_num.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			p_num.Post_CustomizedData = [12, 0, 50];
			p_num.container.x = 630;
			p_num.container.y =  148;			
			p_num.Create_(8);
			put_to_lsit(p_num);
			
			state_parse([gameState.END_BET,gameState.START_OPEN,gameState.END_ROUND]);
		}
		
		override public function appear():void
		{			
			var paytable:MultiObject = Get(paytable);
			paytable.CustomizedData = _model.getValue("paytable_frame");
			paytable.CustomizedFun = _regular.FrameSetting;
			paytable.FlushObject();
			
			//x mark
			//setFrame(x_symble, 12);
			var x_mark:MultiObject = Get(x_symble);
			x_mark.CustomizedData = _model.getValue("paytable_xmark");
			x_mark.CustomizedFun = _regular.FrameSetting;
			x_mark.FlushObject();
			
			
			//odd
			var odd_data:Array = _model.getValue("odd_data");
			var mu:MultiObject = Get(paynum);
			mu.CustomizedFun = payodd;
			mu.CustomizedData = odd_data;
			//mu.FlushObject();
			mu.Create_(odd_data.length);
		}
		
		override public function disappear():void
		{
			setFrame(paytable, 1);
			setFrame(x_symble, 1);
			
			Get(paynum).CleanList();
			
			Tweener.pauseTweens( GetSingleItem(paytable, tag_paytable_win_tag) );
			Tweener.pauseTweens( GetSingleItem(x_symble, tween_frame));
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