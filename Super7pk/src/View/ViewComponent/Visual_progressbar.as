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
		
		public const powerbar:String = "power_bar";
		
		public const bar_continue:String = "power_bar_continue";
		public const powerbar_name:String = "power_bar_name";
		public const powerbar_tail:String = "power_bar_tail";
		
	
		
		public function Visual_progressbar() 
		{
			
		}
		
		public function init():void
		{
			//two_pair
			var powerbar_0:MultiObject = create("powerbar_0",  [powerbar,bar_continue, powerbar_tail,ResName.TextInfo,ResName.contractpower]);
			powerbar_0.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			powerbar_0.Post_CustomizedData = [[0, 0], [12.35,4], [8.4, 3.5], [315.35, -1],[-60, -20]];
			powerbar_0.container.x = 1302;
			powerbar_0.container.y = 430;
			powerbar_0.Create_(5, "powerbar_0");
			powerbar_0.ItemList[0]["bg"].gotoAndStop(2);
			powerbar_0.ItemList[1]["_colorbar"].gotoAndStop(2);
			powerbar_0.ItemList[2].gotoAndStop(2);
			powerbar_0.ItemList[2].visible = false;
			_text.textSetting_s(powerbar_0.ItemList[3], [ { size:22, align:_text.align_left } , ""]);
			
			//3條
			var powerbar_1:MultiObject = create("powerbar_1",  [powerbar,bar_continue, powerbar_tail,ResName.TextInfo,ResName.contractpower]);
			powerbar_1.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			powerbar_1.Post_CustomizedData = [[0, 0], [12.35,4], [8.4, 3.5], [315.35, -1],[-60,-20]];
			powerbar_1.container.x = 1302;
			powerbar_1.container.y = 390;
			powerbar_1.Create_(5, "powerbar_1");
			powerbar_1.ItemList[0]["bg"].gotoAndStop(1);
			powerbar_1.ItemList[1]["_colorbar"].gotoAndStop(1);
			powerbar_1.ItemList[2].gotoAndStop(1);
			powerbar_1.ItemList[2].visible = false;
			_text.textSetting_s(powerbar_1.ItemList[3], [ { size:22, align:_text.align_left } , ""]);
			
			var PowerJP:MultiObject = create("Power_JP",  [ResName.PowerJP]);
			PowerJP.container.x = 969;
			PowerJP.container.y = 433;			
			PowerJP.Create_(1, "Power_JP");
			PowerJP.container.visible = false;
			
			var PowerJPNum:MultiObject = create("Power_JP_num",  [ResName.PowerJP_Num], Get("Power_JP").container);
			
			put_to_lsit(powerbar_0);
			put_to_lsit(powerbar_1);		
			
			//_tool.SetControlMc(powerbar_0.ItemList[4]);
			//add(_tool);
		}		
		
		//mode -> (contorl ?)->view 
		public function progress(zero_position:Number,full_position:Number,To_percent:Number):Number
		{
			//model
			var dis:Number = Math.abs(full_position - zero_position);
			var move_dis:Number =  zero_position + dis * (To_percent / 100);
			
			return move_dis;
		}
		
		//view
		public function progress_effect(mc:DisplayObjectContainer,effect:DisplayObjectContainer,move_dis:Number,rasingtime:int,kind:int):void
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
				dispatcher(new Intobject(1, "settle_step"));	
				utilFun.SetTime(triger, 2);
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
			var move_dis:Number = progress( -294, 0, (idx+1)*20);
			arr[kind] += 1;			
			
			//control
			GetSingleItem("powerbar_" + kind, 2).visible = true;			
			GetSingleItem("powerbar_" + kind, 4).gotoAndPlay(2);
			progress_effect(GetSingleItem("powerbar_"+kind, 1)["_colorbar"],GetSingleItem("powerbar_" + kind, 4), move_dis, 2, kind);
			
			var acumu:Array = _model.getValue("power_jp");			
			//utilFun.Log("acu_jp = " + acumu[kind]);
			GetSingleItem("powerbar_" + kind, 3).getChildByName("Dy_Text").text =  acumu[kind];
			
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
			
			GetSingleItem("powerbar_"+kind, 1)["_colorbar"].x = -294;
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