//
//  GameEvent
//
//  Created by Harry Kunz on 2010-12-05.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.events{

	import flash.events.Event;

	public class GameEvent extends Event{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		public static const NAVIGATE:String = "navigate";
		public static const EARN_POINTS:String = "earnPoints";
		public static const STAGE_CLEAR:String = "stageClear";
		public static const RESTART:String = "restartGame";
		public static const RESPAWN_GHOST:String = "respawnGhost";
		public static const PACMAN_KILLED:String = "pacmanKilled";
		public static const PACMAN_MOVE:String = "pacmanMove";
		
		//================================================================== 
		// PROTECTED PROPERTIES

		protected var _value:*;

		//================================================================== 
		// CONSTRUCTOR

		public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, value:* = null){
			super(type, bubbles, cancelable);
			_value = value;
		}

		//================================================================== 
		// PUBLIC METHODS

		//================================================================== 
		// PROTECTED METHODS

		public override function clone():Event{
			return new GameEvent(type, bubbles, cancelable, _value);
		}

		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		public function set value(value:*):void{
			_value = value;
		}

		//================================================================== 
		// GET METHODS
		
		public function get value():*{
			return _value;
		}
	}
}