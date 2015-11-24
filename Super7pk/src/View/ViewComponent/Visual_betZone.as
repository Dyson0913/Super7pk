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
		
		public const bet_tableitem:String = "bet_table_item";
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			
			var tableitem:MultiObject = create(bet_tableitem, [bet_tableitem]);	
			tableitem.container.x = 3;
			tableitem.container.y = 605;
			tableitem.Create_(1, bet_tableitem);
			
			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			//下注區
			var pz:MultiObject = create("betzone", avaliblezone);
			pz.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			pz.container.x = tableitem.container.x;
			pz.container.y = tableitem.container.y;
			pz.Create_(avaliblezone.length, "betzone");		
			//setFrame("betzone", 2);
			
			
			put_to_lsit(tableitem);
			put_to_lsit(pz);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{			
			
			
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = _betCommand.empty_reaction;			
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
			
			
		}
		
		public function hide():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;		
			betzone.rollout = null;
			betzone.rollover = null;
			
			setFrame(bet_tableitem, 1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stop_bet")]
		public function stop_bet():void
		{
			hide();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "open_card")]
		public function open_card():void
		{
			hide();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "settle")]
		public function settle():void
		{
			hide();
		}
		
	}

}