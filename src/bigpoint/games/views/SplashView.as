//
//  SplashView
//
//  Created by Harry Kunz on 2010-12-05.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.views{
	
	import bigpoint.games.events.GameEvent;
	import bigpoint.games.Enum;
	import bigpoint.games.Globals;
	import bigpoint.games.resources.SoundEffect;
	import bigpoint.games.views.View;

	import com.hkunz.components.Button;
	import com.hkunz.core.CoreDispatcher;
	import com.hkunz.core.Factory;
	import com.hkunz.display.utils.createRect;
	import com.hkunz.events.ButtonEvent;
	import com.hkunz.log.Log;
	import com.hkunz.text.Text;

	import flash.display.Sprite;

	public class SplashView extends View{

		//================================================================== 
		// PUBLIC PROPERTIES

		//================================================================== 
		// PRIVATE PROPERTIES

		//================================================================== 
		// CONSTRUCTOR

		public function SplashView(){
			initialise();
			render();
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public override function destroy():void{
			super.destroy();
		}
		
		//================================================================== 
		// PROTECTED METHODS

		protected function initialise():void{
			
		}

		protected override function render():void{
			super.render();
			
			addChild(createRect(Globals.STAGE_WIDTH, Globals.STAGE_HEIGHT, {fillColor:0}));
			
			var strokeAlpha:Number = 0.2;
			var thick:int = 2;
			var buttonWidth:uint = 200;
			var buttonHeight:uint = 70;
			var radius:int = 10;
			var upState:Sprite = createRect(buttonWidth, buttonHeight, {radius:radius, fillColor:0x888888, fillAlpha:1, strokeThickness:thick, strokeColor:0xFFFFFF, strokeAlpha:strokeAlpha});
			var overState:Sprite = createRect(buttonWidth, buttonHeight, {radius:radius, fillColor:0x777777, fillAlpha:1, strokeThickness:thick, strokeColor:0xFFFFFF, strokeAlpha:strokeAlpha});
			var downState:Sprite = createRect(buttonWidth, buttonHeight, {radius:radius, fillColor:0x333333, fillAlpha:1, strokeThickness:thick, strokeColor:0xFFFFFF, strokeAlpha:strokeAlpha});
			var disableState:Sprite = createRect(buttonWidth, buttonHeight, {radius:radius, fillColor:0xCCCCCC, fillAlpha:0.4, strokeThickness:thick, strokeColor:0xFFFFFF, strokeAlpha:strokeAlpha});
			var hitArea:Sprite = createRect(buttonWidth, buttonHeight, {radius:radius, fillColor:0});
			
			var creatorText:Text = Factory.create(Text, {text:"Harry Kunz", autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0xFFFF00, size:18});
			var playButtonText:Text = Factory.create(Text, {text:"PLAY", autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0xFFFFFF, size:30});
			
			var playButton:Button = new Button(upState, downState, overState, disableState, hitArea);
			
			playButtonText.x = (buttonWidth - playButtonText.width)*0.5;
			playButtonText.y = (buttonHeight - playButtonText.height)*0.5;
			
			playButton.x = (Globals.STAGE_WIDTH - playButton.width)*0.5;
			playButton.y = (Globals.STAGE_HEIGHT - playButton.height)*0.5;
			
			creatorText.x = (Globals.STAGE_WIDTH - creatorText.width)*0.5;
			creatorText.y = playButton.y + playButton.height + 10;
			
			playButton.addChild(playButtonText);
			
			playButton.addEventListener(ButtonEvent.RELEASE, function(event:ButtonEvent):void{
				playButton.removeEventListener(ButtonEvent.RELEASE, arguments.callee);
				var gameEvent:GameEvent = new GameEvent(GameEvent.NAVIGATE);
				gameEvent.value = Enum.VIEW_GAMESTAGE;
				CoreDispatcher.dispatchEvent(gameEvent);
				SoundEffect.play(SoundEffect.GHOST_KILL);
			});
			
			playButton.addEventListener(ButtonEvent.PRESS, function(event:ButtonEvent):void{
				SoundEffect.play(SoundEffect.PELLET);
			});
			
			addChild(playButton);
			addChild(creatorText);
		}

		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		//================================================================== 
		// GET METHODS

	}
}