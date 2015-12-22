package View.Viewutil 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Timer;
	import Interface.ViewComponentInterface;
	import View.Viewutil.AdjustTool;
	
	import View.ViewBase.*;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	
	/**
	 * replay package present way
	 * @author Dyson0913
	 */
	public class Visual_package_replayer extends VisualHandler
	{
		[Inject]
		public var _MsgModel:MsgQueue;
		
		private var _packList:Array = [];
		
		
		
		public function Visual_package_replayer() 
		{
			
		}
		
		public function init():void
		{
			var sim_pack:MultiObject = create("sim_pack", [ResName.TextInfo]);	
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="replay_config_complete")]		
		public function lsit(replayinfo:ArrayObject):void
		{	
			//確認為自己要求的mission
				//utilFun.Log("replayinfo.Value[0]"+replayinfo.Value[0]);
				//utilFun.Log("mission_id()"+mission_id());
			if ( replayinfo.Value[0] != mission_id()) return;
				
			
			utilFun.Log("parse");
			var jsonob:Object =  replayinfo.Value[1];
			var packinfo:Array = jsonob.packlist;
			var packName:Array = [];
			_packList = packinfo;
			for (var i:int = 0; i < packinfo.length ; i++)
			{
				utilFun.Log("my pack = " + packinfo[i]);				
				packName.push(packinfo[i].message_type);
				
			}
			utilFun.Log("my packName = " + packName);
			var sim_pack:MultiObject = Get("sim_pack");
			sim_pack.container.x = 100;
			sim_pack.container.y = 100;
			sim_pack.CustomizedFun = _text.textSetting;
			var ob:Array = [ { size:18, color:0xFF0000 } ];				
			ob = ob.concat(packName);
			sim_pack.CustomizedData = ob;
			sim_pack.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			sim_pack.mousedown = pack;
			sim_pack.Post_CustomizedData = [packName.length, 10, 32];
			sim_pack.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			sim_pack.Create_(packName.length);
			//
			//put_to_lsit(sim_pack);
		}
		
		public function pack(e:Event, idx:int):Boolean
		{			
			_MsgModel.push(_packList[idx]);	
			return true;
		}
		
		
	}

}