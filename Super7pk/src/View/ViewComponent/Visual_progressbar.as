package View.ViewComponent 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_progressbar  extends VisualHandler
	{	
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		private const bg:int = 0;
		private const style:int = 1;		
		private const percent:int = 2;
		private const effect:int = 3;
		private const tag:int = 4;
		
		//res
		public const progress_bar:String = "bar_bg";
		public const bar_continue:String = "power_bar_continue";
		public const contractpower:String = "progress_effect";
		public const progress_bartag:String = "progress_bar_tag";
		public const progressnum:String = "progress_num";
		
		//TODO move to bigwin effect
		public const PowerJP:String = "Power_JP";
		public const PowerJP_Num:String = "Power_JP_Num";
		
		private const progress_lenth:int = -211;
		
		public function Visual_progressbar() 
		{
			
		}
		
		public function init():void
		{			
			var powerbar_0:MultiObject = create("powerbar_0",  [progress_bar,bar_continue,progressnum,contractpower,progress_bartag]);
			powerbar_0.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			powerbar_0.Post_CustomizedData = [[0, 0], [8.3,7], [289.4, 7.5], [-38.95, -19],[-90, 0]];
			powerbar_0.container.x = 887;
			powerbar_0.container.y = 180;
			powerbar_0.Create_(5, "powerbar_0");		
			GetSingleItem("powerbar_0",bg).gotoAndStop(3);			
			GetSingleItem("powerbar_0",style)["_colorbar"].gotoAndStop(3);
			GetSingleItem("powerbar_0", tag).gotoAndStop(1);
			
			object_init("powerbar_0",percent);		
			
			//add more same kind of item
			
			//TODO mo to bigwin message
			var PowerJP:MultiObject = create("Power_JP",  [PowerJP]);
			PowerJP.container.x = 969;
			PowerJP.container.y = 433;			
			PowerJP.Create_(1, "Power_JP");
			PowerJP.container.visible = false;
			
			var PowerJPNum:MultiObject = create("Power_JP_num",  [PowerJP_Num], Get("Power_JP").container);
			
			put_to_lsit(powerbar_0);			
		}		
		
		//mode -> (contorl ?)->view 
		public function progress(zero_position:Number,full_position:Number,To_percent:Number):Number
		{
			//model
			var dis:Number = Math.abs(full_position - zero_position);
			var move_dis:Number =  zero_position + dis * (To_percent / 100);
			
			return move_dis;
		}
		
		public function no_effect(mc:DisplayObjectContainer,  move_dis:Number):void
		{
			mc.x = move_dis;
		}
		
		//view
		public function effect_in_tail(mc:DisplayObjectContainer,effect:DisplayObjectContainer,move_dis:Number,rasingtime:int,kind:int):void
		{			
			Tweener.addTween(mc, { x:move_dis, time:rasingtime, onUpdate:this.update, onUpdateParams:[mc,effect],onComplete:this.progress_finish, onCompleteParams:[kind] } );			
		}	
		
		public function update(mc:DisplayObjectContainer,effect:DisplayObjectContainer):void
		{
			effect.x = mc.x+320 -60;
			effect.y = mc.y -20;
		}
		
		public function progress_finish(kind:int):void
		{			
			var arr:Array = _model.getValue("power_idx");
			var idx:int  = arr[kind];
			
			if ( idx != 5)
			{
				//dispatcher(new Intobject(1, "settle_step"));	
				//utilFun.SetTime(triger, 2);
				return ;
			}
			
			
			bigwin_show(kind);
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="power_up")]
		public function check_effect(type:Intobject):void
		{
			//model temp
			var arr:Array = _model.getValue("power_idx");			
			var kind:int = type.Value;			
			
			
			//get model
			var idx:int  = arr[kind];
			var move_dis:Number = progress( progress_lenth, 0, (idx+1)*20);
			arr[kind] += 1;			
			
			//data set			
			//GetSingleItem("powerbar_" + kind, effect).gotoAndPlay(2);		
			//gotoAndPlay
			//gotoAndStop
			
			var acumu:Array = _model.getValue("power_jp");
			//utilFun.Log("acu_jp = " + acumu[kind]);
			//TODO Dock type
			data_setting("powerbar_" + kind,percent,)
			if ( Get("powerbar_0").resList[percent] == ResName.TextInfo)
			{
				GetSingleItem("powerbar_" + kind, percent).getChildByName("Dy_Text").text =  acumu[kind];
			}
			
			GetSingleItem("powerbar_0",tag).gotoAndStop(utilFun.Random(10));
			
			//effect 
			no_effect(GetSingleItem("powerbar_" + kind, style)["_colorbar"], move_dis);
			effect_in_tail(GetSingleItem("powerbar_"+kind, style)["_colorbar"],GetSingleItem("powerbar_" + kind, effect), move_dis, 2, kind);
			
			
			
		}
		
		data_setting
		
		object_init
		
		//dock type handle
		public function object_init(obname:String,resTag:String):void
		{
			if ( Get(obname).resList[resTag] == ResName.TextInfo)
			{
				_text.textSetting_s(GetSingleItem(obname, percent), [ { size:22, align:_text.align_left } , ""]);
			}
			else if (Get(obname).resList[resTag]== progressnum)
			{
				
			}
		}
		
		public function data_setting(obname:String, resTag:String):void
		{
			if ( Get(obname).resList[resTag] == ResName.TextInfo)
			{
				GetSingleItem(obname, resTag).getChildByName("Dy_Text").text =  acumu[kind];
			}
			else if (Get(obname).resList[resTag]== progressnum)
			{
				
			}
		}
		
		private function triger():void
		{
			dispatcher(new StringObject("sound_Powerup_poker","sound" ) );
		}
		
		private function bigwin_show(kind:int):void
		{
			Get("Power_JP").container.visible = true;
			var acumu:Array = _model.getValue("power_jp");
			var s:String = acumu[kind].toString();
			var arr:Array = utilFun.frameAdj(s.split(""));					
			
			
			
			var PowerJPNum:MultiObject = Get("Power_JP_num");
			PowerJPNum.container.x = -30 + ((-57 /2) * (arr.length-1));
			PowerJPNum.container.y = 110;		
			PowerJPNum.CustomizedData = arr;
			PowerJPNum.CustomizedFun = _regular.FrameSetting;
			PowerJPNum.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			PowerJPNum.Post_CustomizedData = [arr.length, 57, 10];
			PowerJPNum.Create_(arr.length, "Power_JP_num");					
			_regular.Call(this, { onComplete:this.showok,onCompleteParams:[kind] }, 4, 1, 1, "linear");
			dispatcher(new StringObject("sound_bigPoker", "sound" ) );
			
		}
		
		
		private function showok(kind:int):void
		{
			var arr:Array = _model.getValue("power_idx");	
			arr[kind] = 0;
			_model.putValue("power_idx", arr);
			
			GetSingleItem("powerbar_"+kind, 1)["_colorbar"].x = progress_lenth;
			GetSingleItem("powerbar_"+kind, 2).visible = false;
			GetSingleItem("powerbar_"+kind, 3).getChildByName("Dy_Text").text = "";
			
			var acu_jp:Array  = _model.getValue("power_jp");
			acu_jp[kind] = 0;
			_model.putValue("power_jp", acu_jp );
			//utilFun.Log("acu_jp = " + _model.getValue("power_jp"));
			
			//TODO move
			Get("Power_JP").container.visible = false;
			var PowerJPNum:MultiObject = Get("Power_JP_num");
			PowerJPNum.CleanList();
			
			dispatcher(new Intobject(1, "settle_step"));	
		}
		
	}

}