package ;

import anim.FrameManager;
import cards.Card;
import cards.Deck;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Resource;
import utils.FTimer;
import utils.IntPoint;
import utils.IntRect;
import utils.Rand;

/**
 * ...
 * @author 01101101
 */

@:bitmap("bin/tiles.png") class TilesBD extends flash.display.BitmapData { }

class Game extends Sprite {
	
	static public var SHEET_TILES:String = "sheet_tiles";
	
	static public var SIZE:IntRect = new IntRect(0, 0, 600, 600);
	static public var MAP_SIZE:IntRect = new IntRect(0, 0, 64, 64);
	static public var REAL_MAP_SIZE:IntRect;
	static public var TILE_SIZE:Int = 40;
	static public var TURN_DELAY:Int = 10;
	static public var SMOOTH_MOD:Float = 0.6;
	static public var SMOOTH_CUT:Float = 0.3;
	static public var RAND:Rand;
	static public var TAP:Point = new Point();
	static public var TAR:Rectangle = new Rectangle();
	
	static public var tick:Int;
	
	var level:Level;
	
	//static public var testBitmap:Bitmap;
	
	/*var gamedeck:Deck;
	var chosenCard: Card;*/
	
	var map:Map;
	
	public function new () {
		super();
		
		REAL_MAP_SIZE = new IntRect(0, 0, Std.int(SIZE.width / TILE_SIZE) + 4, Std.int(SIZE.height / TILE_SIZE) + 4);
		RAND = new Rand(1239874560);
		
		tick = 0;
		
		FrameManager.store(SHEET_TILES, new TilesBD(0, 0), Resource.getString("tilesJson"));
		
		//Data.init();
		
		level = new Level();
		addChild(level);
		
		addEventListener(Event.ENTER_FRAME, update);
		
		/*gamedeck = new Deck();
		chosenCard = gamedeck.getCard(3);
		trace(chosenCard.type);*/
	}
	
	private function update (e:Event) {
		tick++;
		FTimer.update();
		level.update();
	}
	
}
















