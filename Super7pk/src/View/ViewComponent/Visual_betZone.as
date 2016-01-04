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
		public const bet_tableitem:String = "bet_table_item";
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{
			
			var tableitem:MultiObject = create(bet_tableitem, [bet_tableitem]);	
			tableitem.container.x = 3;
			tableitem.container.y = 605;
			tableitem.Create_(1);			
			
			put_to_lsit(tableitem);
			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			//下注區
			var pz:MultiObject = create("betzone", avaliblezone);
			pz.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [1, 2, 2, 0]);			
			pz.container.x = tableitem.container.x;
			pz.container.y = tableitem.container.y;
			pz.Create_(avaliblezone.length);
			
			disappear();
			
			put_to_lsit(pz);
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
		
		override  public function appear():void
		{
			setFrame(bet_tableitem, 2);
			
			var betzone:MultiObject = Get("betzone");			
			betzone.mousedown = empty_reaction;	
			betzone.rollout = empty_reaction;
			betzone.rollover = empty_reaction;
		}
		
		override public function disappear():void
		{
			setFrame(bet_tableitem, 1);
			
			var betzone:MultiObject = Get("betzone");			
			betzone.mousedown = null;	
			betzone.rollout = null;
			betzone.rollover = null;
			
			setFrame("betzone", 1);
		}
		
	}

}