package ;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Point;
import Math;
import utils.IntPoint;
import utils.Rand;
import Data;

/**
 * ...
 * @author 01101101
 */

class MapData extends BitmapData {
	
	static public var C_GROUND:UInt =	0xFFFFFF;
	static public var C_GROUNDDUG:UInt =0xEEEEEE;
	static public var C_ROCK:UInt =		0x000000;
	static public var C_ROCKMINED:UInt =0x111111;
	static public var C_ORE:UInt =		0xFF0000;
	static public var C_BUSH:UInt =		0x00FF00;
	static public var C_BUSHCUT:UInt =	0x00DD00;
	static public var C_WATER:UInt =	0x0000FF;
	static public var C_BASE:UInt =		0xFF00FF;
	
	static var RAND:Rand;
	public var perlmap:BitmapData;
	public var rockperlmap:BitmapData;
	public var waterperlmap:BitmapData;
	public var bushperlmap :BitmapData;
	var seed:Int;
	
	public var playerStart:IntPoint;
	
	public function new (seed:Int) {
		super(Game.MAP_SIZE.width, Game.MAP_SIZE.height, false);
		
		this.seed = seed;
		RAND = new Rand(seed);
		trace(seed);
		
		perlmap = new BitmapData(Game.MAP_SIZE.width, Game.MAP_SIZE.height, false);
		perlmap.perlinNoise(perlmap.width/5, perlmap.height/5, 1, seed,false, true, 7, true);
		perlmap.threshold(perlmap, perlmap.rect, new Point(), "<=", 0xFF808080,0xFF000000);
		perlmap.threshold(perlmap, perlmap.rect, new Point(), ">", 0xFF808080, 0x00FFFFFF);
		
		rockperlmap = new BitmapData(Game.MAP_SIZE.width, Game.MAP_SIZE.height, true);
		rockperlmap.perlinNoise(10, 10, 1, RAND.random(50000000), false, true, 7, true);
		waterperlmap = rockperlmap.clone();
		
		bushperlmap = new BitmapData(Game.MAP_SIZE.width, Game.MAP_SIZE.height, true);
		bushperlmap.perlinNoise(bushperlmap.width /4, bushperlmap.height /4, 1, RAND.random(50000000), false, true, 7, true);
		bushperlmap.threshold(bushperlmap, bushperlmap.rect, new Point(), "<=", 0xFF808080,0xFF000000);
		bushperlmap.threshold(bushperlmap, bushperlmap.rect, new Point(), ">", 0xFF808080, 0xFFFFFFFF);
		
		spawnRock();
		spawnWater();
		
		var surface = Game.MAP_SIZE.width * Game.MAP_SIZE.height;
		//for (i in 0...Std.int(surface * 0.007))	spawnOre();
		for (i in 0...Std.int(surface * 0.07))	spawnBush();
		
		var mapCenter:IntPoint = new IntPoint(Std.int(Game.MAP_SIZE.width / 2), Std.int(Game.MAP_SIZE.height / 2));
		playerStart = mapCenter.clone();
		var base:Shape = new Shape();
		base.graphics.beginFill(C_GROUND);
		base.graphics.drawCircle(playerStart.x, playerStart.y, 4);
		base.graphics.endFill();
		draw(base);
		/*var safety:Int = 100;
		while (getPixel(playerStart.x, playerStart.y) != C_GROUND && safety > 0) {
			playerStart.x = mapCenter.x + RAND.random(17) - 8;
			playerStart.y = mapCenter.y + RAND.random(17) - 8;
			safety--;
		}
		if (safety == 0) return;*/
		//setPixel(playerStart.x, playerStart.y, 0xFFFF00CC);
		/*Game.TAR.x = playerStart.x - 1;
		Game.TAR.y = playerStart.y;
		Game.TAR.width = 3;
		Game.TAR.height = 2;
		fillRect(Game.TAR, C_BASE);*/
	}
	
	public function spawnDefault (type:E_Type,perlcon:Bool,perlconBW:UInt){
		var color = getColor(type);
		var x = RAND.random(width);
		var y = RAND.random(height);
		
		if(perlcon){
			var safety:Int = 500;
			while ((getPixel(x, y) != C_GROUND || perlmap.getPixel(x, y) != perlconBW) && safety > 0) {
				x = RAND.random(width);
				y = RAND.random(height);
				safety--;
			}
			if (safety == 0) return;
		}else {
			var safety:Int = 50;
			while (getPixel(x, y) != C_GROUND && safety > 0) {
				x = RAND.random(width);
				y = RAND.random(height);
				safety--;
			}
			if (safety == 0) return;
		}
		setPixel(x, y, color);
	}
	
	public function spawnWater () {
		var t = 0xFFB0B0B0;
		waterperlmap.threshold(waterperlmap, waterperlmap.rect, new Point(), "<", t, 0x00FFFFFF);
		waterperlmap.threshold(waterperlmap, waterperlmap.rect, new Point(), ">=", t,0xFF000000+C_WATER);
		draw(waterperlmap);
	}
	
	public function spawnRock () {
		var t = 0xFF6E6E6E;
		rockperlmap.threshold(rockperlmap, rockperlmap.rect, new Point(), "<=", t,0xFF000000+C_ROCK);
		rockperlmap.threshold(rockperlmap, rockperlmap.rect, new Point(), ">", t, 0x00FFFFFF);
		draw(rockperlmap);
	}
	
	public function spawnBush () {
		var x = RAND.random(width);
		var y = RAND.random(height);
		var safety:Int = 500;
			while ((getPixel(x, y) != C_GROUND || bushperlmap.getPixel(x, y) != 0) && safety > 0) {
				x = RAND.random(width);
				y = RAND.random(height);
				safety--;
			}
		if (safety == 0) return;
		setPixel(x, y, C_BUSH);
	}
	
	public function spawnOre () {
		//var color = getColor(E_Type.Ore);
		spawnDefault(E_Type.Ore,false,0);
	}
	
	static public function getColor (type:E_Type) : UInt {
		return switch (type) {
			case E_Type.Ground:	C_GROUND;
			case E_Type.GroundDug:	C_GROUNDDUG;
			case E_Type.Rock:	C_ROCK;
			case E_Type.RockMined:	C_ROCKMINED;
			case E_Type.Ore:	C_ORE;
			case E_Type.Bush:	C_BUSH;
			case E_Type.BushCut:C_BUSHCUT;
			case E_Type.Water:	C_WATER;
			case E_Type.Base:	C_BASE;
		}
	}
	
	static public function getType (color:UInt) :E_Type {
		return switch (color) {
			case C_BASE:	E_Type.Base;
			case C_ROCK:	E_Type.Rock;
			case C_ROCKMINED:	E_Type.RockMined;
			case C_ORE:		E_Type.Ore;
			case C_BUSH:	E_Type.Bush;
			case C_BUSHCUT:	E_Type.BushCut;
			case C_WATER:	E_Type.Water;
			case C_GROUNDDUG:	E_Type.GroundDug;
			default:	E_Type.Ground;
		}
	}
	
}
