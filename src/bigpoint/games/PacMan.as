//
//  PacMan
//
//  Created by Harry Kunz on 2010-12-03.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

/*
References: http://home.comcast.net/~jpittman2/pacman/pacmandossier.html
			http://www.gamedev.net/reference/articles/article2003.asp
			http://mochiland.com/articles/flash-game-developer-tutorial-pathfinding-with-dijkstras-algorithm
			http://www.lemlinh.com/how-to-design-and-code-for-a-flash-game/
Game:		http://www.classicgaming.cc/classics/pacman/play.php
*/


package bigpoint.games{
	
	import bigpoint.games.Globals;
	import bigpoint.games.Enum;
	import bigpoint.games.events.GameEvent;
	import bigpoint.games.resources.SoundEffect;
	import bigpoint.games.views.GameStageView;
	import bigpoint.games.views.SplashView;
	import bigpoint.games.views.View;
	
	import com.hkunz.core.App;
	import com.hkunz.core.Factory;
	import com.hkunz.core.CoreDispatcher;
	import com.hkunz.core.KeyboardHandler;
	import com.hkunz.display.utils.createSimpleRect;
	import com.hkunz.events.LoadEvent;
	import com.hkunz.log.Log;
	import com.hkunz.net.JSONLoader;
	import com.hkunz.text.Text;
	import com.hkunz.utils.delay;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.Font;
	
	public class PacMan extends App{

		//================================================================== 
		// PUBLIC PROPERTIES
		
		//================================================================== 
		// PROTECTED PROPERTIES
		
		//"MAC OSX" System Font:
		//[Embed(source="/Library/Fonts/Arial Rounded Bold.ttf", fontName="FontArialRoundedBold", mimeType="application/x-font-truetype", unicodeRange="U+0020,U+0041-U+005A,U+0020,U+0061-U+007A,U+0030-U+0039,U+002E,U+0020-U+002F,U+003A-U+0040,U+005B-U+0060,U+007B-U+007E")]
		//public static const ArialRoundedBold:Class;
		
		protected var _container:Sprite;
		protected var _mapData:Object;
		protected var _currentView:View;
		
		//================================================================== 
		// CONSTRUCTOR

		public function PacMan(){
			super();
			_render = false;
		}
		
		//================================================================== 
		// PUBLIC METHODS

		//================================================================== 
		// PROTECTED METHODS

		protected override function initialise():void{
			super.initialise();
			
			//Text.FONT_NAME = new ArialRoundedBold().fontName;
			//Font.registerFont(ArialRoundedBold);
			
			var self:Object = this;
			var loadString:String = "Loading Map...";
			var loadMapText:Text;
			
			KeyboardHandler.initialise(this.stage);
			Globals.initialise(this.stage);
			SoundEffect.initialise();
			
			prerender();
			
			CoreDispatcher.addEventListener(GameEvent.NAVIGATE, function(event:GameEvent):void{
				navigateToView(event.value);
			});
			
			var mapLoader:JSONLoader = new JSONLoader("maps/map0001.json");
			mapLoader.addEventListener(LoadEvent.COMPLETE, function(event:LoadEvent):void{
				mapLoader.removeEventListener(LoadEvent.COMPLETE, arguments.callee);
				_mapData = mapLoader.data;
				delay(50, function():void{
					render();
				});
			});
			mapLoader.addEventListener(LoadEvent.PROGRESS, function(event:LoadEvent):void{
				var perc:Number = event.value;
				loadMapText.text = loadString + Math.floor(perc*100) + "%";
				if(perc >= 1.0){
					mapLoader.removeEventListener(LoadEvent.PROGRESS, arguments.callee);
				}
			});
			mapLoader.load();
			
			function prerender():void{
				addChild(createSimpleRect(_width, _height, 0x000000)); //partial render just background
				loadMapText = Factory.create(Text, {text:loadString + "0%", autoSize:Text.AUTOSIZE_LEFT, multiline:false, wordWrap:false, color:0x00FF00, size:14});
				loadMapText.x = 10; //(405 - loadMapText.width)*0.5;
				loadMapText.y = 10; //(540 - loadMapText.height)*0.5;
				self.addChild(loadMapText);
			}
		}

		protected override function render():void{
			super.render();
			_container = new Sprite();
			navigateToView(Enum.VIEW_SPASH);
			addChild(_container);
		}

		protected function navigateToView(view:int):void{
			
			if(_currentView){
				_container.removeChild(_currentView);
				_currentView = null;
			}
			
			switch(view){
				case Enum.VIEW_SPASH:
					_currentView = new SplashView();
					_container.addChild(_currentView);
					break;
				case Enum.VIEW_GAMESTAGE:
					_currentView = new GameStageView(_mapData);
					_container.addChild(_currentView);
					break;
				default:
					throw new Error("Invalid view: " + view);
					break;
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
