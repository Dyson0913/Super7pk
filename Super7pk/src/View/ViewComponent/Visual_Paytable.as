package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
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
		
		//tag
		private const tag_paytable:int = 0;		
		private const tag_paytable_win_tag:int = 1;		
		
		private var _win_item:int = 0;
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{			
			//賠率提示
			var ptable:MultiObject = create(paytable, [paytable]);			
			ptable.container.x = 80;
			ptable.container.y = 141;
			ptable.Create_(12);
			
			put_to_lsit(ptable);
			
			//X
			var x_sym:MultiObject = create(x_symble, [paynum]);
			x_sym.container.x = 380;
			x_sym.container.y =  149;
			x_sym.Create_(12);
			
			put_to_lsit(x_sym);
			
			//odd
			var p_num:MultiObject = create(paynum, [ResName.emptymc]);
			p_num.container.x = 630;
			p_num.container.y =  148;			
			p_num.Create_(12);
			put_to_lsit(p_num);
			
			state_parse([gameState.END_BET,gameState.START_OPEN,gameState.END_ROUND]);
		}
		
		override public function appear():void
		{			
			var data:Array = _model.getValue("paytable_frame");
			var dis_cnt:int = data.length  < 8 ? 8:data.length;
			var dis:Number = utilFun.NPointInterpolateDistance(dis_cnt, 0, 390);
			
			var paytable:MultiObject = Get(paytable);
			paytable.CustomizedData = _model.getValue("paytable_frame");
			paytable.CustomizedFun = _regular.FrameSetting;
			paytable.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			paytable.Post_CustomizedData = [dis_cnt, 0, dis];			
			paytable.customized();
			
			//x mark			
			var x_mark:MultiObject = Get(x_symble);
			x_mark.CustomizedData = _model.getValue("paytable_xmark");
			x_mark.CustomizedFun = _regular.FrameSetting;
			x_mark.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			x_mark.Post_CustomizedData = [dis_cnt, 0, dis];
			x_mark.customized();
			
			
			//odd
			var odd_data:Array = _model.getValue("odd_data");
			var odd:MultiObject = Get(paynum);
			odd.CustomizedFun = payodd;
			odd.CustomizedData = odd_data;
			odd.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			odd.Post_CustomizedData = [dis_cnt, 0, dis];			
			odd.Create_(odd_data.length);
		}
		
		override public function disappear():void
		{
			Tweener.pauseTweens( GetSingleItem(paytable, _win_item) );
			Tweener.pauseTweens( GetSingleItem(x_symble, _win_item));
			
			setFrame(paytable, 1);
			setFrame(x_symble, 1);
			
			Get(paynum).CleanList();
			
		}
		
		public function payodd(mc:MovieClip, idx:int, data:Array):void
		{	
			var num:Number = data[idx];
			if ( num == -1 ) num= 0;
			
			var s_num:String = num.toString();			
			var arr:Array = s_num.toString().split("");
			//Log("pay odd = " + mc.parent.name + "_" + idx);
			
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
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="winstr_hint")]
		public function win_frame_hint(winstr:Intobject):void
		{
			var wintype:int = winstr.Value;
			utilFun.Log("winst = " + wintype);
			
			var fra:Array = _model.getValue("paytable_frame");
			
			Log("paytable_frame =" + fra);
			var frame:int = wintype;
			_win_item = fra.indexOf(frame);			
			
			var win_item:MovieClip = GetSingleItem(paytable, _win_item );
			var fr:int = win_item.currentFrame;
			_regular.Twinkle_by_JumpFrame(GetSingleItem(paytable,_win_item ), 25, 60, fr, fr+12);
			_regular.Twinkle_by_JumpFrame(GetSingleItem(x_symble, _win_item), 25, 60, 12, 24);
			
			var mu:MovieClip = GetSingleItem(paynum, _win_item);
			var mul:Sprite = mu.getChildByName(paynum + "_" + _win_item) as Sprite
			for ( var i:int = 0; i < mul.numChildren; i++)
			{
				var _item:MovieClip= mul.getChildAt(i) as MovieClip
				var f:int = _item.currentFrame;
				_regular.Twinkle_by_JumpFrame(_item, 25, 60, f, f+12);
			}
			
		}
		
		
	}

}