package ;
import flash.display.BitmapData;
import flash.geom.Point;
import Math;
import utils.Rand;
import Data;

/**
 * ...
 * @author 01101101
 */

class MapData extends BitmapData {
	
	static public var C_GROUND:UInt =	0xFFFFFF;
	static public var C_ROCK:UInt =		0x000000;
	static public var C_ORE:UInt =		0xFF0000;
	static public var C_BUSH:UInt =		0x00FF00;
	static public var C_RIFT:UInt =		0x0000FF;
	
	static var RAND:Rand;
	public var perlmap:BitmapData;
	public var rockperlmap:BitmapData;
	public var riftperlmap:BitmapData;
	public var bushperlmap :BitmapData;
	var seed:Int;
	
	public function new (seed:Int) {
		
		super(Game.MAP_SIZE.width, Game.MAP_SIZE.height, false);
		this.seed = seed;
		RAND = new Rand(seed);
		
		perlmap = new BitmapData(Game.MAP_SIZE.width, Game.MAP_SIZE.height, false);
		perlmap.perlinNoise(perlmap.width/5, perlmap.height/5, 1, seed,false, true, 7, true);
		perlmap.threshold(perlmap, perlmap.rect, new Point(), "<=", 0xFF808080,0xFF000000);
		perlmap.threshold(perlmap, perlmap.rect, new Point(), ">", 0xFF808080, 0x00FFFFFF);
		
		rockperlmap = new BitmapData(Game.MAP_SIZE.width, Game.MAP_SIZE.height, true);
		rockperlmap.perlinNoise(10, 10, 1, RAND.random(50000000), false, true, 7, true);
		riftperlmap = rockperlmap.clone();
		
		
		bushperlmap = new BitmapData(Game.MAP_SIZE.width, Game.MAP_SIZE.height, true);
		bushperlmap.perlinNoise(bushperlmap.width /4, bushperlmap.height /4, 1, RAND.random(50000000), false, true, 7, true);
		bushperlmap.threshold(bushperlmap, bushperlmap.rect, new Point(), "<=", 0xFF808080,0xFF000000);
		bushperlmap.threshold(bushperlmap, bushperlmap.rect, new Point(), ">", 0xFF808080, 0xFFFFFFFF);
			
		spawnRock();
		spawnRift();
		
		var surface = Game.MAP_SIZE.width * Game.MAP_SIZE.height;
		for (i in 0...Std.int(surface*0.005))	spawnOre();
		for (i in 0...Std.int(surface*0.03))	spawnBush();
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
	
	public function spawnRift () {
		
		riftperlmap.threshold(riftperlmap, riftperlmap.rect, new Point(), "<", 0xFFB0B0B0, 0x00FFFFFF);
		riftperlmap.threshold(riftperlmap, riftperlmap.rect, new Point(), ">=", 0xFFB0B0B0,0xFF000000+C_RIFT);
		draw(riftperlmap);
	}
	
	public function spawnRock () {
		rockperlmap.threshold(rockperlmap, rockperlmap.rect, new Point(), "<=", 0xFF606060,0xFF000000+C_ROCK);
		rockperlmap.threshold(rockperlmap, rockperlmap.rect, new Point(), ">", 0xFF606060, 0x00FFFFFF);
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
	
	static function getColor (type:E_Type) : UInt {
		return switch (type) {
			case E_Type.Ground:	C_GROUND;
			case E_Type.Rock:	C_ROCK;
			case E_Type.Ore:	C_ORE;
			case E_Type.Bush:	C_BUSH;
			case E_Type.Rift:	C_RIFT;
		}
	}
	
	static public function getType (color:UInt) :E_Type {
		return switch (color) {
			case C_ROCK:	E_Type.Rock;
			case C_ORE:		E_Type.Ore;
			case C_BUSH:	E_Type.Bush;
			case C_RIFT:	E_Type.Rift;
			default:	E_Type.Ground;
		}
	}
	
}
