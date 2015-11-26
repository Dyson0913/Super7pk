package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import util.math.Path_Generator;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import com.adobe.serialization.json.JSON;
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _path:Path_Generator;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _betzone:Visual_betZone;	
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _sencer:Visual_betZone_Sence;
		
		[Inject]
		public var _coin_stack:Visual_Coin_stack;
		
		[Inject]
		public var _settle:Visual_Settle;	
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _settle_panel:Visual_SettlePanel;
		
		[Inject]
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _replayer:Visual_package_replayer;
		
		[Inject]
		public var _loader:Visual_Loder;
		
		[Inject]
		public var _progressbar:Visual_progressbar;
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		[Inject]
		public var _ProbData:Visual_ProbData;
		
		[Inject]
		public var _fileStream:fileStream;
		
		[Inject]
		public var _Bigwin_Effect:Visual_Bigwin_Effect;
		
		[Inject]
		public var _theme:Visual_theme = new Visual_theme();
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{			
			
			
			//_fileStream.switch_recode(true);
			//_fileStream.write();
			_model.putValue("test_init", false);
			
			_debug.init();
			_betCommand.bet_init();			
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);
			_model.putValue("history_list",[]);
			
			//腳本
			var script_list:MultiObject = create("script_list", [ResName.TextInfo]);	
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [ { size:18 }, "下注腳本", "開牌腳本","結算腳本","封包模擬","開公牌"];
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			script_list.Post_CustomizedData = [5, 100, 100];			
			script_list.Create_(script_list.CustomizedData.length -1, "script_list");
			
			
			
			_model.putValue("Script_idx", 0);			
		
		}				
		
		public function script_list_test(e:Event, idx:int):Boolean
		{
			utilFun.Log("script_list_test=" + idx);
			_model.putValue("Script_idx", idx);
			view_init();
			dispatcher(new TestEvent(_model.getValue("Script_idx").toString()));
			
			
			return true;
		}
		
		public function view_init():void
		{
			if ( _model.getValue("test_init")) return;
			changeBG(ResName.Bet_Scene);
			
			_theme.init();
			_gameinfo.init();			
			_hint.init();			
			_timer.init();
			_HistoryRecoder.init();
			
			_poker.init();			
				
			_betzone.init();
			_coin_stack.init();
			_coin.init();
			_sencer.init();
			_settle_panel.init();
			
			
			_paytable.init();
			_btn.init();
			_Bigwin_Effect.init();
			//_btn.debug();
			
			//_progressbar.init();
			//_ProbData.init();
			
			
			
			
			_model.putValue("test_init",true);
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{			
			_model.putValue(modelName.REMAIN_TIME, 20);
			fake_hisotry();
			
			_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);			
			dispatcher(new ModelEvent("update_state"));
			
			_model.putValue(modelName.POKER_1, ["1s", "2d", "3s", "5c", "6h"]);			
			_model.putValue(modelName.POKER_2, ["1s", "2d", "3s", "5c", "6h"]);			
			
			dispatcher(new Intobject(modelName.POKER_1, "poker_No_mi"));
			dispatcher(new Intobject(modelName.POKER_2, "poker_No_mi"));
			
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function opencardScript():void
		{						
			_model.putValue(modelName.POKER_1, ["1s", "2d", "3s", "5c", "6h"]);				
			_model.putValue(modelName.POKER_2, ["1s", "2d", "3s", "5c", "6h"]);			
			
			_model.putValue("scirpt_pai", ["3d", "6d"]);
			
			_model.putValue(modelName.GAMES_STATE,gameState.END_BET);			
			dispatcher(new ModelEvent("update_state"));
			dispatcher(new Intobject(modelName.POKER_1, "poker_No_mi"));
			dispatcher(new Intobject(modelName.POKER_2, "poker_No_mi"));
			
			_model.putValue(modelName.GAMES_STATE,gameState.START_OPEN);			
			dispatcher(new ModelEvent("update_state"));
			
			//================================================ simu deal
			var testpoker:Array = ["Player", "Player"];
			_regular.Call(this, { onUpdate:this.fackeDeal, onUpdateParams:[testpoker] }, 5, 0, 2, "linear");						
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function settleScript():void
		{						
			_model.putValue(modelName.POKER_1, ["1s", "2d", "3s", "5c", "6h","3d","6d"]);				
			_model.putValue(modelName.POKER_2, ["1s", "2d", "3s", "5c", "6h","3d","6d"]);
			
			_model.putValue(modelName.GAMES_STATE,gameState.END_ROUND);			
			dispatcher(new ModelEvent("update_state"));
			dispatcher(new Intobject(modelName.POKER_1, "poker_No_mi"));
			dispatcher(new Intobject(modelName.POKER_2, "poker_No_mi"));
			
			_model.putValue("win_odd", 2) ;
			
			//順子			
			var fakePacket:Object = {"result_list": [{"bet_attr": "BetAttrMain", "bet_amount": 100, "odds": 2, "win_state": "WSBWStraight", "real_win_amount": 100, "bet_type": "BetBWPlayer", "settle_amount": 200}, {"bet_attr": "BetAttrMain", "bet_amount": 100, "odds": 2, "win_state": "WSBWStraight", "real_win_amount": 100, "bet_type": "BetBWBanker", "settle_amount": 200}, {"bet_attr": "BetAttrSide", "bet_amount": 100, "odds": 9, "win_state": "WSWin", "real_win_amount": 800, "bet_type": "BetBWTiePoint", "settle_amount": 900}, {"bet_attr": "BetAttrSide", "bet_amount": 100, "odds": 5, "win_state": "WSBWStraight", "real_win_amount": 400, "bet_type": "BetBWSpecial", "settle_amount": 500}, {"bet_attr": "BetAttrSide", "bet_amount": 100, "odds": 0, "win_state": "WSLost", "real_win_amount": -100, "bet_type": "BetBWPlayerPair", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 100, "odds": 0, "win_state": "WSLost", "real_win_amount": -100, "bet_type": "BetBWBankerPair", "settle_amount": 0}, {"bet_attr": "BetAttrBonus", "bet_amount": 200, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTripple", "settle_amount": 0}, {"bet_attr": "BetAttrBonus", "bet_amount": 200, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetBWBonusTwoPair", "settle_amount": 0}], "game_state": "EndRoundState", "game_result_id": "351965", "timestamp": 1447818541.783871, "remain_time": 9, "game_type": "BigWin", "id": "4e53cdba8da711e589d3f23c9189e2a9", "game_id": "BigWin-1", "message_type": "MsgBPEndRound", "game_round": 36}
			//full + 和
			//var fakePacket:Object = {"result_list": [{"bet_type": "BetBWPlayer", "settle_amount": 0, "odds": 4, "win_state": "WSBWFullHouse", "bet_amount": 0}, {"bet_type": "BetBWBanker", "settle_amount": 0, "odds": 4, "win_state": "WSBWFullHouse", "bet_amount": 0}, {"bet_type": "BetBWTiePoint", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetBWSpecial", "settle_amount": 0, "odds": 11, "win_state": "WSBWFullHouse", "bet_amount": 0}, {"bet_type": "BetBWPlayerPair", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetBWBankerPair", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}], "game_state": "EndRoundState", "game_result_id": "302523", "timestamp": 1443767410.186916, "remain_time": 9, "game_type": "BigWin", "game_round": 131, "game_id": "BigWin-1", "message_type": "MsgBPEndRound", "id": "07bac7b668cf11e5a9aef23c9189e2a9"}
			
			_MsgModel.push(fakePacket);	
			
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "3")]
		public function pack_sim():void
		{
			//dispatcher(new Intobject(utilFun.Random(2), "power_up"));
			//return;
			
			//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;			
			//pack test
			//_loader.init();
			//_replayer.set_mission_id(_loader.getToken());
			//dispatcher(new ArrayObject([_replayer.mission_id(),"pack_player_win.txt",{callback:"replay_config_complete"}], "binary_file_loading"));
				
			//music test
			//dispatcher(new StringObject("Soun_Bet_BGM","Music_pause" ) );
			//dispatcher(new StringObject("sound_coin","sound" ) );
			//dispatcher(new StringObject("sound_msg","sound" ) );
			//dispatcher(new StringObject("sound_rebet","sound" ) );
			
			//power bar test
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			//dispatcher(new Intobject(utilFun.Random(2), "power_up"));		
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "4")]
		public function pre_open():void
		{
			_model.putValue(modelName.POKER_1, []);				
			_model.putValue(modelName.POKER_2, []);			
			_model.putValue("scirpt_pai", ["1s","2d","3s","5c","6h","9d","7d"]);			
			
			fake_hisotry();
			
			_model.putValue(modelName.GAMES_STATE,gameState.PRE_OPEN);			
			dispatcher(new ModelEvent("update_state"));
				
			//================================================ simu deal
			var testpoker:Array = ["Player", "Player", "Player","Player","Player"];
			_regular.Call(this, { onUpdate:this.fackeDeal, onUpdateParams:[testpoker] }, 5, 0, 5, "linear");
		}
		
		public function fackeDeal(type:Array):void
		{			
			var cardlist:Array = _model.getValue("scirpt_pai");
			
			var card_type:String = type[0];
			var card:String = cardlist[0];
			type.shift();
			cardlist.shift();
			Log("fackeDeal card = " + card);
			var mypoker:Array = [];
			var mypoker2:Array = [];
			if ( card_type == "Player")
			{										
				mypoker = _model.getValue(modelName.POKER_1);										
				mypoker2 = _model.getValue(modelName.POKER_2);										
				mypoker.push(card);
				mypoker2.push(card);
				_model.putValue(modelName.POKER_1, mypoker);
				_model.putValue(modelName.POKER_2, mypoker2);
				dispatcher(new Intobject(modelName.POKER_1, "poker_mi"));				
				dispatcher(new Intobject(modelName.POKER_2, "poker_mi"));
			}		
		}
		
		public function fake_hisotry():void
		{			
			var arr:Array = [];
			for ( var i:int = 0; i < 60; i++)
			{					
				var p:int = utilFun.Random(12)+1;				
				arr.push(p);
			}		
			_model.putValue("history_list", arr);			
		}
		
	}

}