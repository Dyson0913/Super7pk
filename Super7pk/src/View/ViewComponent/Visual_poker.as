package View.ViewComponent 
{
	import flash.display.MovieClip;
	import util.math.Path_Generator;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;	
	import Command.*;
	
	/**
	 * poker present way
	 * @author ...
	 */
	public class Visual_poker  extends VisualHandler
	{
		private var pokerpath:Array = [];
		
		public function Visual_poker() 
		{
			
		}
		
		public function init():void
		{			
			var table_hint:MultiObject = create("table_hint", [ResName.open_tableitem]);						
			table_hint.Create_(1, "table_hint");
			table_hint.container.x = 200;
			table_hint.container.y = 567;	
			table_hint.container.visible = false;
			
			var pokerkind:Array = [ResName.just_turnpoker];
			var playerCon:MultiObject = create(modelName.PLAYER_POKER, pokerkind);
			playerCon.Post_CustomizedData = [2, 204, 0];
			playerCon.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;			
			playerCon.Create_(2, "playerpoker");
			playerCon.container.x = 259;
			playerCon.container.y = 634;
			playerCon.container.alpha = 0;
			
			var bankerCon:MultiObject =  create(modelName.BANKER_POKER, pokerkind);
			bankerCon.Post_CustomizedData = [2, 204, 0];
			bankerCon.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;			
			bankerCon.Create_(2, "bankerpoker");
			bankerCon.container.x = 1277;
			bankerCon.container.y = 634;
			bankerCon.container.alpha = 0;
			
			var riverCon:MultiObject = create(modelName.RIVER_POKER, pokerkind);
			riverCon.Post_CustomizedData = [2, 204, 0];
			riverCon.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;		
			riverCon.Create_(2,"riverpoker");
			riverCon.container.x = 774;
			riverCon.container.y = 634;
			riverCon.container.alpha = 0;
			
			var mipoker:MultiObject =  create("mipoker", [ResName.Mipoker_zone]);	
			mipoker.Create_(1, "mipoker");
			mipoker.container.x = 740;
			mipoker.container.y = 570;
			mipoker.container.alpha = 0;
			
			put_to_lsit(table_hint);
			put_to_lsit(playerCon);
			put_to_lsit(bankerCon);
			put_to_lsit(riverCon);
			put_to_lsit(mipoker);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{			
			var pokerkind:Array = [ResName.just_turnpoker];
			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);
			playerCon.CleanList();				
			playerCon.Create_(2, "playerpoker");
			Tweener.pauseTweens(playerCon.container);
			playerCon.container.alpha = 0;				
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
			bankerCon.CleanList();			    
			bankerCon.Create_(2, "bankerpoker");
			Tweener.pauseTweens(bankerCon.container);
			bankerCon.container.alpha = 0;
			
			var riverCon:MultiObject = Get(modelName.RIVER_POKER);
			riverCon.CleanList();				
			riverCon.Create_(2, "riverpoker");
			Tweener.pauseTweens(riverCon.container);
			riverCon.container.alpha = 0;
			
			Get("mipoker").CleanList();		
			Get("mipoker").Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");			
			Get("mipoker").container.alpha = 0;
			
			_model.putValue(modelName.PLAYER_POKER, [] );
			_model.putValue(modelName.BANKER_POKER, [] );
			_model.putValue(modelName.RIVER_POKER, []);
			
			Get("table_hint").container.visible = false;
			
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function poker_display():void
		{			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);					
			_regular.FadeIn(playerCon.container, 1, 1,null);
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);			
			_regular.FadeIn(bankerCon.container, 1, 1,null);
			
			var riverCon:MultiObject = Get(modelName.RIVER_POKER);			
			_regular.FadeIn(riverCon.container, 1, 1, null);
			
			Get("table_hint").container.visible = true;
			//utilFun.Log("poker_display = "+ playpoker[0]);
			//_regular.FadeIn_no_out(playpoker[0] , 0.5, 1, this.soun);
		}
		
		//public function soun():void
		//{
			//utilFun.Log("soun = "+ playpoker.length);
			//dispatcher(new StringObject("sound_coin", "sound" ) );
			//if ( playpoker.length != 0)
			//{				
				//_regular.FadeIn_no_out(playpoker[0] , 0.1, 0, this.soun);
			//}
		//}
		
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_No_mi")]
		public function poker_no_mi(type:Intobject):void
		{
			var mypoker:Array =   _model.getValue(type.Value);
			for ( var pokernum:int = 0; pokernum < mypoker.length; pokernum++)
			{				
				var pokerid:int = pokerUtil.pokerTrans(mypoker[pokernum])
				var anipoker:MovieClip = GetSingleItem(type.Value, pokernum);
				anipoker.visible = true;
				anipoker.gotoAndStop(1);
				anipoker["_poker"].gotoAndStop(pokerid);				
				anipoker.gotoAndStop(anipoker.totalFrames);				
				//Tweener.addTween(anipoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0],onComplete:this.pullback} );
			}				
			dispatcher(new Intobject(type.Value, "show_judge"));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_mi")]
		public function poker_mi(type:Intobject):void
		{
			
			var mypoker:Array =   _model.getValue(type.Value);
			var pokerid:int = pokerUtil.pokerTrans(mypoker[mypoker.length - 1]);		
			if ( mypoker.length == 2 && type.Value != modelName.RIVER_POKER )
			{	
				
				Get("mipoker").CleanList();		
				Get("mipoker").Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");
				Get("mipoker").container.alpha = 0;
				
				
				var mipoker:MultiObject = Get("mipoker");
				if ( type.Value == modelName.PLAYER_POKER)
				{
					mipoker.container.x = 500;
					mipoker.container.y = 680;
				}
				if ( type.Value == modelName.RIVER_POKER)
				{
					mipoker.container.x = 1020;
					mipoker.container.y = 680;
				}
				if ( type.Value == modelName.BANKER_POKER)
				{
					mipoker.container.x = 1500;
					mipoker.container.y = 680;
				}
				
				var mc:MovieClip = mipoker.ItemList[0];
				
				var pokerf:MovieClip = utilFun.GetClassByString(ResName.Poker);				
				var pokerb:MovieClip = utilFun.GetClassByString(ResName.poker_back);				
				var pokerm:MovieClip = utilFun.GetClassByString(ResName.pokermask);
				pokerb.x  = 39;
				pokerb.y  = 28;
				pokerf.x = pokerb.x;
				pokerf.y  = pokerb.y;
				pokerm.x = 136.35;
				pokerm.y = 185.8;
				pokerf.gotoAndStop(pokerid);
				pokerf.visible = false;
				pokerf.addChild(pokerm);
				mc.addChild(pokerf);
				mc.addChild(pokerb);
				
				//_tool.SetControlMc(pokerb);
				//add(_tool);				
				Tweener.addTween(mipoker.container, { alpha:1, time:1, onCompleteParams:[pokerf,pokerid,type.Value],onComplete:this.poker_mi_ani } );
				
				return;
			}			
			
			var anipoker:MovieClip = GetSingleItem(type.Value, mypoker.length - 1);
			anipoker.visible = true;
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);			
			anipoker.gotoAndPlay(2);
			_regular.Call(anipoker, { onComplete:this.show_point_prob, onCompleteParams:[type.Value] }, 1, 0, 1);
			dispatcher(new StringObject("sound_poker_turn","sound" ) );
			//Tweener.addTween(anipoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0,mypoker.length,type.Value],onComplete:this.pullback} );
		}
		
		public function poker_mi_ani(pokerf:MovieClip,pokerid:int,pokertype:int):void
		{
			pokerf.visible = true;
			Tweener.addTween(pokerf, { x: (pokerf.x +50) , time:1, transition:"easeInSine" , onCompleteParams:[pokerf,pokerid,pokertype], onComplete: this.poker_mi_ani_2 } );			
		}
		
		public function poker_mi_ani_2(pokerf:MovieClip,pokerid:int,pokertype:int):void
		{
			//see 0.5 s
			Tweener.addTween(pokerf, { x: (pokerf.x +32) , time:1, delay:0.5, transition:"easeInSine",onCompleteParams:[pokerf,pokerid,pokertype],onComplete: this.sec_wait } );			
		}
		
		public function sec_wait(pokerf:MovieClip,pokerid:int, pokertype:int):void
		{
			//see 0.5 again
			Tweener.addTween(pokerf, { delay:0.5, transition:"easeInSine",onCompleteParams:[pokerf,pokerid,pokertype],onComplete: this.sec_wait_to_see } );
		}
		
		public function sec_wait_to_see(pokerf:MovieClip, pokerid:int, pokertype:int):void
		{
			//staty 0.5 to check 			
			//Tweener.addTween(pokerf, { delay:0.5} );
			Tweener.addTween(pokerf, { delay:0.5, transition:"easeInSine",onCompleteParams:[pokerid,pokertype],onComplete: this.showfinal } );
		}
		
		public function showfinal(pokerid:int,pokertype:int):void
		{
			var mipoker:MultiObject = Get("mipoker");
			Tweener.addTween(mipoker.container, { alpha:0, time:1 } );
			var anipoker:MovieClip = GetSingleItem(pokertype, 1);
			anipoker.visible = true;			
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);	
			anipoker.gotoAndStop(anipoker.totalFrames);
			
			show_point_prob(pokertype);
		}
		
		
		public function pullback(anipoker:MovieClip,mc:MovieClip,angel:int,pokerle:int,type:int):void
		{			
			if ( pokerle == 1)	Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel,type], onComplete: this.dis } );	
			else Tweener.addCaller( anipoker, { time:2 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel, type], onComplete: this.dis } );
			
		}
		
		public function dis(anipoker:MovieClip,mc:MovieClip,angel:int,type:int):void
		{	
			anipoker.gotoAndPlay(7);				
			Tweener.addTween(mc, { rotationZ:angel, time:1, delay:1 } );
			Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[type], onComplete: this.show_point_prob } );	
		}
		
		public function show_point_prob(type:int):void
		{			
			
			dispatcher(new Intobject(type, "show_judge"));
			
			prob_cal();
			dispatcher(new Intobject(type, "caculate_prob"));
			
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="show_judge")]
		public function early_check_point(type:Intobject):void
		{
			var Mypoker:Array =   _model.getValue(type.Value);
			
			var zone:int = -1;
			if ( modelName.PLAYER_POKER == type.Value)  zone = 0;
			else if ( modelName.BANKER_POKER == type.Value) zone = 1;
			if ( zone == -1 ) return;
			
			if ( Mypoker.length != 2) return;
			
			var point:int = pokerUtil.ca_point(Mypoker);
			utilFun.Log("point = " + point);
			if ( point == 0) point = 10;
			GetSingleItem("zone", zone ).gotoAndStop(2);
			GetSingleItem("zone", zone)["_num0"].gotoAndStop(point);
			if ( zone == 0)
			{
				dispatcher(new StringObject("sound_player", "sound" ) );			
			}
			else
			{
				dispatcher(new StringObject("sound_deal", "sound" ) );
			}
			
			_regular.Call(this, { onComplete:this.playPoint,onCompleteParams:[point] }, 1, 0.5, 1, "linear");
		
			
			//是否該提示公牌
			dispatcher(new Intobject(type.Value, "check_opencard_msg"));			
		}
		
		public function playPoint(point:int):void
		{
			utilFun.Log("playPoint = " + point);
			if ( point == 10) point = 0;
			dispatcher(new StringObject("sound_" + point, "sound" ) );
			if ( point == 9) 
			{
				_regular.Call(this, { onComplete:this.po,onCompleteParams:[point] }, 1, 0.5, 1, "linear");
				
			}
		}
		
		public function po(point:int):void
		{
			dispatcher(new StringObject("sound_point", "sound" ) );
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="check_opencard_msg")]
		public function early_check_result(type:Intobject):void
		{			
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);			
			
			if ( ppoker.length + bpoker.length != 4) return;
			dispatcher(new ModelEvent("show_public_card_hint"));		
		}
		
		
		
		
		//TODO compare to pounit
		private function countPoint(poke:Array):int
		{
			var total:int = 0;
			for (var i:int = 0; i < poke.length ; i++)
			{
				var strin:String =  poke[i];
				var arr:Array = strin.match((/(\w|d)+(\w)+/));					
				var numb:String = arr[1];				
				
				var point:int = 0;
				if ( numb == "i" || numb == "j" || numb == "q" || numb == "k" ) 				
				{
					point = 10;
				}				
				else 	point = parseInt(numb);
				
				total += point;
			}	
			
			return total %= 10;
		}		
		
		
		public function prob_cal():void
		{
			var arr:Array = utilFun.Random_N(80, 6);
			arr.push(utilFun.Random(6));
			_model.putValue("percent_prob",arr);
			return;
			
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			var rpoker:Array =   _model.getValue(modelName.RIVER_POKER);
			
			var totalPoker:Array = [];			
			totalPoker = totalPoker.concat(ppoker);
			totalPoker = totalPoker.concat(bpoker);
			totalPoker = totalPoker.concat(rpoker);
			var rest_poker_num:int = 52 - totalPoker.length;
			var freedowm:int = 6 - totalPoker.length;
			utilFun.Log("rest_poker_num = " + rest_poker_num);
			utilFun.Log("totalpoker = " + totalPoker);
			totalPoker.sort(order);
			utilFun.Log("after sort = " + totalPoker);
			var num_amount:Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			var color_amount:Array = [0,0,0,0];
			
			for ( var i:int = 0; i < totalPoker.length; i++)
			{
				var point:String = totalPoker[i].substr(0, 1);
				var color:String = totalPoker[i].substr(1, 1);
				if ( color == "d") color_amount[0] += 1;	
				if ( color == "h") color_amount[1] += 1;	
				if ( color == "s") color_amount[2] += 1;	
				if ( color == "c") color_amount[3] += 1;	
				
				if ( point == "i" ) point = "10";
				if ( point == "j" ) point = "11";
				if ( point == "q" ) point = "12";
				if ( point == "k" ) point = "13";				
				num_amount[parseInt(point)] += 1;				
			}
			utilFun.Log("num_amount= " + num_amount);
			utilFun.Log("color_amount= d =" + color_amount[0] +" h =" +color_amount[1]+" s =" +color_amount[2]+" c =" +color_amount[3]);
			
			//3條 (每個張數都要算)
			var three:int = 0;			
			var maxValue:Number = Math.max.apply(null, num_amount);
			//var minValue:Number = Math.min.apply(null, num_amount);
			//utilFun.Log("maxValue= " + maxValue);			
			//utilFun.Log("three_prob  = (4- samepoint_max_cnt/rest_poker_num)= " + (4 - maxValue) / rest_poker_num * 100);
			
			//pokerUtil.Check_FourOfAKind_prob(num_amount,rest_poker_num,freedowm);
			//pokerUtil.Check_Flush_prob(color_amount,rest_poker_num,freedowm);
			//pokerUtil.Check_Straight_prob(num_amount,rest_poker_num,freedowm);
			pokerUtil.Check_FullHouse_prob(num_amount,rest_poker_num,freedowm);
			
			
			
		}		
		
		
		
		//傳回值 -1 表示第一個參數 a 是在第二個參數 b 之前。
		//傳回值 1 表示第二個參數 b 是在第一個參數 a 之前。
		//傳回值 0 指出元素都具有相同的排序優先順序。
		private function order(a:String, b:String):int 
		{
			var apoint:String = a.substr(0, 1);
			var bpoint:String = b.substr(0, 1);
			if ( apoint == "i" ) apoint = "10";
			if ( apoint == "j" ) apoint = "11";
			if ( apoint == "q" ) apoint = "12";
			if ( apoint == "k" ) apoint = "13";
			
			if ( bpoint == "i" ) bpoint = "10";
			if ( bpoint == "j" ) bpoint = "11";
			if ( bpoint == "q" ) bpoint = "12";
			if ( bpoint == "k" ) bpoint = "13";
			
			if ( parseInt( apoint)  < parseInt( bpoint) ) return -1;
			else if (  parseInt( apoint) > parseInt( bpoint )) return 1;
			else return 0;			
		}	 
	
	}

}