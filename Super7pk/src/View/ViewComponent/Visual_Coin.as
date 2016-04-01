package View.ViewComponent 
{
	import Command.BetCommand;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;	
	import Model.*;
	import util.*;
	
	import View.Viewutil.*;	
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * coin present way
	 * @author Dyson0913
	 */
	public class Visual_Coin  extends VisualHandler
	{
		
		[Inject]
		public var _Actionmodel:ActionQueue;		
		
		[Inject]
		public var _betCommand:BetCommand;
		
		//coin seperate to N stack
		private var _stack_num:int = 1;
		
		private var _coin:MultiObject;
		
		public const Betcoin:String = "Bet_coin";
		
		public function Visual_Coin() 
		{
			
		}
		
		public function init():void
		{
			_coin = create("CoinOb", [Betcoin]);
			_coin.container.x = 1080;
			_coin.container.y = 980;
			_coin.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			_coin.CustomizedFun = ocin_setup;
			_coin.CustomizedData = [0, 1, 2, 3, 4, 5, 6, 7];
			_coin.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			_coin.Post_CustomizedData = [8, 85, 0];
			_coin.Create_(8);
			_coin.rollout = excusive_rollout;
			_coin.rollover = excusive_select_action;
			_coin.mousedown = betSelect;
			
			put_to_lsit(_coin);
			
			state_parse([gameState.START_BET]);
		}
		
		public function ocin_setup(mc:MovieClip, idx:int, data:Array):void
		{
			mc["_coin"].gotoAndStop(idx+1);
		}
		
		override public function appear():void
		{
			_regular.FadeIn(_coin.container, 0, 1, null);	
			
			setCoinLimit();
		}
		
		override public function disappear():void
		{			
			_regular.Fadeout(_coin.container, 0, 1);
		}
		
		public function excusive_rollout(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) 
			{				
				return false;
			}
			else 
			{
				_coin.ItemList[idx].gotoAndStop(1);
				_coin.ItemList[idx]["_coin"].gotoAndStop(idx+1);
				return true;
			}			
		}
		
		public function excusive_select_action(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) 
			{				
				return false;
			}
			else 
			{
				_coin.ItemList[idx].gotoAndStop(2);
				_coin.ItemList[idx]["_coin"].gotoAndStop(idx+1);
				return true;
			}
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{			
			var old_select:int = _model.getValue("coin_selectIdx");
			
			_model.putValue("coin_selectIdx", idx);
			
			//position chagne 
			for (var i:int = 0; i < _coin.ItemList.length; i++)
			{
				if ( i == old_select ) 
				{				
					if ( old_select == idx) continue;
					
					var frame:int = _coin.ItemList[old_select]["_coin"].currentFrame;					
					_coin.ItemList[old_select].y += 20;
					_coin.ItemList[old_select].gotoAndStop(1);
					_coin.ItemList[old_select]["_coin"].gotoAndStop(frame);
				}
				if ( i == idx)
				{					
					_coin.ItemList[idx].y -= 20;						
				}
			}
			
			//frame change
			//_coin.exclusive(idx,1);			
			
			return true;
		}
		
		private function setCoinLimit():void {
			var creadit:int = _model.getValue(modelName.CREDIT);
			var coin_limit:Array = null; 
			if (creadit <= 1000) {
				coin_limit = _model.getValue("coin_limit_1000");
			}else if (creadit <= 5000) {
				coin_limit = _model.getValue("coin_limit_5000");
			}else if (creadit <= 10000) {
				coin_limit = _model.getValue("coin_limit_10000");
			}else {
				coin_limit = _model.getValue("coin_limit_50000");
			}
			
			var rePosi_mc:Array = [];
			var coin_selectIdx:int;
			for (var i:int = 0; i < coin_limit.length; i++) {
				GetSingleItem("CoinOb", i).visible = coin_limit[i];
				if (coin_limit[i] == true) {
					rePosi_mc.push(GetSingleItem("CoinOb", i));
					if (rePosi_mc.length == 3) {
						coin_selectIdx =  i;
					}
				}
			}
			
			var xy:Array = _model.getValue(modelName.COIN_SELECT_XY);
			for ( i = 0; i < xy.length; i++) {
				rePosi_mc[i].x = xy[i][0];
				rePosi_mc[i].y = xy[i][1];
			}
			
			var sele_idx:int = _model.getValue("coin_selectIdx");
			if (GetSingleItem("CoinOb", sele_idx).visible == true) {
				GetSingleItem("CoinOb", sele_idx).y -= 20;
				GetSingleItem("CoinOb", sele_idx).gotoAndStop(2);	
				GetSingleItem("CoinOb", sele_idx)["_coin"].gotoAndStop(sele_idx + 1);
			}else{
				_model.putValue("coin_selectIdx", coin_selectIdx);
				rePosi_mc[2].y -= 20;
				rePosi_mc[2].gotoAndStop(2);			
				rePosi_mc[2]["_coin"].gotoAndStop(coin_selectIdx + 1);
			}
		}
			
	}

}