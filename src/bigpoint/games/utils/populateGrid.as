//
//  populateGrid
//
//  Created by hkunz on 2010-12-04.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.utils{

	import bigpoint.games.Globals;
	import bigpoint.games.ui.Grid;
	import bigpoint.games.ui.Tile;
	import bigpoint.games.ui.TileItem;
	
	import com.hkunz.log.Log;
	
	//================================================================== 
	// PUBLIC METHODS

	public function populateGrid(grid:Grid, mapData:Object):Object{
		
		var itemType:Object = mapData.itemTypes;
		var values:Object = mapData.map.values;
		var data:Object = {};
		var numItemsToClear:int = 0;
		
		const TILES_X:int = Globals.TILES_X;
		const TILES_Y:int = Globals.TILES_Y;

		const PELLET:String = itemType["Pellet"];
		const ENERGIZER:String = itemType["Energizer"];
		const FRUIT:String = itemType["Fruit"];
		const BOUNDARY_AQ1:String = itemType["BoundaryAQ1"];
		const BOUNDARY_AQ2:String = itemType["BoundaryAQ2"];
		const BOUNDARY_AQ3:String = itemType["BoundaryAQ3"];
		const BOUNDARY_AQ4:String = itemType["BoundaryAQ4"];
		const BOUNDARY_H:String = itemType["BoundaryH"];
		const BOUNDARY_V:String = itemType["BoundaryV"];
		const EMPTY:String = itemType["Empty"];
		
		for(var yy:int = 0; yy < TILES_Y; yy++){
			for(var xx:int = 0; xx < TILES_X; xx++){
				var itmTyp:String = EMPTY;
				try{
					itmTyp = values[xx+":"+yy];
				}catch(e:Error){}
				insertItem(xx, yy, itmTyp);
			}
		}
		
		function insertItem(xpos:int, ypos:int, type:String):void{
			var tile:Tile = grid.getTileAt(xpos, ypos);
			if(tile){
				switch(type){
					case PELLET: TileItem.insert(tile, TileItem.PELLET); numItemsToClear++; break;
					case ENERGIZER: TileItem.insert(tile, TileItem.ENERGIZER); numItemsToClear++; break;
					case FRUIT: TileItem.insert(tile, TileItem.FRUIT); break;
					case BOUNDARY_AQ1: TileItem.insert(tile, TileItem.BOUNDARY_AQ1); break;
					case BOUNDARY_AQ2: TileItem.insert(tile, TileItem.BOUNDARY_AQ2); break;
					case BOUNDARY_AQ3: TileItem.insert(tile, TileItem.BOUNDARY_AQ3); break;
					case BOUNDARY_AQ4: TileItem.insert(tile, TileItem.BOUNDARY_AQ4); break;
					case BOUNDARY_V: TileItem.insert(tile, TileItem.BOUNDARY_V); break;
					case BOUNDARY_H: TileItem.insert(tile, TileItem.BOUNDARY_H); break;
					case EMPTY: case null: TileItem.insert(tile, TileItem.EMPTY); break;
					default: throw new Error("Invalid Insert-Item: " + type + " @" + tile.name); break;
				}
			}
		}
		
		data["dots"] = numItemsToClear;
		return data;
	}
}