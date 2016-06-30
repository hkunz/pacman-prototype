//
//  TileItem
//
//  Created by Harry Kunz on 2010-12-03.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.ui{

	import bigpoint.games.Globals;
	import bigpoint.games.ui.Tile;
	
	import com.hkunz.display.Polygon;
	import com.hkunz.display.utils.createSimpleCircle;
	import com.hkunz.log.Log;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class TileItem extends EventDispatcher{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		public static const EMPTY:int = 0;			//No item inside Tile
		public static const BOUNDARY_AQ1:int = 1;	//Arc in Quadrant 1 of Whole Circle
		public static const BOUNDARY_AQ2:int = 2;	//Arc in Quadrant 2 of Whole Circle
		public static const BOUNDARY_AQ3:int = 3;	//Arc in Quadrant 3 of Whole Circle
		public static const BOUNDARY_AQ4:int = 4;	//Arc in Quadrant 4 of Whole Circle
		public static const BOUNDARY_H:int = 5;		//Horizontal Boundary
		public static const BOUNDARY_V:int = 6;		//Vertical Boundary
		public static const PELLET:int = 7;			//Pelet inside Tile
		public static const ENERGIZER:int = 8;		//Energizer inside Tile
		public static const FRUIT:int = 0;			//Fruit inside Tile
		
		public static const CURVE_SIDES:int = 20;	//Curved border sides (for AQ1-AQ4)
		
		public static const BORDER_THICKNESS:int = Globals.SCALE;
		public static const BORDER_COLOR:int = 0x0000FF;
		
		//================================================================== 
		// PROTECTED PROPERTIES

		

		//================================================================== 
		// CONSTRUCTOR

		public function TileItem(){

		}

		//================================================================== 
		// PUBLIC METHODS

		public static function insert(target:Tile, itemType:int):void{
			var tileItem:Sprite = new Sprite();
			var centerX:int = target.width*0.5;
			var centerY:int = target.height*0.5;
			var radius:int;
			
			switch(itemType){
				
				case BOUNDARY_AQ1:
					radius = centerX;
					tileItem = new Polygon(CURVE_SIDES, radius, {strokeThickness:BORDER_THICKNESS, strokeColor:BORDER_COLOR, edgeDraw:true, endAngle:90});
					tileItem.y = target.height;
					target.boundary = true;
					break;
					
				case BOUNDARY_AQ2:
					radius = centerX;
					tileItem = new Polygon(CURVE_SIDES, radius, {strokeThickness:BORDER_THICKNESS, strokeColor:BORDER_COLOR, edgeDraw:true, startAngle:90, endAngle:180});
					target.boundary = true;
					break;
					
				case BOUNDARY_AQ3:
					radius = centerX;
					tileItem = new Polygon(CURVE_SIDES, radius, {strokeThickness:BORDER_THICKNESS, strokeColor:BORDER_COLOR, edgeDraw:true, startAngle:180, endAngle:270});
					tileItem.x = target.width;
					target.boundary = true;
					break;
					
				case BOUNDARY_AQ4:
					radius = centerX;
					tileItem = new Polygon(CURVE_SIDES, radius, {strokeThickness:BORDER_THICKNESS, strokeColor:BORDER_COLOR, edgeDraw:true, startAngle:270});
					tileItem.x = target.width;
					tileItem.y = target.height;
					target.boundary = true;
					break;
					
				case BOUNDARY_H:
					var ypos:int = centerY;
					tileItem = new Sprite();
					with(tileItem.graphics){
						lineStyle(BORDER_THICKNESS, BORDER_COLOR, 1);
						moveTo(0, ypos);
						lineTo(target.width, ypos);
					}
					target.boundary = true;
					break;
					
				case BOUNDARY_V:
					var xpos:int = centerX;
					tileItem = new Sprite();
					with(tileItem.graphics){
						lineStyle(BORDER_THICKNESS, BORDER_COLOR, 1);
						moveTo(xpos, 0);
						lineTo(xpos, target.height);
					}
					target.boundary = true;
					break;
				
				case PELLET:
					tileItem = createSimpleCircle(target.width*0.2, 0xEEEEEE);
					tileItem.x = centerX;
					tileItem.y = centerY;
					break;
					
				case ENERGIZER:
					tileItem = createSimpleCircle(target.width*0.45, 0xFFFFFF);
					tileItem.x = centerX;
					tileItem.y = centerY;
					break;
				
				case FRUIT:
					
					break;
				
				case EMPTY:
				default:
					break;
			}
			
			tileItem.cacheAsBitmap = true;
			target.itemType = itemType;
			target.addChild(tileItem);
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