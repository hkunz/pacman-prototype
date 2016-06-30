//
//  GameStageView
//
//  Created by Harry Kunz on 2010-12-04.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.views{
	
	import bigpoint.games.Enum;
	import bigpoint.games.events.GameEvent;
	import bigpoint.games.Globals;
	import bigpoint.games.resources.SoundEffect;
	import bigpoint.games.ui.Creature;
	import bigpoint.games.ui.GhostEnemy;
	import bigpoint.games.ui.ghost.Blinky;
	import bigpoint.games.ui.ghost.Inkey;
	import bigpoint.games.ui.ghost.Clyde;
	import bigpoint.games.ui.Grid;
	import bigpoint.games.ui.PacmanHero;
	import bigpoint.games.ui.Tile;
	import bigpoint.games.ui.TileItem;
	import bigpoint.games.utils.populateGrid;
	import bigpoint.games.views.View;
	
	import com.hkunz.core.CoreDispatcher;
	import com.hkunz.core.Factory;
	import com.hkunz.core.KeyboardHandler;
	import com.hkunz.log.Log;
	import com.hkunz.utils.localToLocal;
	import com.hkunz.utils.delay;
	import com.hkunz.text.Text;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class GameStageView extends View{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		public static var GHOSTS:Array;
		
		//================================================================== 
		// PROTECTED PROPERTIES
		
		protected static var _pacman:PacmanHero;
		protected static var _blinkyGhost:Blinky;
		protected static var _inkeyGhost:Inkey;
		protected static var _clydeGhost:Clyde;
		
		protected var _grid:Grid;
		protected var _container:Sprite;
		protected var _mapData:Object
		protected var _points:int;
		protected var _scoreText:Text;
		protected var _dotsToClear:int;
		protected var _ghostKillValue:int;
		protected var _invulnerabilityTimer:Timer; //God Mode ON/OFF
		
		//================================================================== 
		// CONSTRUCTOR

		public function GameStageView(mapData:Object){
			_mapData = mapData;
			initialise();
			render();
			addEventListeners();
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public override function destroy():void{
			super.destroy();
			KeyboardHandler.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_invulnerabilityTimer.removeEventListener(TimerEvent.TIMER, stopInvulnerability);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		//================================================================== 
		// PROTECTED METHODS

		protected function initialise():void{
			_points = 0;
			_invulnerabilityTimer = new Timer(Globals.INVULNERABILITY_DURATION);
			_invulnerabilityTimer.addEventListener(TimerEvent.TIMER, stopInvulnerability);
			
			Globals.STAGE.focus = this;
		}
		
		protected override function render():void{
			super.render();
			
			var scoreText:Text = Factory.create(Text, {text:"SCORE:", x:10, autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0xFFFFFF, size:30});
			scoreText.y = Globals.STAGE_HEIGHT - scoreText.height - 5;
			
			_container = new Sprite();
			_grid = new Grid();
			
			Creature.GRID = _grid;
			
			var gridData:Object = populateGrid(_grid, _mapData);
			
			_dotsToClear = gridData["dots"];
			
			_scoreText = Factory.create(Text, {text:"0", autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0xFFFF00, size:30});
			_scoreText.x = scoreText.x + scoreText.width + 5;
			_scoreText.y = scoreText.y;
			
			_container.addChild(_grid);
			_container.addChild(scoreText);
			_container.addChild(_scoreText);
			
			addChild(_container);
			
			gameStart();
		}
		
		protected function addEventListeners():void{
			CoreDispatcher.addEventListener(GameEvent.PACMAN_MOVE, onPacmanMove);
			CoreDispatcher.addEventListener(GameEvent.RESTART, function(event:GameEvent):void{
				gameStart();
			});
			
			CoreDispatcher.addEventListener(GameEvent.RESPAWN_GHOST, function(event:GameEvent):void{
				
			});
		}
		
		protected function gameStart():void{
			SoundEffect.play(SoundEffect.INTRO);
			var readyText:Text = Factory.create(Text, {text:"READY!!", autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0xFFFF00, size:27});
			var self:Object = this;
			removeCharacters();
			createCharacters();
			readyText.x = (Globals.STAGE_WIDTH - readyText.width)*0.5;
			readyText.y = _grid.getTileAt(0,19).y + Globals.TILE_HEIGHT*Globals.SCALE*0.5;
			addChild(readyText);
			delay(3000, function():void{
				playerStart();
				self.removeChild(readyText);
			});
		}
		
		protected function stageClear():void{
			//to be implemented //this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function createCharacters():void{
			_pacman = new PacmanHero();
			_pacman.speed = Globals.PACMAN_SPEED;
			_pacman.stopMove();
			
			_blinkyGhost = new Blinky();
			_inkeyGhost = new Inkey();
			_clydeGhost = new Clyde();
			
			GHOSTS = [_blinkyGhost, _inkeyGhost, _clydeGhost];
			GhostEnemy.ENEMY = _pacman;
			
			for each(var ghost:GhostEnemy in GHOSTS){
				ghost.speed = Globals.GHOST_SPEED;
			}
			
			positionAt(_pacman, 14, 26);
			positionAt(_blinkyGhost, 14, 14);
			positionAt(_inkeyGhost, 16, 14);
			positionAt(_clydeGhost, 12, 14);
			
			_container.addChild(_blinkyGhost);
			_container.addChild(_inkeyGhost);
			_container.addChild(_clydeGhost);
			_container.addChild(_pacman);
		}
		
		protected function removeCharacters():void{
			if(_pacman){
				_container.removeChild(_pacman);
				_pacman = null;
			}
			if(GHOSTS){
				for each(var ghost:GhostEnemy in GHOSTS){
					_container.removeChild(ghost);
				}
				GHOSTS = null;
			}
		}
		
		protected function playerStart():void{
			KeyboardHandler.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_pacman.startMove();
			_blinkyGhost.startMove();
			_clydeGhost.startMove();
			_inkeyGhost.startMove();
		}
		
		protected function positionAt(target:Sprite, tileX:int, tileY:int):Tile{
			var tile:Tile = _grid.getTileAt(tileX, tileY);
			target.x = tile.x + tile.width*0.5;
			target.y = tile.y + tile.height*0.5;
			return tile;
		}
		
		protected function onKeyDown(event:KeyboardEvent = null, direction:int = -1):void{
			var faceDirection:int = _pacman.getFaceDirection();
			var pacmanTile:Tile = _grid.getTileAtPixel(_pacman.x, _pacman.y);
			var adjTile:Tile;
			
			if(_pacman.visible){
				switch (event.keyCode){
					case Keyboard.UP: _pacman.direction = Enum.MOVE_UP; break;
					case Keyboard.DOWN: _pacman.direction = Enum.MOVE_DOWN; break;
					case Keyboard.LEFT: _pacman.direction = Enum.MOVE_LEFT; break;
					case Keyboard.RIGHT: _pacman.direction = Enum.MOVE_RIGHT; break;
					default: Log.debug("Unhandled Keyboard Input"); break;
				}
			}
			
			if(!_pacman.move && _pacman.direction != faceDirection){
				_pacman.startMove();
				_pacman.turn();
			}
		}
		
		protected function onEnterFrame(event:Event):void{
			if(!_pacman.killed){
				for each(var ghost:GhostEnemy in GHOSTS){
					if(_pacman.hitTestPoint(ghost.x, ghost.y)){
						if(!ghost.killed){
							if(ghost.vulnerable){
								ghost.killValue = _ghostKillValue;
								ghost.kill();
								gainPointsBy(_ghostKillValue);
								_ghostKillValue *= 2;
								_container.addChild(ghost);
								killGhost(ghost);
							}else{
								this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
								KeyboardHandler.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
								_pacman.kill();
								pauseGhostsMobility(true);
							}
							break;
						}
					}
				}
			}
			
			function killGhost(ghost:GhostEnemy):void{
				_pacman.stopMove(false);
				_pacman.visible = false;
				pauseGhostsMobility(true);
				delay(700, function():void{
					_pacman.visible = true;
					_pacman.startMove();
					pauseGhostsMobility(false);
				});
				delay(5000, function():void{
					ghost.respawn();
					_container.addChild(_pacman);
					SoundEffect.play(SoundEffect.ENERGIZER);
				})
			}

			function pauseGhostsMobility(value:Boolean):void{
				for each(var ghost:GhostEnemy in GHOSTS){
					value ? ghost.stopMove(false) : ghost.startMove();
				}
			}
		}
		
		protected function onPacmanMove(event:GameEvent):void{
			removeItemInCurTile();
		}
		
		protected function startInvulnerability():void{
			stopInvulnerability();
			_ghostKillValue = 200;
			_invulnerabilityTimer.start();
			_pacman.vulnerable = false;
			for each(var ghost:Creature in GHOSTS){
				ghost.vulnerable = true;
			}
		}
		
		protected function stopInvulnerability(event:TimerEvent = null):void{
			_invulnerabilityTimer.stop();
			_pacman.vulnerable = true;
			for each(var ghost:Creature in GHOSTS){
				ghost.vulnerable = false;
			}
		}
		
		protected function gainPointsBy(points:int):void{
			_points += points;
			_scoreText.text = _points.toString();
			_dotsToClear--;

			if(_dotsToClear <= 0){
				stageClear();
			}
			//Log.debug("items: " + _dotsToClear);
		}
		
		protected function removeItemInCurTile():void{
			var currTile:Tile = _pacman.currTile;
			if(currTile){
				var tileItem:int = currTile.itemType;
				if(tileItem != TileItem.EMPTY && !currTile.boundary){
					switch(tileItem){
						case TileItem.ENERGIZER:
							SoundEffect.play(SoundEffect.ENERGIZER);
							gainPointsBy(50);
							startInvulnerability();
							break;
						case TileItem.PELLET:
							SoundEffect.play(SoundEffect.PELLET);
							gainPointsBy(10);
							break;
						default: break;
					}
					currTile.removeItem();
					currTile.itemType = TileItem.EMPTY;
				}
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