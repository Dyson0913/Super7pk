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
		
		[Inject]
		public var _betCommand:BetCommand;
		
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
				utilFun.Log("Connected  7pk close=" + event.type );
				if (_model.getValue("lobby_disconnect") ==  false) {
					//通知大廳遊戲斷線
					var lobbyevent:Function =  _model.getValue(modelName.HandShake_chanel);			
					if ( lobbyevent != null)
					{
						lobbyevent(_model.getValue(modelName.Client_ID), ["GameDisconnect"]);			
					}		
				}
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "package_from_lobby")]
		public function package_from():void
		{			
			var result:Object = _model.getValue("package_from_lobby");		
			_MsgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{
			   var result:Object  = _MsgModel.getMsg();
			   
			    if ( result.game_type != _model.getValue(modelName.Game_Name) ) return;				
				
				dispatcher(new ArrayObject([result], "pack_recoder"));
				
				switch(result.message_type)
				{
					case Message.MSG_TYPE_INTO_GAME:
					{
						dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );
						//credit update in loading
						var state:int = _opration.getMappingValue("state_mapping", result.game_state)
						if ( state == gameState.NEW_ROUND || state == gameState.START_BET)
						{
						    dispatcher(new ValueObject(  result.record_list, "history_list") );
						}
						
						dispatcher(new ValueObject(  state , modelName.GAMES_STATE) );
						
						var bet_type:Array  = [];
						var bet_amount:Array = [];
						for (var id:String in result.bet_list)
                       {
							var value:int = result.bet_list[id];
							bet_type.push(id);
							bet_amount.push(value);
                       }
					   
						_model.putValue("half_in_bet_type", bet_type);
						_model.putValue("half_in_bet_amount", bet_amount);
						
						
						if ( result.update_odds) 
						{
							var small_to_big:Array = [];								
							small_to_big.push.apply(small_to_big, result.update_odds);						
							small_to_big.splice(2, 1);
							small_to_big.splice(6 - 1, 1);
							dispatcher(new ValueObject(  small_to_big, "round_paytable") );
							_betCommand.handle_odd(_model.getValue("round_paytable"));
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
						
						 state = _opration.getMappingValue("state_mapping", result.game_state);
						if ( state == gameState.NEW_ROUND)   dispatcher(new ValueObject(  result.record_list, "history_list") );						
						if ( state == gameState.START_BET) 
						{
							if ( state == gameState.START_BET)
							{																						
								if ( result.update_odds)
								{
									var smallto_big:Array = [];								
									smallto_big.push.apply(smallto_big, result.update_odds);
									smallto_big.splice(2, 1);
									smallto_big.splice(6 - 1, 1);
									dispatcher(new ValueObject(  smallto_big, "round_paytable") );
									_betCommand.handle_odd(_model.getValue("round_paytable"));
								}							
							}
							dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );					
						}
						
						dispatcher(new ValueObject(  state , modelName.GAMES_STATE) );
						dispatcher(new ModelEvent("update_state"));
					}
					break;
					
					case Message.MSG_TYPE_BET_INFO:
					{
						
						if (result.result == 0)
						{
							//credit 更新回大廳							
							utilFun.Log("super7pk  bet ok = " + result.player_update_credit);
							_model.putValue(modelName.CREDIT, result.player_update_credit);
							send_credit_to_lobby(result.player_update_credit);
						}
						else
						{						
							//下注失敗處理
							_betCommand.cleanBetUUID(result.id);
						}
						
					}	
					break;
					
					case Message.MSG_TYPE_ROUND_INFO:
					{
						//update state
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );						
						dispatcher(new ModelEvent("update_state"));
						
						//credit 更新回大廳							
						utilFun.Log("super7pk  bet ok = " + result.player_update_credit);
						_model.putValue(modelName.CREDIT, result.player_update_credit);
						send_credit_to_lobby(result.player_update_credit);
						
						//model update						
						dispatcher( new ValueObject(result.card_showhand_comb, modelName.FINAL_CARD));
						dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
						dispatcher(new ModelEvent("round_result"));		
					}
					break;
					
				}
				
		}
		
		public function send_to_lobby(msg:Object):void 
		{
			var lobbyevent:Function =  _model.getValue(modelName.HandShake_chanel);			
			if ( lobbyevent != null)
			{
				lobbyevent(_model.getValue(modelName.Client_ID), ["game_credit_update",msg]);			
			}		
		}
		
		public function send_credit_to_lobby(new_credit:Number):void 
		{
			var lobbyevent:Function =  _model.getValue(modelName.HandShake_chanel);			
			if ( lobbyevent != null)
			{
				lobbyevent(_model.getValue(modelName.Client_ID), ["HandShake_updateCredit",new_credit,_model.getValue(modelName.Game_Name)]);			
			}		
			
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