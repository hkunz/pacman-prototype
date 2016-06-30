//
//  Tile
//
//  Created by Harry Kunz on 2010-12-04.
//  Copyright (c) 2010 hkunz. All rights reserved.
//

package bigpoint.games.ui{

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Tile extends Sprite{

		//================================================================== 
		// PUBLIC PROPERTIES

		//================================================================== 
		// PROTECTED PROPERTIES

		protected var _itemType:int;
		protected var _item:Sprite;
		protected var _index:int;
		protected var _boundary:Boolean;
		protected var _containsItem:Boolean;
		
		//================================================================== 
		// CONSTRUCTOR

		public function Tile(){
			_boundary = false;
			_containsItem = false;
		}

		//================================================================== 
		// PUBLIC METHODS
		
		public override function addChild(child:DisplayObject):DisplayObject{
			if(this.numChildren >= 1){
				throw new Error(this.name + ": Cannot have more than 1 item");
			}
			_item = super.addChild(child) as Sprite;
			return _item;
		}
		
		public function removeItem():void{
			if(_item && !_boundary){
				super.removeChild(_item);
				_item = null
			}
		}
		
		//================================================================== 
		// PROTECTED METHODS

		//================================================================== 
		// PRIVATE METHODS

		//================================================================== 
		// SET METHODS

		public function set itemType(value:int):void{
			_itemType = value;
		}

		public function set index(value:int):void{
			_index = value;
		}

		public function set boundary(value:Boolean):void{
			_boundary = value;
		}
		
		//================================================================== 
		// GET METHODS
		
		public function get itemType():int{
			return _itemType;
		}
		
		public function get index():int{
			return _index;
		}
		
		public function get boundary():Boolean{
			return _boundary;
		}
	}
}