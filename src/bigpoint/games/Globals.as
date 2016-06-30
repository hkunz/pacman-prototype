//
//  Globals
//
//  Created by Harr Kunz on 2010-12-03.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games{

	import flash.display.Stage;

	public class Globals{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		public static var FRAME_RATE:int;
		public static var STAGE_WIDTH:int;
		public static var STAGE_HEIGHT:int;
		public static var STAGE:Stage;
		
		public static const SCALE:int = 2;
		public static const GRID_WIDTH:int = 224;
		public static const GRID_HEIGHT:int = 288;
		public static const TILE_WIDTH:int = 8;
		public static const TILE_HEIGHT:int = 8;
		public static const PACMAN_RADIUS:int = 7;
		public static const GHOST_HEIGHT:int = 14;
		public static const PACMAN_SPEED:int = 14; //Tiles per second
		public static const GHOST_SPEED:int = 15; //Tiles per second
		public static const TILES_X:int = GRID_WIDTH / TILE_WIDTH;
		public static const TILES_Y:int = GRID_HEIGHT / TILE_HEIGHT;
		public static const INVULNERABILITY_DURATION:int = 7000; //milliseconds
		
		//================================================================== 
		// PROTECTED PROPERTIES

		protected static var _stage:Stage;

		//================================================================== 
		// CONSTRUCTOR

		public function Globals(){
			
		}

		//================================================================== 
		// PUBLIC METHODS

		public static function initialise(stage:Stage):void{
			if(stage){
				_stage = stage;
				FRAME_RATE = stage.frameRate;
				STAGE_WIDTH = stage.stageWidth;
				STAGE_HEIGHT = stage.stageHeight;
				STAGE = stage;
			}
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