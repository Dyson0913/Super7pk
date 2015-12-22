package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * bigwin effect
	 * @author ...
	 */
	public class Visual_Bigwin_Effect  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		//res name
		public const Bigwinmsg:String = "big_win_msg";		
		public const bigwinfire:String = "sun_effect";
		
		public const bigwin_num:String = "big_win_num";
		
		//sound name
		public const sound_bigwin:String = "sound_bigPoker";
		public const sound_getpoint:String = "sound_get_point";
		public const soundBomb:String = "soundBomb";
		public const soundBombLong:String = "sound_BombLong";		
		
		public var _playing:Boolean;
		
		public var _phase:Array = [];
		
		public function Visual_Bigwin_Effect() 
		{
			
		}
		
		public function init():void
		{	
			//金幣泉
			var bigwinfire:MultiObject = create("bigwinfire", [bigwinfire]);
			bigwinfire.Create_(1);
			bigwinfire.container.x = 550;
			bigwinfire.container.y = 50;
			setFrame("bigwinfire", 1);
			
			//大獎字樣集
			var bigwinCon:MultiObject = create("bigwinmsg",  [Bigwinmsg]);
			bigwinCon.Create_(1);
			bigwinCon.container.x = 981;
			bigwinCon.container.y = 420;
			setFrame("bigwinmsg", 1);
			
			//數字表現
			var PowerJPNum:MultiObject = create("bigwin_JP_num",  [bigwin_num], bigwinCon.container);						
			setFrame("bigwin_JP_num", 12);
			
			_playing = false;
			
			put_to_lsit(bigwinfire);
			put_to_lsit(bigwinCon);
			put_to_lsit(PowerJPNum);
			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "new_round")]
		public function pre_open():void
		{
			hide();
		}
		
		public function hide():void
		{
			_playing = false;
			setFrame("bigwinmsg", 1);
			setFrame("bigwinfire", 1);
			setFrame("bigwin_JP_num", 12);
		}
		
		public function stop():void
		{
			_playing = false;
			setFrame("bigwinmsg", 1);
			setFrame("bigwinfire", 1);
			Get("bigwin_JP_num").CleanList();
			
			Tweener.pauseTweens(Get("bigwinmsg").container);
			Tweener.pauseTweens(this);
			
			pause_sound(sound_getpoint);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle_bigwin")]
		public function hitbigwin():void
		{
			var bigwin_frame:int = _model.getValue("bigwin");			
			Log("bigwin =" + bigwin_frame);
			if ( bigwin_frame > 9)
			{
				dispatcher(new Intobject(1, "settle_step"));
				return;
			}
			_playing = true;
			
			//phase start
			win_word(bigwin_frame);
			
		}
		
		public function win_word(bigwin_frame:int):void
		{
			//phase i  ( sound ,data set ,play)
			play_sound(sound_bigwin);			
			GetSingleItem("bigwinmsg").gotoAndStop(bigwin_frame);
			
			_model.putValue("Hit_count", 0);
			
			play_sound(soundBombLong);
			//odd_present();
			background_effect();
			_cunt();
			
			//重擊特效
			//pop_effect(1,0.5);			
		}
		
		public function pop_effect(start:Number ,end:Number):void
		{			
			_model.putValue("Hit_count", _model.getValue("Hit_count")+1);
			utilFun.scaleXY(Get("bigwinmsg").container,start, start);
			Get("bigwinmsg").container.alpha = 0;
			Tweener.addTween(Get("bigwinmsg").container, { time:0.3, scaleX: end, scaleY:end, alpha: 1, transition:"easeInQuart", onComplete:this.hit, onCompleteParams:[start+1,end+0.5]  } );		
		}
		
		public function hit(start:int ,end:int):void
		{
			//動畫次數
			if ( _model.getValue("Hit_count") == 3) 
			{
				play_sound(soundBombLong);
				odd_present();
				background_effect();
				Tweener.addTween(this, {delay:2, transition:"linear",onComplete:this.ready_to_cunt } );
			}
			else 
			{
				play_sound(soundBomb);			
				Tweener.addTween(this, {delay:0.1, transition:"linear",onComplete:this.pop_effect, onCompleteParams:[start,end] } );
			}
		}
		
		public function odd_present():void
		{
			var s:String = "x" + (_model.getValue("win_odd") -1);
			var arr:Array = utilFun.frameAdj(s.split(""));
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 200;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length);
		}
		
		public function ready_to_cunt():void
		{
			Tweener.addTween(this, {delay:1, transition:"linear",onComplete:this._cunt } );
		}
		
		public function settlt_FrameSetting(mc:MovieClip, idx:int, data:Array):void
		{			
			if ( data[idx] == "x")  data[idx] = 13;
			mc.gotoAndStop(data[idx]);
		}
		
		public function _cunt():void
		{
			GetSingleItem("bigwinfire").gotoAndPlay(2);
			dispatcher(new Intobject(1, "settle_step"));
				
			return;
			
			//跑表
			_model.putValue("TotalJP_amoount", _model.getValue("result_total"));			
			var s:String = _model.getValue("TotalJP_amoount");
			var arr:Array = utilFun.frameAdj(s.split(""));
			//utilFun.Log("arr = "+arr);
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");
			PowerJPNum.CleanList();
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 200;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length);	
			background_effect();
			
			//停留N秒
			Tweener.addTween(this, {delay:1, transition:"linear",onComplete:this.num_count } );
		}
		
		public function background_effect():void
		{
			GetSingleItem("bigwinfire").gotoAndPlay(2);
		}
		
		public function num_count():void
		{			
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");			
			PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndPlay(11);			
			
			//N秒內跑完表
			Tweener.addCaller(this, { time:3 , count: PowerJPNum.ItemList.length - 1 , transition:"easeInQuad", onUpdateParams:[10], onUpdate: this.add_carray } );
			loop_sound(sound_getpoint);
		}
		
		public function add_carray(amount:int):void
		{
			var total:Number = _model.getValue("TotalJP_amoount");			
			total -= amount;		
			total /= amount;			
			_model.putValue("TotalJP_amoount", total);			
			
			var toIn:int = total;
			var arr:Array = utilFun.frameAdj(toIn.toString().split(""));							
				
			var PowerJPNum:MultiObject = Get("bigwin_JP_num");	
			PowerJPNum.CleanList();
			PowerJPNum.container.x = -45 + (( -91 / 2) * (arr.length - 1));
			PowerJPNum.container.y = 200;
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = settlt_FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 91, 0];
			PowerJPNum.Create_(arr.length);	
			PowerJPNum.ItemList[PowerJPNum.ItemList.length-1].gotoAndPlay(11);			
			
			
			if ( toIn <= 0) 
			{
				utilFun.Log("add carry over");				
				dispatcher(new Intobject(1, "settle_step"));
				PowerJPNum.ItemList[PowerJPNum.ItemList.length - 1].gotoAndStop(10);				
				pause_sound(sound_getpoint);
				utilFun.SetTime(hide, 2);		
				return;
			}
		}
		
	}

}