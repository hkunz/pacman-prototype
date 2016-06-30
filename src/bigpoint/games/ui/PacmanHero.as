//
//  Protagonist
//
//  Created by Harry Kunz on 2010-12-03.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.ui{
	
	import bigpoint.games.Enum;
	import bigpoint.games.events.GameEvent;
	import bigpoint.games.Globals;
	import bigpoint.games.resources.SoundEffect;
	import bigpoint.games.ui.Creature;
	import bigpoint.games.ui.GhostEnemy;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quart;
	import com.greensock.events.TweenEvent;
	
	import com.hkunz.core.CoreDispatcher;
	import com.hkunz.display.Polygon;
	import com.hkunz.display.utils.getBitmap;
	import com.hkunz.display.utils.createSimpleCircle;
	import com.hkunz.log.Log;
	import com.hkunz.utils.delay;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	final public class PacmanHero extends Creature{

		//================================================================== 
		// PUBLIC PROPERTIES

		public static const TOTAL_FRAMES:int = 4;
		public static const REVOLUTION:int = 360;
		public static const ONE_SECOND:int = 1000;
		
		public static var ENEMIES:Array; //Array of type Creature
		
		//================================================================== 
		// PROTECTED PROPERTIES

		protected var _chewFrames:Array;
		protected var _chewTimer:Timer;
		
		//================================================================== 
		// CONSTRUCTOR

		public function PacmanHero(){
			initialise();
			render();
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public override function destroy():void{
			super.destroy();
			_chewTimer.removeEventListener(TimerEvent.TIMER, onChewTimer);
		}
		
		public override function startMove():void{
			super.startMove();
			_chewTimer.start();
		}

		public override function stopMove(reset:Boolean = true):void{ //reset = false is for pausing
			super.stopMove(reset);
			_chewTimer.stop();
			if(reset){
				var frame:int = _frame;
				_frame = 1;
				_chewFrames[_frame].visible = true;
				if(_frame != frame){
					_chewFrames[frame].visible = false;
				}
			}
		}
		
		public override function turn():void{
			super.turn();
			this.rotation = _rotation;
		}
		
		public override function kill():void{
			super.kill();
			stopMove(false);
			var self:Object = this;
			var pFrame:Polygon = _chewFrames[_frame];
			var decrements:int = 0;
			var explode1:Sprite = createSimpleCircle(pFrame.width, 0xFFFF00, 1);
			var explode2:Sprite = createSimpleCircle(pFrame.width, 0xFFFF00, 1);
			delay(1000, function():void{
				SoundEffect.play(SoundEffect.PAKMAN_KILLED);
				self.addEventListener(Event.ENTER_FRAME, function(event:Event):void{
					pFrame.endAngle -= 4;
					pFrame.startAngle += 4;
					decrements += 4;
					if(decrements > 180){
						pFrame.visible = false;
						self.removeEventListener(Event.ENTER_FRAME, arguments.callee);
						explode1.alpha = explode2.alpha = 0.7;
						explode1.scaleX = explode2.scaleX = 0;
						explode1.scaleY = explode2.scaleY = 0;
						TweenLite.to(explode1, 0.6, {delay:0.3, ease:Quart.easeOut, alpha:0, scaleX:1, scaleY:1, onComplete:function():void{self.removeChild(explode1)}});
						TweenLite.to(explode2, 0.6, {delay:0.5, ease:Quart.easeOut, alpha:0, scaleX:1, scaleY:1, onComplete:function():void{self.removeChild(explode2)}});
						self.addChild(explode1);
						self.addChild(explode2);
						delay(1000, function():void{
							CoreDispatcher.dispatchEvent(new GameEvent(GameEvent.RESTART));
						});
					}
				});
			});
		}

		public function getImage():Bitmap{
			var copy:Sprite = _chewFrames[0];
			return getBitmap(copy); //copies bitmap
		}
		
		//================================================================== 
		// PROTECTED METHODS
		
		protected override function initialise():void{
			super.initialise();
			var speed:int = Globals.PACMAN_SPEED;
			_vulnerable = true;
			_direction = Enum.MOVE_LEFT;
			_chewFrames = [];
			_chewTimer = new Timer(int(ONE_SECOND / (speed * TOTAL_FRAMES))*2);
			_chewTimer.addEventListener(TimerEvent.TIMER, onChewTimer);
			turn();
		}
		
		protected function render():void{
			var radius:int = Globals.PACMAN_RADIUS * Globals.SCALE;
			var angle:int = 80;
			var mouthAngle:int = angle;
			var mouthAngleInc:int = mouthAngle / (TOTAL_FRAMES*0.5);
			
			for(var n:int = 0; n < TOTAL_FRAMES; n++){
				var scaleDelta:Number = mouthAngle/angle*0.1;
				var pframe:Sprite = createFrame(mouthAngle, 1+scaleDelta, 1-scaleDelta*0.5);
				mouthAngle -= mouthAngleInc - 2; //2 to prevent close circle
				_chewFrames[n] = pframe;
				pframe.cacheAsBitmap = true;
				addChild(pframe);
			}
			
			updateChew();
			
			function createFrame(angle:int, scaleX:Number = 1, scaleY:Number = 1):Sprite{
				var halfAngle:int = angle*0.5;
				var frame:Sprite = new Polygon(30, radius, {x:0, y:5, fillColor:0xFFFF00, startAngle:halfAngle, endAngle:REVOLUTION - halfAngle});
				frame.scaleX = scaleX;
				frame.scaleY = scaleY;
				frame.visible = false;
				return frame;
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		protected override function onEnterFrame(event:Event):void{
			super.onEnterFrame(event);
			if(_move){
				CoreDispatcher.dispatchEvent(new GameEvent(GameEvent.PACMAN_MOVE));
			}
		}

		protected function onChewTimer(event:TimerEvent = null):void{
			var prevFrame:Sprite = _chewFrames[_frame];
			_frame = (_frame + 1) % TOTAL_FRAMES;
			updateChew();
			prevFrame.visible = false;
		}
		
		protected function updateChew():void{
			_chewFrames[_frame].visible = true;
		}
		
		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		//================================================================== 
		// GET METHODS
		
	}
}