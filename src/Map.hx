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
	
	var target:IntPoint;
	var current:IntPoint;
	
	var scrollPoint:IntPoint;
	//var scrollFloat:Point;
	
	static var rockIDnum :Int;
	
	public function new (pixelData:MapData) {
		super();
		
		this.pixelData = pixelData;
		
		data = new BitmapData(Game.REAL_MAP_SIZE.width * Game.TILE_SIZE, Game.REAL_MAP_SIZE.height * Game.TILE_SIZE, false);
		bitmap = new Bitmap(data);
		addChild(bitmap);
		
		target = new IntPoint();
		current = new IntPoint();
		
		rockIDnum = 0;
	}
	
	public function scroll (p:IntPoint) :IntPoint {
		if (current.x + p.x >= 0 && current.x + p.x < pixelData.width - Game.REAL_MAP_SIZE.width) {
			target.x = current.x + p.x;
			p.x = 0;
		}
		if (current.y + p.y >= 0 && current.y + p.y < pixelData.height - Game.REAL_MAP_SIZE.height) {
			target.y = current.y + p.y;
			p.y = 0;
		}
		return p;
	}
	
	public function update () {
		var allowRender = false;
		
		if (target.x != current.x) {
			var xTarget = (target.x > current.x) ? -Game.TILE_SIZE : Game.TILE_SIZE;
			if (Math.abs(bitmap.x - xTarget) < Game.SMOOTH_CUT) {
				bitmap.x = xTarget;
				current.x = target.x;
				allowRender = true;
			}
			else bitmap.x -= (bitmap.x - xTarget) * Game.SMOOTH_MOD;
		}
		
		if (target.y != current.y) {
			var yTarget = (target.y > current.y) ? -Game.TILE_SIZE : Game.TILE_SIZE;
			if (Math.abs(bitmap.y - yTarget) < Game.SMOOTH_CUT) {
				bitmap.y = yTarget;
				current.y = target.y;
				allowRender = true;
			}
			else bitmap.y -= (bitmap.y - yTarget) * Game.SMOOTH_MOD;
		}
		
		if (allowRender)	render(current);
		
		/*if (target.x != current.x || target.y != current.y) {
			current.x = target.x;
			current.y = target.y;
			render(current);
		}*/
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
					case E_Type.Ore, E_Type.Bush:
						FrameManager.copyFrame(data, getTile(E_Type.Ground), Game.SHEET_TILES, Game.TAP);
						FrameManager.copyFrame(data, getTile(t), Game.SHEET_TILES, Game.TAP);
					case E_Type.Rock:
						rockIDnum = 0;
						if(MapData.getType(pixelData.getPixel(scrollPoint.x + x, scrollPoint.y + y - 1)) == E_Type.Rock)	rockIDnum += 1;
						if(MapData.getType(pixelData.getPixel(scrollPoint.x + x - 1, scrollPoint.y + y))== E_Type.Rock)		rockIDnum += 8;	
						if(MapData.getType(pixelData.getPixel(scrollPoint.x + x + 1, scrollPoint.y + y))== E_Type.Rock)		rockIDnum += 2;
						if (MapData.getType(pixelData.getPixel(scrollPoint.x + x, scrollPoint.y + y + 1)) == E_Type.Rock)		rockIDnum += 4;
						
						if (rockIDnum == 15) {
							if (MapData.getType(pixelData.getPixel(scrollPoint.x - 1 + x, scrollPoint.y + y - 1)) != E_Type.Rock) { rockIDnum += 1; }
							else if (MapData.getType(pixelData.getPixel(scrollPoint.x + x + 1, scrollPoint.y + y - 1)) != E_Type.Rock) { rockIDnum += 2;}
							else if (MapData.getType(pixelData.getPixel(scrollPoint.x + x - 1, scrollPoint.y + y + 1)) != E_Type.Rock) { rockIDnum += 3;}
							else if (MapData.getType(pixelData.getPixel(scrollPoint.x + x + 1, scrollPoint.y + y + 1)) != E_Type.Rock) { rockIDnum += 4;}
						}
						
						FrameManager.copyFrame(data, getTile(E_Type.Ground), Game.SHEET_TILES, Game.TAP);
						FrameManager.copyFrame(data, getTile(t), Game.SHEET_TILES, Game.TAP);
						
					case E_Type.Rift:
						FrameManager.copyFrame(data, getTile(t), Game.SHEET_TILES, Game.TAP);
					default:
						FrameManager.copyFrame(data, getTile(E_Type.Ground), Game.SHEET_TILES, Game.TAP);
				}
			}
		}
		bitmap.x = bitmap.y = 0;
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
			case E_Type.Ground:	"ground" + Std.random(3);
			case E_Type.Rock:	"rock"+ rockIDnum;
			case E_Type.Ore:	"ore0";
			case E_Type.Bush:	"bush0";
			case E_Type.Rift:	"water0";
			default: "";
		}
	}
	
}
