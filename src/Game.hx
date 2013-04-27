package ;

import anim.FrameManager;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Resource;
import utils.IntPoint;
import utils.IntRect;
import utils.Rand;

/**
 * ...
 * @author 01101101
 */

@:bitmap("bin/tiles.png") class TilesBD extends flash.display.BitmapData { }

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
		MAP_SIZE = new IntRect(0, 0, 64, 64);
		TILE_SIZE = 40;
		REAL_MAP_SIZE = new IntRect(0, 0, Std.int(SIZE.width / TILE_SIZE) + 4, Std.int(SIZE.height / TILE_SIZE) + 4);
		RAND = new Rand(1239874560);
		
		FrameManager.store("tiles", new TilesBD(0, 0), Resource.getString("tilesJson"));
		
		//Data.init();
		
		var mapData = new MapData(3586);
		map = new Map(mapData);
		
		var ox = Std.int((MAP_SIZE.width - REAL_MAP_SIZE.width) / 2);
		var oy = Std.int((MAP_SIZE.height - REAL_MAP_SIZE.height) / 2);
		map.render(new IntPoint(ox, oy));
		addChild(map);
		
		var bd:Bitmap = new Bitmap(mapData);
		bd.alpha = 0.7;
		bd.scaleX = bd.scaleY = 4;
		bd.x = Game.SIZE.width - bd.width;
		addChild(bd);
		
		//addEventListener(Event.ENTER_FRAME, update);
		
		/*var bd = FrameManager.getFrame("ground", "tiles");
		trace(bd);
		addChild(new Bitmap());*/
	}
	
	private function update (e:Event) {
		map.scroll(-4);
	}
	
}
















