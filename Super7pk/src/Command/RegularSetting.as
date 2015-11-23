package Command 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import util.utilFun;
	import caurina.transitions.Tweener;
	import View.Viewutil.MultiObject;
	
	/**
	 * regular setting fun
	 * @author hhg4092
	 */
	public class RegularSetting 
	{
		
		public function RegularSetting() 
		{
			
		}		
		
		//relative position adjust
		public function Posi_x_Setting(mc:MovieClip, idx:int, data:Array):void
		{		
			mc.x += data[idx];
		}
		
		public function Posi_y_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			mc.y += data[idx];
		}
		
		public function Posi_xy_Setting(mc:MovieClip, idx:int, data:Array):void
		{
			var po:Array = data[idx]
			mc.x = po[0];
			mc.y = po[1];
		}
		
		public function FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{
			mc.gotoAndStop(data[idx]);
		}
		
		public function textSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			utilFun.SetText(mc["_Text"],data[idx])
		}
		
		public function moveTo(mc:Object,  x_move:int , y_move:int, t:int,de:int,onComF:Function):void
		{
			Tweener.addTween(mc, { x:x_move,y:y_move, time:t,transition:"linear", delay:de,onComplete:onComF } );
		}
		
		public function FadeIn_no_out(mc:DisplayObjectContainer,  in_t:Number , de:Number,onComF:Function):void
		{
			Tweener.addTween(mc, { alpha:1, time:in_t, delay:de,onComplete:onComF } );
		}
		
		public function FadeIn(mc:DisplayObjectContainer,  in_t:int , out_t:int, onComF:Function):void
		{
			Tweener.addTween(mc, { alpha:1, time:in_t, onCompleteParams:[mc,0,out_t],onComplete:onComF } );
		}
		
		public function empty_FadeInfun(mc:MovieClip, a:int, t:int):void
		{
			
		}
		
		public function Fadeout(mc:DisplayObjectContainer, a:int, t:int):void
		{
			Tweener.addTween(mc, {alpha:a, time:t});
		}		
		
		public function rubber_effect(mc:DisplayObjectContainer,scale_X:Number,scale_Y:Number,  in_t:int ,diff:Number, onComF:Function):void
		{
			utilFun.Log(" scale_X+dif ="+  (scale_X+diff));
			if ( scale_X+diff == 1) return;
			Tweener.addTween(mc, { scaleX: scale_X+diff,scaleY:scale_Y+diff, time:in_t, onCompleteParams:[mc,1- (diff/2),1-(diff/2),0.5, (diff/2),null],onComplete:onComF } );
		}
		
		public function Twinkle_by_JumpFrame(mc:MovieClip, t:int, cnt:int,startframe:int,Jumpframe:int):void
		{
			Tweener.addCaller(mc, { time:t , count: cnt , transition:"linear", onUpdateParams:[mc,startframe,Jumpframe], onUpdate: this.JumpFrame } );
		}
		
		public function Twinkle_by_loopFrame(mc:MovieClip, t:int, cnt:int,frameNum:int):void
		{
			Tweener.addCaller(mc, { time:t , count: cnt , transition:"linear", onUpdateParams:[mc,frameNum], onUpdate: this.loopFrame } );
		}
		
		private function JumpFrame(mc:MovieClip,startframe:int,Jumpframe:int):void
		{			
			mc.gotoAndStop( utilFun.jumpFrame(mc.currentFrame,startframe, Jumpframe) )	
			
		}	
		
		private function loopFrame(mc:MovieClip,frameNum:int):void
		{			
			mc.gotoAndStop( utilFun.cycleFrame(mc.currentFrame,frameNum) )	
		}	
		
		public function strdotloop(s:TextField,Mytime:int ,Mycount:int):void
		{
			Tweener.addCaller( s.text, { time:Mytime , count: Mycount , transition:"linear", onUpdateParams:[ s,s.length,4], onUpdate: this.dotloop } );
		}		
		
		public function dotloop(s:TextField, orlength:int, limit:int):void
		{
			var str:String = s.text;
			var len:int = str.length;
			str = str.substr(0, len) + ".";
			if ( str.length > orlength + limit) str = str.substr(0, len - limit) + ".";			
			s.text = str;
		}
		
		//_regular.Call(Get("aa").container, { onUpdate:this.test_ok,onUpdateParams:[Get("aa").container] }, 1, 0, 5, "linear");
		//_regular.Call(Get("aa").container, { onComplete:this.test_ok,onCompleteParams:[Get("aa").container] }, 1, 0, 1, "linear");
		public function Call(mc:Object,pa:Object , t:int,de:int =0,cnt:int = 1,transition_p:String = "linear"):void
		{
			var tweenOb:Object  = { time:t,
													  count:cnt,
													  delay:de,
													  transition:transition_p
													};
										 
			if ( pa["onComplete"] != undefined) 
			{
				tweenOb["onComplete"] = pa["onComplete"];
				if (  pa["onCompleteParams"] != undefined) tweenOb["onCompleteParams"] = pa["onCompleteParams"];				
			}
			
			if ( pa["onUpdate"] != undefined) 
			{
				tweenOb["onUpdate"] = pa["onUpdate"];
				if (  pa["onUpdateParams"] != undefined) tweenOb["onUpdateParams"] = pa["onUpdateParams"];				
			}
			
			Tweener.addCaller(mc, tweenOb  );
		}
		
		public function Posi_Colum_first_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			var ColumnCnt:int = data[0];
			var xdiff:Number = data[1];
			var ydiff:Number = data[2];
			mc.x = ( Math.floor(idx / ColumnCnt) * data[1]);		
			mc.y = (idx % ColumnCnt * ydiff);
		}
		
		public function Posi_Row_first_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			var RowCnt:int = data[0];
			var xdiff:Number = data[1];
			var ydiff:Number = data[2];
			mc.x = (idx % RowCnt * xdiff);			
			mc.y = Math.floor(idx / RowCnt) * ydiff;		
		}
		
	}

}