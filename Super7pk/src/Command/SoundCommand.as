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
		
		private var soundlist:DI = new DI();
		
		public function SoundCommand() 
		{
			
		}
		
		
		public function init():void
		{
			//SoundAS.addSound("Soun_Bet_BGM", new Soun_Bet_BGM());
		
			
			
			
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
			if ( soundlist.getValue(sound.Value) == null) return;
			
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