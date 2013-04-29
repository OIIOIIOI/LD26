package ;

import anim.FrameManager;
import cards.CardStack;
import Data;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Resource;
import ui.ExploState;
import ui.PrepaState;
import ui.State;
import ui.TitleState;
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
	static public var me:Game;
	
	public var currentState:State;
	
	public var titleState:TitleState;
	public var prepaState:PrepaState;
	public var exploState:ExploState;
	
	public var rank:Int;
	
	public var deck:CardStack;
	
	public function new () {
		super();
		
		me = this;
		
		REAL_MAP_SIZE = new IntRect(0, 0, Std.int(SIZE.width / TILE_SIZE) + 4, Std.int(SIZE.height / TILE_SIZE) + 4);
		RAND = new Rand(Std.random(99999999));
		
		FrameManager.store(SHEET_TILES, new TilesBD(0, 0), Resource.getString("tilesJson"));
		
		rank = 0;
		
		new Level();
		new SoundManager();
		
		deck = new CardStack(E_CardStackType.deck);
		
		SoundManager.me.start();
		SoundManager.me.selectTrack();
		
		titleState = new TitleState();
		prepaState = new PrepaState();
		exploState = new ExploState();
		
		selectState(titleState);
		
		tick = 0;
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	public function selectState (state:State) {
		if (currentState != null) {
			currentState.deactivate();
			removeChild(currentState);
		}
		currentState = state;
		currentState.activate();
		addChild(currentState);
	}
	
	private function update (e:Event) {
		tick++;
		FTimer.update();
		currentState.update();
	}
	
}
















