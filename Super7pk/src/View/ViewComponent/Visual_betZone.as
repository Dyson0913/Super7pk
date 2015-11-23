package View.ViewComponent 
{
	import flash.events.Event;
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
	public class Visual_betZone  extends VisualHandler
	{	
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			
			var tableitem:MultiObject = create("tableitem", [ResName.bet_tableitem]);	
			tableitem.container.x = 193;
			tableitem.container.y = 655;
			tableitem.Create_(1, "tableitem");
			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);						
			
			//下注區
			var pz:MultiObject = create("betzone", avaliblezone);
			pz.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			pz.container.x = 457;
			pz.container.y = 662;
			pz.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			pz.Post_CustomizedData = zone_xy;
			pz.Create_(avaliblezone.length, "betzone");
			
			var highpayrate:MultiObject = create("highpayrate", [ResName.highpayrate]);	
			highpayrate.Create_(1, "highpayrate");
			
			put_to_lsit(pz);
			put_to_lsit(tableitem);
			put_to_lsit(highpayrate);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = _betCommand.empty_reaction;			
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
			
			Get("tableitem").container.visible = true;
			GetSingleItem("highpayrate").gotoAndStop(1);
			Get("highpayrate").container.x = 783;
			Get("highpayrate").container.y = 575;
			
			pull();
			
			_regular.Twinkle_by_JumpFrame(GetSingleItem("betzone", 5), 25, 25, 1, 3);
			
			
		}
		
		public function pull():void
		{
			_regular.moveTo(Get("highpayrate").container, Get("highpayrate").container.x, Get("highpayrate").container.y - 10, 1, 0, pull_up);
		}
		
		public function pull_up():void
		{
			_regular.moveTo(Get("highpayrate").container, Get("highpayrate").container.x, Get("highpayrate").container.y + 10, 1, 0, pull);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;				
			
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
			
			var frame:Array = [];
			for ( var i:int = 0; i  <  betzone.ItemList.length; i++) frame.push(1);
			betzone.CustomizedFun = _regular.FrameSetting;
			betzone.CustomizedData = frame;
			betzone.FlushObject();
			
			Get("tableitem").container.visible = false;
			
						
			Tweener.pauseTweens(GetSingleItem("betzone",5));
			
			GetSingleItem("highpayrate").gotoAndStop(2);
			
			Tweener.pauseTweens(Get("highpayrate"));		
			
		}
		
		
	}

}