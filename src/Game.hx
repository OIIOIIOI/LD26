package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import utils.IntPoint;
import utils.IntRect;
import utils.Rand;

/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	static public var SIZE:IntRect;
	static public var MAP_SIZE:IntRect;
	static public var REAL_MAP_SIZE:IntRect;
	static public var TILE_SIZE:Int;
	static public var RAND:Rand;
	static public var TAP:Point = new Point();
	static public var TAR:Rectangle = new Rectangle();
	
	var map:Map;
	
	public function new () {
		super();
		
		SIZE = new IntRect(0, 0, 600, 600);
		MAP_SIZE = new IntRect(0, 0, 32, 32);
		TILE_SIZE = 40;
		REAL_MAP_SIZE = new IntRect(0, 0, Std.int(SIZE.width / TILE_SIZE) + 4, Std.int(SIZE.height / TILE_SIZE) + 4);
		RAND = new Rand(1239874560);
		
		//Data.init();
		
		var mapData = new MapData(3586);
		map = new Map(mapData);
		
		var ox = Std.int((MAP_SIZE.width - REAL_MAP_SIZE.width) / 2);
		var oy = Std.int((MAP_SIZE.height - REAL_MAP_SIZE.height) / 2);
		map.render(new IntPoint(ox, oy));
		addChild(map);
		
		/*var bd:Bitmap = new Bitmap(mapData);
		bd.alpha = 0.5;
		bd.scaleX = bd.scaleY = 6;
		bd.x = Game.SIZE.width - bd.width;
		addChild(bd);*/
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update (e:Event) {
		map.scroll(-4.1, 8);
	}
	
}
















