package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;
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
	
	public function new () {
		super();
		
		SIZE = new IntRect(0, 0, 600, 600);
		MAP_SIZE = new IntRect(0, 0, 32, 32);
		TILE_SIZE = 40;
		REAL_MAP_SIZE = new IntRect(0, 0, (SIZE.width / TILE_SIZE) + 4, (SIZE.height / TILE_SIZE) + 4);
		RAND = new Rand(1239874560);
		
		//Data.init();
		
		/*var bd:Bitmap = new Bitmap(new MapData(0));
		bd.scaleX = bd.scaleY = 8;
		addChild(bd);*/
		
		var map:Map = new Map(new MapData(3586));
		map.render(new IntRect(0, 0));
		addChild(map);
	}
	
}
















