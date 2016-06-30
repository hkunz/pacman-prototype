//
//  Enemy
//
//  Created by Harry Kunz on 2010-12-03.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.ui{
	
	import bigpoint.games.Enum;
	import bigpoint.games.Globals;
	import bigpoint.games.resources.SoundEffect;
	import bigpoint.games.ui.Creature;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.events.TweenEvent;
	
	import com.hkunz.core.Factory;
	import com.hkunz.display.Polygon;
	import com.hkunz.log.Log;
	import com.hkunz.display.utils.createSimpleCircle;
	import com.hkunz.text.Text;
	import com.hkunz.utils.delay;
	import com.hkunz.utils.getRandomInt;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class GhostEnemy extends Creature{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		public static const TOTAL_FRAMES:int = 1;
		public static const MODE_SCATTER:int = 0;
		public static const MODE_CHASE:int = 1;
		public static const MODE_SCARED:int = 2;
		public static const MODE_GO_HOME:int = 3;
		
		public static var ENEMY:Creature;
		
		//================================================================== 
		// PROTECTED PROPERTIES
		
		protected var _frames:Array;
		protected var _scaredFrames:Array;
		protected var _body:Sprite;
		protected var _scaredBody:Sprite;
		protected var _eyeSet:Sprite;
		protected var _leftEye:Sprite;
		protected var _rightEye:Sprite;
		protected var _name:String;
		protected var _mode:int;
		protected var _prevMode:int;
		protected var _counter:int;
		protected var _killValue:int;
		protected var _toggleSearch:Boolean;
		protected var _searchTurn:Boolean;
		protected var _toggleChase:Boolean;
		protected var _toggleChaseTimer:Timer;
		
		//================================================================== 
		// CONSTRUCTOR

		public function GhostEnemy(name:String, color:int = 0xFF0000){
			_name = name;
			
			initialise();
			render(color);
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public override function kill():void{
			super.kill();
			SoundEffect.play(SoundEffect.GHOST_KILL);
			var scoreText:Text = Factory.create(Text, {text:_killValue.toString(), autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0xFFFFFF, size:18})
			var textHolder:Sprite = new Sprite();
			var self:Object = this;
			scoreText.x = -scoreText.width*0.5;
			scoreText.y = -scoreText.height*0.5;
			textHolder.addChild(scoreText);
			textHolder.scaleX = textHolder.scaleY = 0.3;
			TweenLite.to(textHolder, 0.3, {ease:Back.easeOut, scaleX:1, scaleY:1, onComplete:function():void{
				delay(500, function():void{
					self.removeChild(textHolder);
				});
			}})
			stopMove();
			
			_mode = MODE_GO_HOME;
			_speed = Globals.GHOST_SPEED*2;
			
			removeChild(_scaredBody);
			removeChild(_body);
			
			addChild(_eyeSet);
			addChild(textHolder);
		}
		
		public override function startMove():void{
			super.startMove();
		}

		public override function stopMove(reset:Boolean = true):void{ //reset = false is for pausing
			super.stopMove(reset);
		}
		
		public override function turn():void{
			super.turn();
			lookToMovement();
		}
		
		public function respawn():void{
			_body.addChild(_eyeSet);
			addChild(_body);
			addChild(_scaredBody);
			_body.visible = true;
			_scaredBody.visible = false;
			_speed = Globals.GHOST_SPEED;
			_mode = MODE_SCATTER;
			_killed = false;
			_vulnerable = false;
		}
		
		//================================================================== 
		// PROTECTED METHODS
		
		protected override function initialise():void{
			super.initialise();
			_mode = MODE_SCATTER;
			_prevMode = _mode;
			_direction = Enum.MOVE_LEFT;
			_frames = [];
			_scaredFrames = [];
			_frame = 0;
			_vulnerable = false;
			_toggleChase = false;
			_killValue = 0; //200, 400, 800, 1600
			_toggleChaseTimer = new Timer(5000);
			_toggleChaseTimer.addEventListener(TimerEvent.TIMER, doToggleChase);
			_toggleChaseTimer.start();
		}
		
		protected function render(color:int):void{
			var radius:int = Globals.GHOST_HEIGHT * 0.5 * Globals.SCALE;
			
			createNormalBody();
			createScaredBody();
			lookToMovement();
			
			_body.visible = true;
			_scaredBody.visible = false;
			
			addChild(_body);
			addChild(_scaredBody);
			
			function createNormalBody():void{
				var upper:Sprite = new Polygon(20, radius, {fillColor:color, startAngle:270, endAngle:450});
				var lowerFrame1:Sprite = createLower(radius*0.1, radius*0.2, radius*0.3);
				var lowerFrame2:Sprite = createLower(radius*0.2, radius*0.3, radius*0.2);
				var eyeRadius:int = radius*0.35;
				var pupilRadius:int = radius*0.2;
				var leftEyeball:Sprite = createSimpleCircle(eyeRadius, 0xFFFFFF);
				var rightEyeball:Sprite = createSimpleCircle(eyeRadius, 0xFFFFFF);
				
				leftEyeball.x = -radius*0.4;
				leftEyeball.y = -radius*0.3;
				rightEyeball.x = radius*0.4;
				rightEyeball.y = -radius*0.3;

				_leftEye = createSimpleCircle(pupilRadius, 0x0000FF);
				_rightEye = createSimpleCircle(pupilRadius, 0x0000FF);

				leftEyeball.addChild(_leftEye);
				rightEyeball.addChild(_rightEye);
				
				_eyeSet = new Sprite();
				_eyeSet.addChild(leftEyeball);
				_eyeSet.addChild(rightEyeball);
				
				_body = new Sprite();
				_body.addChild(upper);
				_body.addChild(lowerFrame1);
				_body.addChild(lowerFrame2);
				_body.addChild(_eyeSet);
				
				lowerFrame1.cacheAsBitmap = true;
				lowerFrame2.cacheAsBitmap = true;
				
				_frames[0] = lowerFrame1;
				_frames[1] = lowerFrame2;
			}
			
			function createScaredBody():void{
				var scaredUpper:Sprite = new Polygon(20, radius, {fillColor:0x0000FF, startAngle:270, endAngle:450});
				var scaredLowerFrame1:Sprite = createLower(radius*0.1, radius*0.2, radius*0.3, true);
				var scaredLowerFrame2:Sprite = createLower(radius*0.2, radius*0.3, radius*0.2, true);
				var sadMouth:Sprite = new Sprite();
				var eyeRadius:int = radius*0.25;
				var leftEyeball:Sprite = createSimpleCircle(eyeRadius, 0xFFFFFF);
				var rightEyeball:Sprite = createSimpleCircle(eyeRadius, 0xFFFFFF);
				var mouthH:int = radius*0.3;
				var mouthRippleDist:int = radius*0.25;
				var ymouth:int = radius*0.3;
				
				leftEyeball.x = -radius*0.3;
				leftEyeball.y = -radius*0.3;
				rightEyeball.x = radius*0.3;
				rightEyeball.y = -radius*0.3;
				
				with(sadMouth.graphics){
					lineStyle(2, 0xFFFFFF, 1);
					moveTo(0, ymouth);
					lineTo(mouthRippleDist, ymouth + mouthH);
					lineTo(mouthRippleDist*2, ymouth);
					lineTo(mouthRippleDist*3, ymouth + mouthH);
					moveTo(0, ymouth);
					lineTo(-mouthRippleDist, ymouth + mouthH);
					lineTo(-mouthRippleDist*2, ymouth);
					lineTo(-mouthRippleDist*3, ymouth + mouthH);
				}
				
				_scaredBody = new Sprite();
				_scaredBody.addChild(scaredUpper);
				_scaredBody.addChild(scaredLowerFrame1);
				_scaredBody.addChild(scaredLowerFrame2);
				_scaredBody.addChild(leftEyeball);
				_scaredBody.addChild(rightEyeball);
				_scaredBody.addChild(sadMouth);
				
				scaredLowerFrame1.cacheAsBitmap = true;
				scaredLowerFrame2.cacheAsBitmap = true;
				
				_scaredFrames[0] = scaredLowerFrame1;
				_scaredFrames[1] = scaredLowerFrame2;
			}
			
			function createLower(shortTailW:int, longTailW:int, tailDistance:int, scared:Boolean = false):Sprite{
				var target:Sprite = new Sprite();
				var tailHeight:int = radius*0.35;
				
				with(target.graphics){
					beginFill(scared ? 0x0000FF : color, 1);
					moveTo(radius, radius);
					lineTo(radius, 0);
					lineTo(-radius, 0);
					lineTo(-radius, radius);
					lineTo(-radius + shortTailW, radius);
					lineTo(-radius + tailDistance, radius - tailHeight);
					lineTo(-radius + tailDistance + longTailW, radius);
					lineTo(-radius + tailDistance*2 + shortTailW, radius);
					lineTo(-shortTailW*0.5, radius - tailHeight);
					lineTo(shortTailW*0.5, radius - tailHeight);
					lineTo(tailDistance, radius);
					lineTo(tailDistance + longTailW, radius);
					lineTo(tailDistance*2 + shortTailW, radius - tailHeight);
					lineTo(radius - shortTailW, radius);
					endFill();
				}
				return target;
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		//================================================================== 
		// PROTECTED METHOD
		
		protected override function onEnterFrame(event:Event):void{
			super.onEnterFrame(event);
			if(_move){
				var fScaredMode:Boolean = (_mode == MODE_SCARED);
				var frames:Array = fScaredMode ? _scaredFrames : _frames;

				_body.visible = !fScaredMode;
				_scaredBody.visible = fScaredMode;
				_counter = (_counter + 1) % (Globals.FRAME_RATE/_speed*0.5);

				if(_counter == 0){
					var prevFrame:Sprite = frames[int(_frame)];
					_frame = (_frame + 1) % TOTAL_FRAMES;
					frames[int(_frame)].visible = true;
					prevFrame.visible = false;
					
				}
				
				if(_searchTurn){
					search();
				}
				
				if(!(GRID.getAdjacentTile(_currTile, _direction).boundary)){
					turn();
				}
			}
		}
		
		protected function doToggleChase(event:TimerEvent):void{
			_toggleChase = !_toggleChase;
			_mode = _toggleChase ? MODE_CHASE : MODE_SCATTER
		}
		
		protected override function stopOrTurn(faceDirection:int):void{			
			_searchTurn = true;
		}
		
		protected function search(event:TimerEvent = null):void{
			var target:Sprite = getTarget();
			if(target){
				_direction = getTargetDirection(target);
			}else{ //use random path
				try {
				_direction = getRandomDirection();
				} catch (e:Error) {
				}
			}
			
			function getTarget():Sprite{
				switch(_mode){
					case MODE_CHASE: return ENEMY; break;
					case MODE_GO_HOME: //return GRID.getTileAt(14,14); break;
					case MODE_SCARED: case MODE_SCATTER: return null; break;
					default: throw new Error("Invalid mode: " + _mode); break;
				}
			}
		}
		
		protected function getRandomDirection():int{
			var gridDirection:int = getGridDirection();
			var adjTile:Tile = GRID.getAdjacentTile(_currTile, gridDirection);
			var possible:Array = [];
			var directions:Array = [Grid.UP, Grid.LEFT, Grid.DOWN, Grid.RIGHT];
			for each(var dir:int in directions){
				if(dir != gridDirection){
					var possibleTile:Tile = GRID.getAdjacentTile(adjTile, dir);
					if(!possibleTile.boundary){
						possible.push(dir);
					}
				}
			}
			var possibleDirections:int = possible.length;
			if(possibleDirections < 1) throw new Error("Impossible");
			_searchTurn = (possible.length <= 1);
			var randomIndex:int = getRandomInt(0, possible.length-1);
			return possible[randomIndex];
		}
		
		protected function getTargetDirection(target:Sprite):int{
			var direction:int = _direction;
			var xdelta:int = target.x - this.x;
			var ydelta:int = target.y - this.y;
			
			_toggleSearch = !_toggleSearch;
			
			if(_toggleSearch){
				if(xdelta < 0){
					direction = Enum.MOVE_LEFT;
				}else{
					direction = Enum.MOVE_RIGHT;
				}
			}else{
				if(ydelta < 0){
					direction = Enum.MOVE_UP;
				}else{
					direction = Enum.MOVE_DOWN;
				}
			}
			
			if(GRID.getAdjacentTile(_currTile, direction).boundary){
				direction = getRandomDirection();
				turn();
				
			}
			_searchTurn = false;
			return direction;
		}
		
		protected function lookToMovement():void{
			var horizDir:int = 0;
			var vertDir:int = 0;
			switch(_direction){
				case Enum.MOVE_LEFT: horizDir = 1; break;
				case Enum.MOVE_RIGHT: horizDir = -1; break;
				case Enum.MOVE_UP: vertDir = 1; break;
				case Enum.MOVE_DOWN: vertDir = -1; break;
				default: throw new Error("Invalid look direction"); break;
			}
			_leftEye.x = _rightEye.x = horizDir*(_leftEye.width -_leftEye.parent.width)*0.5;
			_leftEye.y = _rightEye.y = vertDir*(_leftEye.height -_leftEye.parent.height)*0.5;
			_eyeSet.x = -horizDir*(_eyeSet.parent.width*0.1);
			_eyeSet.y = (vertDir == 1) ? 0 : -vertDir*(_eyeSet.parent.height*0.1);
		}
		
		//================================================================== 
		// SET METHODS

		public override function set vulnerable(value:Boolean):void{
			super.vulnerable = value;
			if(!_killed){
				if(_vulnerable){
					_toggleChaseTimer.stop();
					_mode = MODE_SCARED;
					_speed = Globals.GHOST_SPEED*0.5;
					_direction = (_direction+2)%4; //reverse direction
				}else{
					_toggleChaseTimer.start();
					_mode = _prevMode;
					_speed = Globals.GHOST_SPEED;
				}
			}
		}

		public function set killValue(value:int):void{
			_killValue = value;
		}

		//================================================================== 
		// GET METHODS

	}
}
