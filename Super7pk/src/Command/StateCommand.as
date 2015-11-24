package Command 
{
	import flash.events.Event;
	import Model.*;
	
	import util.*;
	import View.GameView.*;
	/**
	 * state event
	 * @author hhg4092
	 */
	public class StateCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		
		public function StateCommand() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_state")]
		public function state_update():void
		{
			var state:int = _model.getValue(modelName.GAMES_STATE);			
			if ( state  == gameState.PRE_OPEN) dispatcher(new ModelEvent("pre_open"));
			if ( state  == gameState.NEW_ROUND)
			{				
				dispatcher(new ModelEvent("clearn"));
				//dispatcher(new ModelEvent("display"));			
				dispatcher(new ModelEvent("start_bet"));			
			}
			else if ( state == gameState.END_BET) dispatcher(new ModelEvent("stop_bet"));
			else if ( state == gameState.START_OPEN) dispatcher(new ModelEvent("open_card"));
			else if ( state == gameState.END_ROUND)  dispatcher(new ModelEvent("settle"));
		}
	}

}