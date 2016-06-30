//
//  SoundEffect
//
//  Created by Harry Kunz on 2010-12-04.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.resources{

	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class SoundEffect{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		public static const INTRO:int = 0;
		public static const PAKMAN_KILLED:int = 1;
		public static const ENERGIZER:int = 2;
		public static const PELLET:int = 3;
		public static const GHOST_KILL:int = 4;
		
		//================================================================== 
		// PROTECTED PROPERTIES
		
		[Embed(source="/../resources/sounds/Intro.mp3")] protected static const IntroTheme:Class;
		[Embed(source="/../resources/sounds/PacmanDies.mp3")] protected static const PakManKill:Class;
		[Embed(source="/../resources/sounds/PowerPill.mp3")] protected static const PowerPillEat:Class;
		[Embed(source="/../resources/sounds/PowerPill.mp3")] protected static const GhostEat:Class;
		[Embed(source="/../resources/sounds/Pellet1.mp3")] protected static const Pellet1:Class;
		[Embed(source="/../resources/sounds/Pellet2.mp3")] protected static const Pellet2:Class;
		
		protected static var _intro:Sound;
		protected static var _pakmanKill:Sound;
		protected static var _powerPillEat:Sound;
		protected static var _pelletEat1:Sound;
		protected static var _pelletEat2:Sound;
		protected static var _ghostEat:Sound;
		protected static var _soundChannel:SoundChannel;
		protected static var _pelletToggle:Boolean;
		
		//================================================================== 
		// CONSTRUCTOR

		public function SoundEffect(){
			throw new Error("Cannot instantiate SoundEffect class");
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public static function initialise():void{
			_intro = new IntroTheme() as Sound;
			_pakmanKill = new PakManKill() as Sound;
			_powerPillEat = new PowerPillEat() as Sound;
			_ghostEat = new GhostEat() as Sound;
			_pelletEat1 = new Pellet1() as Sound;
			_pelletEat2 = new Pellet2() as Sound;
			_pelletToggle = true;
		}
		
		public static function play(id:int):void{
			switch(id){
				case INTRO: _soundChannel = _intro.play(); break;
				case PAKMAN_KILLED: _soundChannel = _pakmanKill.play(); break;
				case ENERGIZER: _soundChannel = _powerPillEat.play(); break;
				case GHOST_KILL: _soundChannel = _ghostEat.play(); break;
				case PELLET:
					_pelletToggle = !_pelletToggle;
					_pelletToggle ? _soundChannel = _pelletEat2.play(400) : _soundChannel = _pelletEat1.play(350);
					break;
				default: throw new Error("Unknown Sound Id: " + id); break;
			}
			
			var soundTrans:SoundTransform = _soundChannel.soundTransform;
			soundTrans.volume = 1.0;
			_soundChannel.soundTransform = soundTrans;
		}
		
		//================================================================== 
		// PROTECTED METHODS

		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		//================================================================== 
		// GET METHODS

	}
}
