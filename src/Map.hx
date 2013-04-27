package ;

import anim.FrameManager;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import utils.IntPoint;
import utils.IntRect;
import Data;

/**
 * ...
 * @author 01101101
 */

class Map extends Sprite {
	
	var pixelData:BitmapData;
	var data:BitmapData;
	
	public function new (pixelData:MapData) {
		this.pixelData = pixelData;
		data = new BitmapData(Game.REAL_MAP_SIZE.width * Game.TILE_SIZE, Game.REAL_MAP_SIZE.height * Game.TILE_SIZE, false);
	}
	
	public function render (point:IntPoint) {
		Game.TAR.x = point.x;
		Game.TAR.y = point.y;
		Game.TAR.height = Game.REAL_MAP_SIZE.width;
		Game.TAR.width = Game.REAL_MAP_SIZE.height;
		Game.TAP.x = Game.TAP.y = 0;
		var tbd:BitmapData = new BitmapData(Game.REAL_MAP_SIZE.width, Game.REAL_MAP_SIZE.height, false);
		tbd.copyPixels(pixelData, Game.TAR, Game.TAP);
		var m = new Matrix();
		m.scale(Game.TILE_SIZE, Game.TILE_SIZE);
		data.draw(tbd, m);
	}
	
	function paintEntity (frame:String, x:Int, y:Int) {
		//FrameManager.();
	}
	
	static function getTile (type:E_Type) :String {
		return switch (type) {
			case E_Type.Ground:	"ground";
			case E_Type.Rock:	"rock";
			case E_Type.Ore:	"ore";
		}
	}
	
}
