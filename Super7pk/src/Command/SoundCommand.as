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
			SoundAS.addSound("sound_coin", new sound_coin());
			SoundAS.addSound("sound_final", new sound_final());
			SoundAS.addSound("sound_start_bet", new sound_start_bet());			
			SoundAS.addSound("sound_stop_bet", new sound_stop_bet());	
			SoundAS.addSound("sound_msg", new sound_msg());
			
			SoundAS.addSound("sound_none", new sound_none());
			SoundAS.addSound("sound_one_pair", new sound_one_pair());
			SoundAS.addSound("sound_two_pair", new sound_two_pair());
			SoundAS.addSound("sound_tripple", new sound_tripple());
			SoundAS.addSound("sound_straight", new sound_straight());
			SoundAS.addSound("sound_flush", new sound_flush());
			SoundAS.addSound("sound_full_house", new sound_full_house());
			SoundAS.addSound("sound_four_of_a_kind", new sound_four_of_a_kind());
			SoundAS.addSound("sound_straight_flush", new sound_straight_flush());
			SoundAS.addSound("sound_royal_flush", new sound_royal_flush());
			SoundAS.addSound("sound_five_of_a_kind", new sound_five_of_a_kind());
			SoundAS.addSound("sound_pure_royal_Flush", new sound_pure_royal_Flush());
			
			//create lobbycall back
			var lobbyevent:Function =  _model.getValue(modelName.HandShake_chanel);			
			if ( lobbyevent != null)
			{
				lobbyevent(_model.getValue(modelName.Client_ID), ["HandShake_callback", this.lobby_callback]);			
			}
			
			_mute = false;
		}
		
		//大廳呼叫遊戲
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
			
			if ( CMD[0] == "UPDATE_CREDIT")
			{
				var  credit:int = CMD[1]	;
				_model.putValue(modelName.CREDIT, credit);
			}
			
			if ( CMD[0] == "LOBBY_DISCONNET")
			{
				_model.putValue("lobby_disconnect", true);				
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