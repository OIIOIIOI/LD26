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
		
		for (i in 0...50)	spawnOre();
		for (i in 0...20)	spawnDefault(E_Type.Rock);
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
		spawnDefault(E_Type.Rock);
	}
	
	public function spawnOre () {
		//var color = getColor(E_Type.Ore);
		spawnDefault(E_Type.Ore);
	}
	
	static function getColor (type:E_Type) : UInt {
		return switch (type) {
			case E_Type.Ground:		C_GROUND;
			case E_Type.Rock:	C_ROCK;
			case E_Type.Ore:		C_ORE;
		}
	}
	
}
