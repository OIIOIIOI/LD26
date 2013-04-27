package ;

import anim.FrameManager;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
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
	var bitmap:Bitmap;
	
	var origin:IntPoint;
	var scrollPoint:IntPoint;
	var scrollFloat:Point;
	
	public function new (pixelData:MapData) {
		super();
		
		this.pixelData = pixelData;
		
		data = new BitmapData(Game.REAL_MAP_SIZE.width * Game.TILE_SIZE, Game.REAL_MAP_SIZE.height * Game.TILE_SIZE, false);
		bitmap = new Bitmap(data);
		addChild(bitmap);
		
		origin = new IntPoint();
		//bitmap.x = origin.x = Std.int((Game.SIZE.width - data.width) / 2);
		//bitmap.y = origin.y = Std.int((Game.SIZE.height - data.height) / 2);
		
		scrollFloat = new Point();
	}
	
	public function scroll (x:Float = 0, y:Float = 0) {
		// HORIZONTAL
		if (bitmap.x < 0 && bitmap.x + bitmap.width > Game.SIZE.width) {
			scrollFloat.x += x;
			while (scrollFloat.x >= 1) {
				bitmap.x++;
				scrollFloat.x--;
			}
			while (scrollFloat.x <= -1) {
				bitmap.x--;
				scrollFloat.x++;
			}
			if (scrollPoint.x != 0 && scrollPoint.x + Game.REAL_MAP_SIZE.width != Game.MAP_SIZE.width) {
				while (bitmap.x - origin.x > Game.TILE_SIZE) {
					bitmap.x -= Game.TILE_SIZE;
					data.scroll(Game.TILE_SIZE, 0);
					scrollPoint.x = scrollPoint.x - 1;
					drawLine(1);
				}
				while (origin.x - bitmap.x > Game.TILE_SIZE) {
					bitmap.x += Game.TILE_SIZE;
					data.scroll(-Game.TILE_SIZE, 0);
					scrollPoint.x = scrollPoint.x + 1;
					drawLine(-1);
				}
			}
		}
		// VERTICAL
		if (bitmap.y < 0 && bitmap.y + bitmap.height > Game.SIZE.height) {
			scrollFloat.y += y;
			while (scrollFloat.y >= 1) {
				bitmap.y++;
				scrollFloat.y--;
			}
			while (scrollFloat.y <= -1) {
				bitmap.y--;
				scrollFloat.y++;
			}
			if (scrollPoint.y != 0 && scrollPoint.y + Game.REAL_MAP_SIZE.height != Game.MAP_SIZE.height) {
				while (bitmap.y - origin.y > Game.TILE_SIZE) {
					bitmap.y -= Game.TILE_SIZE;
					data.scroll(0, Game.TILE_SIZE);
					scrollPoint.y = scrollPoint.y - 1;
					drawLine(0, 1);
				}
				while (origin.y - bitmap.y > Game.TILE_SIZE) {
					bitmap.y += Game.TILE_SIZE;
					data.scroll(0, -Game.TILE_SIZE);
					scrollPoint.y = scrollPoint.y + 1;
					drawLine(0, -1);
				}
			}
		}
	}
	
	function drawLine (h:Int = 0, v:Int = 0) {
		if (h != 0) {
			Game.TAR.x = Game.TAR.y = 0;
			Game.TAR.width = Game.TILE_SIZE;
			Game.TAR.height = Game.REAL_MAP_SIZE.height * Game.TILE_SIZE;
			var m = new Matrix();
			m.translate(-scrollPoint.x, -scrollPoint.y);
			m.scale(Game.TILE_SIZE, Game.TILE_SIZE);
			data.draw(pixelData, m);
		}
		if (v != 0) {
			Game.TAR.x = Game.TAR.y = 0;
			Game.TAR.width = Game.REAL_MAP_SIZE.width * Game.TILE_SIZE;
			Game.TAR.height = Game.TILE_SIZE;
			var m = new Matrix();
			m.translate(-scrollPoint.x, -scrollPoint.y);
			m.scale(Game.TILE_SIZE, Game.TILE_SIZE);
			data.draw(pixelData, m);
		}
	}
	
	public function render (point:IntPoint) {
		scrollPoint = point.clone();
		for (y in 0...Game.REAL_MAP_SIZE.height) {
			for (x in 0...Game.REAL_MAP_SIZE.width) {
				Game.TAP.x = x * Game.TILE_SIZE;
				Game.TAP.y = y * Game.TILE_SIZE;
				// Additional graph
				var t = MapData.getType(pixelData.getPixel(scrollPoint.x + x, scrollPoint.y + y));
				switch (t) {
					case E_Type.Ore, E_Type.Rock, E_Type.Bush:
						FrameManager.copyFrame(data, getTile(E_Type.Ground), "tiles", Game.TAP);
						FrameManager.copyFrame(data, getTile(t), "tiles", Game.TAP);
					case E_Type.Rift:
						FrameManager.copyFrame(data, getTile(t), "tiles", Game.TAP);
					default:
						FrameManager.copyFrame(data, getTile(E_Type.Ground), "tiles", Game.TAP);
				}
			}
		}
	}
	
	/*public function render (point:IntPoint) {
		scrollPoint = point.clone();
		Game.TAR.x = Game.TAR.y = 0;
		Game.TAR.height = Game.REAL_MAP_SIZE.width * Game.TILE_SIZE;
		Game.TAR.width = Game.REAL_MAP_SIZE.height * Game.TILE_SIZE;
		var m = new Matrix();
		m.translate(-scrollPoint.x, -scrollPoint.y);
		m.scale(Game.TILE_SIZE, Game.TILE_SIZE);
		data.draw(pixelData, m);
	}*/
	
	/*function paintEntity (frame:String, x:Int, y:Int) {
		//FrameManager.();
	}*/
	
	static function getTile (type:E_Type) :String {
		return switch (type) {
			case E_Type.Ground:	"ground";
			case E_Type.Rock:	"rock";
			case E_Type.Ore:	"ore";
			case E_Type.Bush:	"bush";
			case E_Type.Rift:	"rift";
			default: "";
		}
	}
	
}
