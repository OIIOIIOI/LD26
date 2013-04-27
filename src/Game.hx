package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import utils.IntRect;
import utils.Rand;

/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	static public var SIZE:IntRect;
	static public var MAP_SIZE:IntRect;
	static public var RAND:Rand;
	
	public function new () {
		super();
		
		SIZE = new IntRect(0, 0, 600, 600);
		MAP_SIZE = new IntRect(0, 0, 32, 32);
		RAND = new Rand(1239874560);
		
		Data.init();
		
		var bd:Bitmap = new Bitmap(new MapData(0));
		bd.scaleX = bd.scaleY = 8;
		addChild(bd);
	}
	
}
