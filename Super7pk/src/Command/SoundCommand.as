package Command 
{	
	import Model.*;
	import Model.valueObject.StringObject;
	import treefortress.sound.SoundTween;
	
	import util.*;	
	
	import treefortress.sound.SoundAS;
     import treefortress.sound.SoundInstance;
     import treefortress.sound.SoundManager;

	 
	/**
	 * sound play
	 * @author hhg4092
	 */
	public class SoundCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		private var _mute:Boolean;
		
		public function SoundCommand() 
		{
			
		}
		
		
		public function init():void
		{
			//SoundAS.addSound("Soun_Bet_BGM", new Soun_Bet_BGM());
			SoundAS.addSound("sound_Powerup_poker", new sound_Powerup_poker());			
			SoundAS.addSound("sound_prob", new sound_prob());			
			
			SoundAS.addSound("sound_coin", new sound_coin());
			SoundAS.addSound("sound_msg", new sound_msg());
			SoundAS.addSound("sound_rebet", new sound_rebet());	
			
			SoundAS.addSound("sound_bigPoker", new sound_bigPoker());
			SoundAS.addSound("sound_poker_turn", new sound_poker_turn());			
			SoundAS.addSound("sound_final", new sound_final());			
			SoundAS.addSound("sound_stop_bet", new sound_stop_bet());			
			SoundAS.addSound("sound_start_bet", new sound_start_bet());			
			SoundAS.addSound("sound_get_point", new sound_get_point());			
			SoundAS.addSound("soundBomb", new sound_Bomb());			
			SoundAS.addSound("sound_BombLong", new sound_BombLong());			
			
			SoundAS.addSound("sound_player", new sound_player());
			SoundAS.addSound("sound_deal", new sound_deal());
			SoundAS.addSound("sound_0", new sound_0());
			SoundAS.addSound("sound_1", new sound_1());
			SoundAS.addSound("sound_2", new sound_2());
			SoundAS.addSound("sound_3", new sound_3());
			SoundAS.addSound("sound_4", new sound_4());
			SoundAS.addSound("sound_5", new sound_5());
			SoundAS.addSound("sound_6", new sound_6());
			SoundAS.addSound("sound_7", new sound_7());
			SoundAS.addSound("sound_8", new sound_8());
			SoundAS.addSound("sound_9", new sound_9());
			SoundAS.addSound("sound_point", new sound_point());
			SoundAS.addSound("sound_tie_win", new sound_tie_win());
			SoundAS.addSound("sound_deal_win", new sound_deal_win());
			SoundAS.addSound("sound_player_win", new sound_player_win());
			
			
			
			//create lobbycall back
			var lobbyevent:Function =  _model.getValue(modelName.HandShake_chanel);			
			if ( lobbyevent != null)
			{
				lobbyevent(_model.getValue(modelName.Client_ID), ["HandShake_callback", this.lobby_callback]);			
			}
			
			_mute = false;
		}
		
		public function lobby_callback(CMD:Array):void
		{
			utilFun.Log("DK lobby call back = " + CMD[0]);	
			if ( CMD[0] == "STOP_BGM")
			{
				//dispatcher(new StringObject("Soun_Bet_BGM","Music_pause" ) );
			}
			if ( CMD[0] == "START_BGM")
			{
				//dispatcher(new StringObject("Soun_Bet_BGM","Music" ) );
			}
			
			if ( CMD[0] == "MUTE")
			{
				_mute = true;				
			}
			
			if ( CMD[0] == "RESUME")
			{
				_mute = false;				
			}
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music")]
		public function playMusic(sound:StringObject):void
		{
			
			//var s:SoundTween  = SoundAS.addTween(sound.Value);			
			
			var ss:SoundInstance = SoundAS.playLoop(sound.Value);
			
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music_pause")]
		public function stopMusic(sound:StringObject):void
		{
			SoundAS.pause(sound.Value);
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="sound")]
		public function playSound(sound:StringObject):void
		{
			if ( _mute ) return;
			SoundAS.playFx(sound.Value);
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="loop_sound")]
		public function loop_sound(sound:StringObject):void
		{
			if ( _mute == true ) return;
			SoundAS.playLoop(sound.Value);
		}
		
	}

}