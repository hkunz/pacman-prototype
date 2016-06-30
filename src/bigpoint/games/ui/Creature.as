//
//  Creature
//
//  Created by Harry Kunz on 2010-12-05.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.ui{
	
	import bigpoint.games.Enum;
	import bigpoint.games.Globals;
	import bigpoint.games.ui.Grid;
	import bigpoint.games.ui.Tile;
	import bigpoint.games.ui.TileItem;

	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Creature extends Sprite{

		//================================================================== 
		// PUBLIC PROPERTIES

		public static var GRID:Grid;

		//================================================================== 
		// PROTECTED PROPERTIES
		
		protected var _vulnerable:Boolean;
		protected var _frame:int;
		protected var _direction:int;
		protected var _rotation:int;
		protected var _currTile:Tile;
		protected var _move:Boolean;
		protected var _killed:Boolean;
		protected var _speed:int;
		
		//================================================================== 
		// CONSTRUCTOR

		public function Creature(){

		}

		//================================================================== 
		// PUBLIC METHODS
		
		public function destroy():void{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function kill():void{
			_killed = true;
		}

		public function turn():void{
			switch(_direction){
				case Enum.MOVE_LEFT: _rotation = 270; break;
				case Enum.MOVE_RIGHT: _rotation = 90; break;
				case Enum.MOVE_UP: _rotation = 0; break;
				case Enum.MOVE_DOWN: _rotation = 180; break;
				default: throw new Error("Invalid direction: " + _direction);
			}
		}
		
		public function startMove():void{
			_move = true;
		}
		
		public function stopMove(reset:Boolean = true):void{
			_move = false;
		}
		
		public function getFaceDirection():int{
			var direction:int;
			switch(_rotation){
				case 270: direction = Enum.MOVE_LEFT; break;
				case 90: direction = Enum.MOVE_RIGHT; break;
				case 0: direction = Enum.MOVE_UP; break;
				case 180: direction = Enum.MOVE_DOWN; break;
				default: throw new Error("Invalid rotation"); break;
			}
			return direction;
		}

		//================================================================== 
		// PROTECTED METHODS

		protected function initialise():void{
			_move = false;
			_vulnerable = true;
			_killed = false;
		}
		
		protected function onEnterFrame(event:Event):void{
			
			if(!_move){
				return;
			}
			
			var inc:Number = _speed /  Globals.FRAME_RATE * Globals.TILE_WIDTH * Globals.SCALE;
			var faceDirection:int = getFaceDirection();
			_currTile = GRID.getTileAtPixel(this.x, this.y);
			var centerX:int = _currTile.width*0.5;
			var centerY:int = _currTile.height*0.5;
			var adjTile:Tile;
			
			switch(faceDirection){
				case Enum.MOVE_LEFT:
					this.x -= inc;
					if(this.x < (_currTile.x + centerX)){
						adjTile = GRID.getAdjacentTile(_currTile, Grid.LEFT);
						if(adjTile.boundary){
							stopOrTurn(faceDirection);
							this.x += inc;
						}else{
							checkNextDirection(faceDirection, _currTile);
						}
					}
					break;
				case Enum.MOVE_RIGHT:
					this.x += inc;
					if(this.x > (_currTile.x + centerX)){
						adjTile = GRID.getAdjacentTile(_currTile, Grid.RIGHT);
						if(adjTile.boundary){
							stopOrTurn(faceDirection);
							this.x -= inc;
						}else{
							checkNextDirection(faceDirection, _currTile);
						}
					}
					break;
				case Enum.MOVE_UP:
					this.y -= inc;
					if(this.y < (_currTile.y + centerY)){
						adjTile = GRID.getAdjacentTile(_currTile, Grid.UP);
						if(adjTile.boundary){
							stopOrTurn(faceDirection);
							this.y += inc;
						}else{
							checkNextDirection(faceDirection, _currTile);
						}
					}
					break;
				case Enum.MOVE_DOWN:
					this.y += inc;
					if(this.y > (_currTile.y + centerY)){
						adjTile = GRID.getAdjacentTile(_currTile, Grid.DOWN);
						if(adjTile.boundary){
							stopOrTurn(faceDirection);
							this.y -= inc;
						}else{
							checkNextDirection(faceDirection, _currTile);
						}
					}
					break;
				default: throw new Error("Invalid direction: " + faceDirection);
					break;
			}
			
			//Go from one side to the other
			if(this.x < -this.width*0.5){
				this.x = GRID.width;
			}else if(this.x > GRID.width-this.width*0.1 && faceDirection == Enum.MOVE_RIGHT){
				this.x = -this.width*0.5;
			}
		}
		
		protected function isPathBlocked():Boolean{
			return GRID.getAdjacentTile(_currTile, getGridDirection()).boundary;
		}
		
		protected function checkNextDirection(faceDirection:int, _currTile:Tile):void{
			if(_direction != faceDirection){
				var adjTile:Tile = GRID.getAdjacentTile(_currTile, getGridDirection());
				if(!adjTile.boundary){
					this.turn();
				}
			}
		}
		
		protected function getGridDirection():int{
			var gridDirection:int;
			switch(_direction){
				case Enum.MOVE_UP: gridDirection = Grid.UP; break;
				case Enum.MOVE_LEFT: gridDirection = Grid.LEFT; break;
				case Enum.MOVE_DOWN: gridDirection = Grid.DOWN; break;
				case Enum.MOVE_RIGHT: gridDirection = Grid.RIGHT; break;
			}
			return gridDirection;
		}
		
		protected function stopOrTurn(faceDirection:int):void{
			if(faceDirection == this.direction){
				_move = false;
				this.stopMove(true);
			}else{
				this.turn();
			}
		}

		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		public function set direction(value:int):void{
			_direction = value; //next direction
		}
		
		public function set vulnerable(value:Boolean):void{
			_vulnerable = value;
		}
		
		public function set speed(value:int):void{
			_speed = value;
		}
		
		//================================================================== 
		// GET METHODS
		
		public function get direction():int{
			return _direction;
		}
		
		public function get move():Boolean{
			return _move;
		}
		
		public function get vulnerable():Boolean{
			return _vulnerable;
		}
		
		public function get killed():Boolean{
			return _killed;
		}
		
		public function get currTile():Tile{
			return _currTile;
		}
	}
}