package ;
import flash.display.BitmapData;
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
	
	static var RAND:Rand;
	
	public function new (seed:Int) {
		
		super(Game.MAP_SIZE.width, Game.MAP_SIZE.height, false);
		
		RAND = new Rand(seed);
		
		for (r in Data.MAP_RESOURCES) {
			switch (r) {
				case E_Type.Ore(c):
					for (i in 0...c)	spawnOre();
				case E_Type.Rock(c):
					for (i in 0...c)	spawnRock();
				default:
					spawnDefault(r);
			}
		}
	}
	
	public function spawnDefault (type:E_Type) {
		var color = getColor(type);
		
		var x = RAND.random(width);
		var y = RAND.random(height);
		
		var safety:Int = 50;
		while (getPixel(x, y) != C_GROUND && safety > 0) {
			x = RAND.random(width);
			y = RAND.random(height);
			safety--;
		}
		if (safety == 0) return;
		
		setPixel(x, y, color);
	}
	
	public function spawnRock () {
		spawnDefault(E_Type.Rock(0));
	}
	
	public function spawnOre () {
		var color = getColor(E_Type.Ore);
	}
	
	static function getColor (type:E_Type) : UInt {
		return switch (type) {
			case E_Type.Ground:		C_GROUND;
			case E_Type.Rock(c):	C_ROCK;
			case E_Type.Ore(c):		C_ORE;
		}
	}
	
}
