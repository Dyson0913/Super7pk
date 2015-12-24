package ConnectModule.websocket 
{	
	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage
	import com.worlize.websocket.WebSocketErrorEvent
	import com.adobe.serialization.json.JSON	
	import Command.*;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.system.Security;
	import Model.*;	
	import util.DI;
	
	import Model.valueObject.*;
	
	import View.GameView.gameState;
	import util.utilFun;	
	import ConnectModule.websocket.Message


	
	/**
	 * socket 連線元件
	 * @author hhg4092
	 */
	public class WebSoketComponent 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _actionqueue:ActionQueue;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _opration:DataOperation;
		
		private var websocket:WebSocket;
		
		public function WebSoketComponent() 
		{
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="connect")]
		public function Connect():void
		{
			//var object:Object = _model.getValue(modelName.LOGIN_INFO);						
			var uuid:String = _model.getValue(modelName.UUID);
			utilFun.Log("uuid =" + uuid);
			websocket = new WebSocket("ws://" + _model.getValue(modelName.Domain_Name) +":8401/gamesocket/token/" + uuid, "");
			websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocket);
			websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocket);
			websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
			websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			websocket.connect();
		}
		
		private function handleWebSocket(event:WebSocketEvent):void 
		{			
			if ( event.type == WebSocketEvent.OPEN)
			{
				utilFun.Log("Connected open="+ event.type );
			}
			else if ( event.type == WebSocketEvent.CLOSED)
			{
				utilFun.Log("Connected  DK close="+ event.type );
			}
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void 
		{
			utilFun.Log("Connected= fale"+ event.type);
		}
		
		
		private function handleWebSocketMessage(event:WebSocketEvent):void 
		{
			var result:Object ;
			if (event.message.type === WebSocketMessage.TYPE_UTF8) 
			{
				utilFun.Log("before"+event.message.utf8Data)
				result = JSON.decode(event.message.utf8Data);			
			}
			
			_MsgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{
			   var result:Object  = _MsgModel.getMsg();
			   
			    if ( result.game_type != _model.getValue(modelName.Game_Name) ) return;				
				
				switch(result.message_type)
				{
					case Message.MSG_TYPE_INTO_GAME:
					{
						dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.NEW_ROUND)
						{
							dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.START_BET)
						{
						    dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );	
						
						if ( result.update_odds) 
						{
							var small_to_big:Array = [];								
							small_to_big.push.apply(small_to_big, result.update_odds);						
							small_to_big.splice(2, 1);
							small_to_big.splice(6 - 1, 1);
							dispatcher(new ValueObject(  small_to_big, "round_paytable") );						
						}
						
						var poke1:Array = [];
						var poke2:Array = [];
						var po:Array = result.cards_info["extra_card_list"];
						poke1.push.apply(poke1,po );
						poke2.push.apply(poke2, po);
						var ri:Array =  result.cards_info["river_card_list"];
						if ( ri.length != 0)
						{
							poke1.push.apply(poke1, ri);
							poke2.push.apply(poke2, ri);
						}
						//_model.putValue(modelName.POKER_1, poke1);
						//_model.putValue(modelName.POKER_2, poke2);
							
						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						dispatcher(new ValueObject(  result.game_id, "game_id") );
						
						dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );								
						
						dispatcher(new ModelEvent("update_state"));
						
						dispatcher( new ValueObject(poke1, modelName.POKER_1) );
						dispatcher( new ValueObject(poke2, modelName.POKER_2) );					
						dispatcher(new Intobject(modelName.POKER_1, "poker_No_mi"));
						dispatcher(new Intobject(modelName.POKER_2, "poker_No_mi"));
						
					}
					break;
					
					case Message.MSG_TYPE_GAME_OPEN_INFO:
					{
						var card:Array = result.card_list;
						var card_type:String = result.card_type;
						var mypoker:Array =[];
						var mypoker2:Array = [];
						
						//handle pre 5 poker
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.NEW_ROUND)
						{																						
							if ( result.update_odds)
							{
								var smallto_big:Array = [];								
								smallto_big.push.apply(smallto_big, result.update_odds);
								smallto_big.splice(2, 1);
								smallto_big.splice(6 - 1, 1);
								dispatcher(new ValueObject(  smallto_big, "round_paytable") );
							}
						}
											
						mypoker = _model.getValue(modelName.POKER_1);
						mypoker2 = _model.getValue(modelName.POKER_2);
						mypoker.push(card[0]);
						mypoker2.push(card[0]);
						_model.putValue(modelName.POKER_1, mypoker);
						_model.putValue(modelName.POKER_2, mypoker2);
						dispatcher(new Intobject(modelName.POKER_1, "poker_mi"));
						dispatcher(new Intobject(modelName.POKER_2, "poker_mi"));
						
						//last 2 poker (open card become just handle half in)
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.END_BET)
						{
							dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
							dispatcher(new ModelEvent("update_state"));
						}
					}
					break;
					
					case Message.MSG_TYPE_STATE_INFO:
					{						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.NEW_ROUND)
						{
						    dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						if ( _opration.getMappingValue("state_mapping", result.game_state) == gameState.START_BET)
						{
							dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );
						}
						
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
						dispatcher(new ModelEvent("update_state"));
					}
					break;
					
					case Message.MSG_TYPE_BET_INFO:
					{
						
						if (result.result == 0)
						{
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));							
							dispatcher(new ModelEvent("updateCoin"));
						}
						else
						{						
							_actionqueue.dropMsg();
							//error handle
						}
					}	
					break;
					
					case Message.MSG_TYPE_ROUND_INFO:
					{
						//update state
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );						
						dispatcher(new ModelEvent("update_state"));
						
						//model update						
						dispatcher( new ValueObject(result.card_showhand_comb, modelName.FINAL_CARD));
						dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
						dispatcher(new ModelEvent("round_result"));		
					}
					break;
					
				}
				
				dispatcher(new ArrayObject([result], "pack_recoder"));
				
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet")]
		public function SendBet():void
		{			
			var ob:Object = _actionqueue.getMsg();
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");					
			
			
			var bet:Object = {  "id": String(_model.getValue(modelName.UUID)),
			                                "timestamp":1111,
											"message_type":"MsgPlayerBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":_model.getValue(modelName.Game_Name),
										   "game_round":_model.getValue("game_round"),
										   "bet_type": idx_to_name.getValue( ob["betType"]),
										    "bet_amount":ob["bet_amount"],
											"total_bet_amount":ob["total_bet_amount"]
											};
											
			SendMsg(bet);
		}
		
		public function SendMsg(msg:Object):void 
		{
			dispatcher(new ArrayObject([msg], "pack_recoder"));
			var jsonString:String = JSON.encode(msg);
			utilFun.Log("jsonString ="+jsonString );			
			websocket.sendUTF(jsonString);
		}
		
	}
}