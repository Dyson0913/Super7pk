package util 
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	
	/**
	 * poker regular function
	 * @author hhg4092
	 */
	public class pokerUtil 
	{
		
		public function pokerUtil() 
		{
			
		}
		
		//同花大順
		public static function Check_RoyalFlush(pointCnt:Array,rest_poker_num:int,freedowm:int):Number
		{
			
			return 1;
		}
		
		//同花順
		//同花prob * 順子prob
		public static function Check_StraightFlush(pointCnt:Array,rest_poker_num:int,freedowm:int):Number
		{
			var straight_prob:Number = Check_Straight_prob(pointCnt, rest_poker_num, freedowm);
			var flush_prob:Number = Check_Flush_prob(pointCnt, rest_poker_num, freedowm);
			
			return straight_prob * flush_prob;
		}
		
		//4條
		public static function Check_FourOfAKind_prob(pointCnt:Array,rest_poker_num:int,freedowm:int):Number
		{
			utilFun.Log("rest_poker_num"+ rest_poker_num);
			utilFun.Log("freedom" + freedowm);
			
			var TotalProb:Number = 0;
			for (var k:int = 0; k < pointCnt.length; k++)
			{
				if ( pointCnt[k] != 0)
				{					
					var rest:int = 4 - pointCnt[k] ;
					var nu:Number = 0;
					
					//math 
					if ( rest == 0 ) 
					{
						TotalProb = 100;
						break;
					}
					
					if ( rest > freedowm) 
					{
						utilFun.Log(" rest > freedowm prob = 0")
						TotalProb = 0;
						continue;
					}
					utilFun.Log(" rest  = "+rest )					
					nu  = calprob_cnt(rest, 1, rest_poker_num, rest);					
					TotalProb += nu ;					
				}
			}
			utilFun.Log(" TotalProb = " + TotalProb)
			
			return TotalProb;
		}
		
		//葫蘆
		//TODO
		public static function Check_FullHouse_prob(pointCnt:Array,rest_poker_num:int,freedowm:int):Number
		{
			utilFun.Log("rest_poker_num"+ rest_poker_num);
			utilFun.Log("freedom" + freedowm);
			
			var TotalProb:Number = 0;
			for (var k:int = 0; k < pointCnt.length; k++)
			{
				if ( pointCnt[k] != 0)
				{					
					var rest:int = 4 - pointCnt[k] ;
					var nu:Number = 0;
					
					//math 
					if ( rest == 0 ) 
					{
						TotalProb = 100;
						break;
					}
					
					if ( rest > freedowm) 
					{
						utilFun.Log(" rest > freedowm prob = 0")
						TotalProb = 0;
						continue;
					}
					utilFun.Log(" rest  = "+rest )					
					nu  = calprob_cnt(rest, 1, rest_poker_num, rest);					
					TotalProb += nu ;					
				}
			}
			utilFun.Log(" TotalProb = " + TotalProb)
			
			return TotalProb;
		}
		
		//同花
		public static function Check_Flush_prob(pointCnt:Array,rest_poker_num:int,freedowm:int):Number
		{
			utilFun.Log("rest_poker_num"+ rest_poker_num);
			utilFun.Log("freedom" + freedowm);
			
			var TotalProb:Number = 0;
			for (var k:int = 0; k < pointCnt.length; k++)
			{
				if ( pointCnt[k] != 0)
				{					
					var rest:int = 5 - pointCnt[k] ;
					var nu:Number = 0;
					
					//math 
					if ( rest == 0 ) 
					{
						TotalProb = 100;
						break;
					}
					
					if ( rest > freedowm) 
					{
						utilFun.Log(" rest > freedowm prob = 0")
						TotalProb = 0;
						continue;
					}
					//  4          3           2          1
					//12/51   11/50   10/49    9/48
					
					utilFun.Log(" rest  = " + rest )	
					var flush_diff:int = 8 + rest;
					nu  = calprob_cnt(flush_diff,1, rest_poker_num,rest);
					TotalProb += nu ;					
				}
			}
			utilFun.Log(" TotalProb = " + TotalProb)
			return TotalProb;
		}
		
		//順子		
		//1,2,3,4,5,6,7,8,9,10,11,12,13
		//5,6,7,8,9 前4,後4   
		//1,2,3,4 ,只check 後4,+前(1,2,3)
		//11,12,13 10只check 前4 +後(1,2,3 ,check 1)		
		public static function Check_Straight_prob(pointCnt:Array,rest_poker_num:int,freedowm:int):Number
		{		
			utilFun.Log("rest_poker_num"+ rest_poker_num);
			utilFun.Log("freedom" + freedowm);
			
			//pre check
			
			
			var TotalProb:Number = 0;
			var total_rest:int = 5;
			for (var k:int = 0; k < pointCnt.length; k++)
			{				
				if ( pointCnt[k] != 0)
				{		
					var total_select_able_card:int = 0;
					var rest:int = 4 ;
					if ( k == 5 || k == 6 || k == 7 || k == 8 || k == 9)
					{						
						utilFun.Log("56789 total_select_able_card = " + total_select_able_card);
						if (  pointCnt[k - 1] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k - 2] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k - 3] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k - 4] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 1] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 2] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 3] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 4] == 0) total_select_able_card += 4;					
						else rest -= 1;
						
						total_rest -= 1;
						//32/51 *  28 /50 *  24/49 * 20/48 							
						utilFun.Log("56789after sub = " + total_select_able_card);
						utilFun.Log("56789 rest = " + rest);
						TotalProb += calprob_cnt(total_select_able_card, 4, rest_poker_num, rest);
						utilFun.Log(" 5678 s TotalProb = " + TotalProb)
					}
					
					if (k==1 ||  k == 2 || k == 3 || k == 4 )
					{	
						utilFun.Log("1234 total_select_able_card = " + total_select_able_card);					
						if (  pointCnt[k + 1] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 2] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 3] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k + 4] == 0) total_select_able_card += 4;					
						else rest -= 1;
						
						if ( k == 2) 
						{
							if (  pointCnt[k - 1] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						if ( k == 3) 
						{
							if (  pointCnt[k - 1] == 0) total_select_able_card += 4;
							else rest -= 1;
							if (  pointCnt[k - 2] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						if ( k == 4) 
						{
							if (  pointCnt[k - 1] == 0) total_select_able_card += 4;
							else rest -= 1;
							if (  pointCnt[k - 2] == 0) total_select_able_card += 4;
							else rest -= 1;
							if (  pointCnt[k - 3] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						
						total_rest -= 1;
						//32/51 *  28 /50 *  24/49 * 20/48 							
						utilFun.Log("1234 after sub = " + total_select_able_card);
						utilFun.Log("1234 rest = " + rest);
						TotalProb += calprob_cnt(total_select_able_card, 4, rest_poker_num, rest);
						utilFun.Log(" 1234 s TotalProb = " + TotalProb)
					}
					
					if (k ==10 || k == 11 || k == 12 || k == 13 )
					{
						utilFun.Log("10,11,12.13 total_select_able_card = " + total_select_able_card);
						if (  pointCnt[k - 1] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k - 2] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k - 3] == 0) total_select_able_card += 4;
						else rest -= 1;
						if (  pointCnt[k - 4] == 0) total_select_able_card += 4;
						else rest -= 1;
						
						if ( k == 10) 
						{
							if (  pointCnt[k - 9] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						if ( k == 11) 
						{
							if (  pointCnt[k + 1] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						if ( k == 12) 
						{
							if (  pointCnt[k + 1] == 0) total_select_able_card += 4;
							else rest -= 1;
							if (  pointCnt[k + 2] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						if ( k == 13) 
						{
							if (  pointCnt[k + 1] == 0) total_select_able_card += 4;
							else rest -= 1;
							if (  pointCnt[k + 2] == 0) total_select_able_card += 4;
							else rest -= 1;
							if (  pointCnt[k + 3] == 0) total_select_able_card += 4;
							else rest -= 1;
						}
						
						total_rest -= 1;
						//32/51 *  28 /50 *  24/49 * 20/48 							
						utilFun.Log("10,11.12.13 after sub = " + total_select_able_card);
						utilFun.Log("10,11.12.13 rest = " + rest);
						TotalProb += calprob_cnt(total_select_able_card, 4, rest_poker_num, rest);
						utilFun.Log("10,11.12.13 s TotalProb = " + TotalProb)
					}
					
				}
				
				
			}
			if ( total_rest == 0) TotalProb = 100;				
			
			//TODO check
			if ( total_rest > freedowm) TotalProb = 0;				
				
			utilFun.Log(" TotalProb = " + TotalProb)
			
			return TotalProb;
		}
		
		
		public static function calprob_cnt(num:int ,num_sub:int, Denominator:int,Cnt:int):Number
		{
			if ( Cnt == 1) return num / (Denominator);
			
			return (num / Denominator) *  calprob_cnt(num -num_sub,num_sub, Denominator-1,Cnt-1);
		}
		
		public static function ca_point(mypoker:Array):int
		{			
			var point :int ;
			var pointar:Array  = get_Point( mypoker);
			point = Get_Mapping_Value([0, 1], pointar);
			
			point %= 10;
			//if ( point == 0) point = 10;
			return point;		
		}
		
		public static function showpoker(mc:MovieClip, idx:int, data:Array):void
		{			
			mc.visible = true;
		}	
		
		public static function hidepoker(mc:MovieClip, idx:int, data:Array):void
		{			
			mc.visible = false;
		}	
		
		public static function showPoker(mc:MovieClip, idx:int, data:Array):void
		{			
			var idx:int = pokerUtil.pokerTrans(data[idx])			
			utilFun.scaleXY(mc, 0.8, 0.8);
			mc.gotoAndStop(idx);
		}	
		
			public static function pokerTrans_s(strpoker:String):int
		{			
			var point:String = strpoker.substr(0, 1);
			var color:String = strpoker.substr(1, 1);
			
			var myidx:int = 0;
			
			if ( color == "c") myidx = 0;
			if ( color == "d") myidx = 13;
			if ( color == "h") myidx = 26;
			if ( color == "s") myidx = 39;
				
			if ( point == "i") myidx += 9;
			else if ( point == "j") myidx += 10;
			else if ( point == "q") myidx += 11;
			else if ( point == "k") myidx += 12;
			else 	myidx +=  (parseInt(point) - 1) ;
			
			return myidx;
		}
		
		public static function pokerTrans(strpoker:String):int
		{			
			var point:String = strpoker.substr(0, 1);
			var color:String = strpoker.substr(1, 1);
			
			var myidx:int = 0;
			
			if ( color == "d") myidx = 1;
			if ( color == "h") myidx = 2;
			if ( color == "s") myidx = 3;
			if ( color == "c") myidx = 4;
				
			if ( point == "i") myidx += (9*4);
			else if ( point == "j") myidx += (10*4);
			else if ( point == "q") myidx += (11*4);
			else if ( point == "k") myidx += (12*4);
			else 	myidx +=  (parseInt(point) - 1) * 4;
			
			return myidx;
		}
		
		public static function newnew_judge(pok:Array):Array
		{		
			//var pok:Array = ["kc", "1h", "jd", "9h", "jh"];
			//var pok:Array = ["3c", "4h", "kd", "3h", "1h"];
			var po:Array = ["0", "1", "2", "3", "4"];
			
			var point:Array = pokerUtil.get_Point(pok);
			var totalPoint:int = pokerUtil.Get_Mapping_Value(po, pok);			
			
			var arr:Array = utilFun.easy_combination(po, 3);
			var answer:Array = [];
			var restmax:int = 0;
			for (var i:int = 0; i < arr.length; i++)
			{
				var total:int = 0;
				var rest:int = 0;
				var cobination:Array = arr[i];
				//utilFun.Log("conbi=" + cobination) ;
				total = Get_Mapping_Value(cobination, point);
				rest = totalPoint - total;
                //utilFun.Log( "list:" + cobination + " = " + total  +" rest ="+ rest);
				total %= 10;
				rest %= 10;
				if ( total == 0)
				{
					if ( rest >= restmax )
					{
						restmax = rest;
						answer.length = 0;
						answer.push.apply(answer, cobination);						
					}
				}
			}
			
			//utilFun.Log( "answer:" + answer);
			
			if ( answer.length !=0)
			{				
				answer.push.apply(answer, pokerUtil.Get_restItem(po, answer));
			}
			else answer = ["0", "1", "2", "3", "4"];
			
			//utilFun.Log( "final answer:" + answer);
			return answer;
		}
		
		public static function poer_shift(pokerlist:Array,best3:Array):void
		{
			var position:Array = [];
			for (var i:int = 0; i < pokerlist.length; i++)
			{
				var shift:int= 0;
				if ( i == 1 ) shift = 20;
				if ( i == 2) shift = 40;
				if ( i == 3) shift = 20;
				if ( i == 4) shift = 40;
				position.push(pokerlist[i].x -shift);
			}
			
			for (var k:int = 0; k < pokerlist.length; k++)
			{
				Tweener.addTween(pokerlist[best3[k]], { x:position[k], transition:"easeOutQuint", time:1 } );
			}
		}
		
		/**
		 * @param	idxList  = [1,2,3]
		 * @param	mapping = [10,11,12,13,14] 
		 * @return   11+12+13
		 */
		public static function Get_Mapping_Value(idxList:Array,mapping:Array):int
		{
			var n:int = idxList.length;
			var total:int = 0;
			for (var i:int = 0;  i < n; i++)
			{
				total += mapping[idxList[i]];
			}
			return total;
		}
		
		/**
		 * @param	origi [10,11,12,13,14]
		 * @param	own  [0,1,3]
		 * @return   [12,14]
		 */
		public static function Get_restItem(origi:Array,own:Array):Array
		{
			var rest_item:Array = [];
			var n:int = origi.length
		  	for (var i:int = 0; i < n; i++)
			{
				if (  own.indexOf(origi[i]) == -1 ) rest_item.push(i);
			}
			
			return rest_item;
		}
		
		public static function get_Point(poke:Array):Array
		{
			var point:Array = [];
			var n:int = poke.length;
			for (var i:int = 0; i < n; i++)
			{
				point.push( pokerUtil.get_Baccarat_Point(poke[i]) );				
			}
			return point;
		}
		
		public static function get_Baccarat_Point(poke:String):int
		{
			var point:String = poke.substr(0, 1);
			
			if ( point == "i" ||  point == "j" || point == "q" || point == "k") return 10;			
			return parseInt(point);			
		}
		
		public static function countPoint(poke:Array):int
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
			
			total %= 10;			
			return total;
		}
	}

}