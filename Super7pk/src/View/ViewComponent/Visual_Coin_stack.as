package View.ViewComponent 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Sprite;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * coin present way
	 * @author ...
	 */
	public class Visual_Coin_stack  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;	
		
		//sound name
		public const soundcoin:String = "sound_coin";
		
		private const amount:int = 0;
		
		//coin seperate to N stack
		private var _stack_num:int = 1;
		
		//res
		public const Betcoin:String = "Bet_coin";
		public const Wincoin:String = "Win_coin";
		public const r_coin_amount:String = "coin_amount";
		
		public function Visual_Coin_stack() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);						
			var coin_xy:Array = _model.getValue(modelName.COIN_STACK_XY);
			
			var coinstack:MultiObject = create("coinstakeZone", [ResName.emptymc]);			
			coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coinstack.Post_CustomizedData =  coin_xy;
			coinstack.container.x = 3;
			coinstack.container.y = 605;
			coinstack.Create_(avaliblezone.length);
			coinstack.container.visible = false;
			
			put_to_lsit(coinstack);
			
			var amount_xy:Array = _model.getValue(modelName.COIN_AMOUNT_XY);
			//coin amount
			var coin_amount_container:MultiObject = create("coin_amount_container", [ResName.emptymc]);
			coin_amount_container.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coin_amount_container.Post_CustomizedData =  amount_xy;
			coin_amount_container.CustomizedFun = obinit;
			coin_amount_container.CustomizedData = amount_xy;
			coin_amount_container.container.x = -47;
			coin_amount_container.container.y = 565;
			coin_amount_container.Create_(12);			
			
			put_to_lsit(coin_amount_container);
			
			disappear();
		}
		
		public function obinit(mc:MovieClip, idx:int, data:Array):void
		{
			var res:Array =  [r_coin_amount];
			var coin_amount_:MultiObject = create(r_coin_amount + "_" + idx,  res, mc);			
			coin_amount_.Create_(res.length);			
			
			object_init(r_coin_amount + "_" + idx, amount);			
			
			//put_to_lsit(progress_bar);	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			appear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			disappear();
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function opencard_parse():void
		{
			disappear();
		}	
		
		public function appear():void
		{
			Get("coinstakeZone").container.visible = true;
			
			//TODO obinit way
			Clean_poker();
			
			var mu:MultiObject = Get("coin_amount_container");
			mu.FlushObject();
			
			var total:Array = _model.getValue("round_paytable");
			if ( total != null)
			{
				for ( var i:int = 0; i < total.length ; i++)
				{					
					//type
					data_setting(r_coin_amount + "_" + i, amount, total, i);
				}
			}
		}
		
		public function disappear():void
		{
			Get("coinstakeZone").container.visible = false;
			
			var mu:MultiObject = Get("coin_amount_container");
			mu.FlushObject();
			
			//TODO obinit way
			Clean_poker();
		}
		
		//dock type handle
		public function object_init(obname:String,resTag:int):void
		{
			if ( Get(obname).resList[resTag] == r_coin_amount)
			{
				coin_setting(GetSingleItem(obname, resTag), 0);
			}			
		}
		
		public function data_setting(obname:String, resTag:int, data:Array, data_idx:int):void
		{
			if ( Get(obname).resList[resTag] == r_coin_amount)
			{
				coin_setting(GetSingleItem(obname, resTag), data[data_idx]);
			}
		}
		
		public function Clean_poker():void
		{
			//TODO why not 
			//Get("coinstakeZone").Clear_itemChildren();		
			var a:MultiObject = Get("coinstakeZone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",i));
			}		
			
			a.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			a.Post_CustomizedData =  _model.getValue(modelName.COIN_STACK_XY);
			a.customized();
			
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCoin")]
		public function updateCredit():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();			
			_Actionmodel.dropMsg();
			
			//TODO  一次一次pop
			_betCommand.re_bet();
			
			play_sound(soundcoin);		
			
			//coin amount
			//var type:int = bet_ob["betType"];
			//var total:int = _betCommand.get_total_bet(type);
			//TODO temp way
			//var mylist:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];			
			//mylist.splice(type, 0, total);		
			//
			
			
			
			//coin動畫
			stack(_betCommand.Bet_type_betlist(bet_ob["betType"]), GetSingleItem("coinstakeZone",bet_ob["betType"] ),bet_ob["betType"]);	
		}
		
		private function coin_setting(mc:MovieClip,data:Number):void
		{			
			utilFun.Clear_ItemChildren(mc);
			if ( data == 0 ) return;
			if ( data == -1 ) return;
			var arr:Array = data.toString().split("");
			arr.unshift(11);
			var num:int = arr.length;
			var p_num:MultiObject = create_dynamic(mc.parent.name, [r_coin_amount], mc);			
			p_num.CustomizedFun = FrameSetting;
			p_num.CustomizedData = arr.reverse();
			p_num.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			p_num.Post_CustomizedData = [num, -18, 0];		
			p_num.Create_(num);
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			if ( data[idx] == 0 ) data[idx] = 10;
			if ( data[idx] == ".") data[idx] = 12;
			mc.gotoAndStop(data[idx]);
		}
		
		public function stack(Allcoin:Array,contain:DisplayObjectContainer,bettype:int):void
		{			
			utilFun.Clear_ItemChildren(contain);
			var coin:Array = [];
			var shY:int = 0;
			var shX:int = 0;
			var coinshY:int = -5;		
			
			for (var i:int = 0; i < _stack_num ; i++)
			{				
				//每疊coin 的multiobject
				createcoin(i, Allcoin.concat(), contain,shY,shX,coinshY,bettype);
			}			
		}
		
		public function createcoin(cointype:int, Allcoin:Array, contain:DisplayObjectContainer ,shY:int,shX:int,coinshY:int,bettype:int):void
		{			
			//var coin:Array = [];			
			//while (coinstack.indexOf(_model.getValue("coin_list")[cointype]) != -1)
			//{
				//var idx:int = coinstack.indexOf( _model.getValue("coin_list")[cointype]);
				//coin.push(coinstack[idx]);
				//coinstack.splice(idx, 1);
			//}
			//			
			
			var shifty:int = 0;
			var shiftx:int = 0;
			
			//push bet_type in first
			Allcoin.unshift(bettype);
			
			var secoin:MultiObject = new MultiObject();
			secoin.CleanList();
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = Allcoin;
			secoin.setContainer(contain);
			secoin.Create_by_list( Allcoin.length-1, [Betcoin] , 0 +shiftx+ (cointype * shX) , 0+shifty +shY, 1, 0, coinshY, "Bet_1");			
		}
		
		public function coinput(mc:MovieClip, idx:int, betlist_with_type_in_first:Array):void
		{
			mc.gotoAndStop(3);
			
			var coin:Array = _model.getValue("coin_list");		
			var frame:int = coin.indexOf(betlist_with_type_in_first[idx + 1]);		
			mc["_coin"].gotoAndStop(frame+1);
			mc["_text"].text = "";
			
			
			if ( idx ==  (betlist_with_type_in_first.length-2))
			{
				var total:int = _betCommand.get_total_bet(betlist_with_type_in_first[0]);			
				mc["_text"].text = total.toString();
			}			
		}	
		
		
		public function Dynaimic_stack(Allcoin:Array, contain:DisplayObjectContainer,bettype:int,path:Array):MultiObject
		{						
			var coin:Array = [];		
			
			Allcoin.unshift(bettype);		
			utilFun.Log("Allcoin=" + Allcoin);			
			var secoin:MultiObject = new MultiObject();			
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = Allcoin;			
			secoin.setContainer(new Sprite());
			//Get("coinstakeZone").container.addChild(secoin.container);
			secoin.container.x = path[0];
			secoin.container.y = path[1];
			contain.addChild(secoin.container);
			secoin.Create_by_list( Allcoin.length - 1, [Wincoin] , 0  , 0, 1, 0, -5, "Bet_"+bettype);			
			
			return secoin;
		}	
		
		public function one_stack(totalamount:int, contain:DisplayObjectContainer,bettype:int,path:Array):MultiObject
		{						
			var coin:Array = [];		
			
			var secoin:MultiObject = new MultiObject();			
			secoin.CustomizedFun = just_setting;
			secoin.CustomizedData = [totalamount];
			secoin.setContainer(new Sprite());			
			secoin.container.x = path[0];
			secoin.container.y = path[1];
			contain.addChild(secoin.container);
			secoin.Create_by_list( 1, [Wincoin] , 0  , 0, 1, 0, -5, "Bet_");			
			
			return secoin;
		}	
		
		public function just_setting(mc:MovieClip, idx:int, totalamount:Array):void
		{			
			mc["_text"].text = totalamount[0];			
		}		
		
	}

}