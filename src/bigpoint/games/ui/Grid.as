//
//  Grid
//
//  Created by Harry Kunz on 2010-12-03.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.ui{

	import bigpoint.games.Globals;
	import bigpoint.games.ui.Tile;

	import com.hkunz.core.Factory;
	import com.hkunz.display.utils.createSimpleRect;
	import com.hkunz.log.Log;
	import com.hkunz.text.Text;
	
	import flash.display.Sprite;

	public class Grid extends Sprite{

		//================================================================== 
		// PUBLIC PROPERTIES

		public static const UP:int = 0;
		public static const LEFT:int = 1;
		public static const DOWN:int = 2;
		public static const RIGHT:int = 3;

		//================================================================== 
		// PROTECTED PROPERTIES
		
		protected var _numTilesH:int;
		protected var _numTilesV:int;
		protected var _tiles:Array; //Unfortunately _tiles:Vector.<Tile> cannot be used with my Flex version :-(

		//================================================================== 
		// CONSTRUCTOR

		public function Grid(){
			initialise();
			render();
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public function getTileAt(xpos:int, ypos:int):Tile{
			var index:int = ypos*Globals.TILES_X + xpos;
			if((ypos < 0) || (xpos < 0) || (index >= _tiles.length)){
				throw new Error("Invalid position: (" + xpos + "," + ypos + ")");
			}
			return _tiles[index] as Tile; //zero-based
		}
		
		public function getTileAtPixel(xpixel:int, ypixel:int):Tile{
			var scale:int = Globals.SCALE;
			var xpos:int = xpixel / (Globals.TILE_WIDTH * scale);
			var ypos:int = ypixel / (Globals.TILE_HEIGHT * scale);
			return getTileAt(xpos, ypos);
		}
		
		public function getAdjacentTile(tile:Tile, direction:int):Tile{
			const TILES_X:int = Globals.TILES_X;
			const TILES_Y:int = Globals.TILES_Y;
			var adjacentTile:Tile;
			var index:int = tile.index;
			
			switch(direction){
				
				case UP:
					index -= TILES_X;
					if(index < 0){
						index += TILES_X * TILES_Y;
					}
					adjacentTile = _tiles[index];
					break;
					
				case LEFT:
					if(index%TILES_X == 0){
						index += TILES_X;
					}
					index -= 1;
					adjacentTile = _tiles[index];
					break;
					
				case DOWN:
					index += TILES_X;
					adjacentTile = _tiles[index];
					break;
					
				case RIGHT:
					index += 1;
					if(index%TILES_X == 0 && index != 1){
						index -= TILES_X;
					}
					adjacentTile = _tiles[index];
					break;
			}
			return adjacentTile;
		}
		
		//================================================================== 
		// PROTECTED METHODS

		protected function initialise():void{
			_tiles = [];
		}

		protected function render():void{
			var ypos:int = 0;
			var scale:int = Globals.SCALE;
			var width:int = Globals.GRID_WIDTH * scale;
			var height:int = Globals.GRID_HEIGHT * scale;
			var tileWidth:int = Globals.TILE_WIDTH * scale;
			var tileHeight:int = Globals.TILE_HEIGHT * scale;
			
			const TILES_X:int = Globals.TILES_X;
			const TILES_Y:int = Globals.TILES_Y;
			const TILE_AREA:int = TILES_X * TILES_Y;
			
			//addChild(createSimpleRect(width, height, 0x000000));
			
			for(var n:int = 0; n < TILE_AREA; n++){
				var tile:Tile = new Tile();
				var xpos:int = (n*tileWidth) % width;
				var xTile:int = (n%TILES_X);
				var yTile:int = int(n/TILES_X);
				
				tile.name = "t" + "(" + xTile + "," + yTile + ")";
				
				with(tile.graphics){
					//lineStyle(1, 0x555555, 0.3);
					beginFill(0x000000, 1);
					drawRect(0, 0, tileWidth, tileHeight);
					endFill();
				}
				
				if(xpos == 0 && n != 0){
					ypos += tileHeight;
				}
				
				tile.x = xpos;
				tile.y = ypos;
				tile.index = n;
				
				_tiles.push(tile);
				addChild(tile);
			}
		}

		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		//================================================================== 
		// GET METHODS

	}
}