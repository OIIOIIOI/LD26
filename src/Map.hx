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
import utils.Rand;

/**
 * ...
 * @author 01101101
 */

class Map extends Sprite {
	
	public var pixelData:MapData;
	var data:BitmapData;
	var bitmap:Bitmap;
	
	var target:IntPoint;
	public var current:IntPoint;
	
	var scrollPoint:IntPoint;
	
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
			var dir = (target.x > current.x) ? -1 : 1;
			var xTarget = (target.x > current.x) ? -Game.TILE_SIZE : Game.TILE_SIZE;
			if (Math.abs(bitmap.x - xTarget) < Game.SMOOTH_CUT) {
				bitmap.x = xTarget = 0;
				current.x = target.x;
				//drawLine(dir);
				allowRender = true;
			}
			else bitmap.x -= (bitmap.x - xTarget) * Game.SMOOTH_MOD;
		}
		
		if (target.y != current.y) {
			var dir = (target.y > current.y) ? -1 : 1;
			var yTarget = (target.y > current.y) ? -Game.TILE_SIZE : Game.TILE_SIZE;
			if (Math.abs(bitmap.y - yTarget) < Game.SMOOTH_CUT) {
				bitmap.y = yTarget = 0;
				current.y = target.y;
				//drawLine(dir);
				allowRender = true;
			}
			else bitmap.y -= (bitmap.y - yTarget) * Game.SMOOTH_MOD;
		}
		
		if (allowRender)	render(current);
	}
	
	public function render (point:IntPoint) {
		scrollPoint = point.clone();
		target = point.clone();
		current = point.clone();
		
		for (y in 0...Game.REAL_MAP_SIZE.height) {
			for (x in 0...Game.REAL_MAP_SIZE.width) {
				Game.TAP.x = x * Game.TILE_SIZE;
				Game.TAP.y = y * Game.TILE_SIZE;
				//
				var realX = scrollPoint.x + x;
				var realY = scrollPoint.y + y;
				var uid = realX * 1000 + realY;
				var gp = pixelData.getPixel;
				// Additional graph
				var t = MapData.getType(gp(realX, realY));
				switch (t) {
					//case E_Type.Ore, E_Type.Bush, E_Type.BushCut, E_Type.RockMined:
						//FM.copyFrame(data, getTile(E_Type.Ground, uid), Game.SHEET_TILES, Game.TAP);
						//FM.copyFrame(data, getTile(t,uid),Game.SHEET_TILES, Game.TAP);
					case E_Type.Rock:
						rockIDnum = 0;
						if(MapData.getType(gp(realX, realY  - 1)) == E_Type.Rock)	rockIDnum += 1;
						if(MapData.getType(gp(realX - 1, realY ))== E_Type.Rock)		rockIDnum += 8;
						if(MapData.getType(gp(realX + 1, realY ))== E_Type.Rock)		rockIDnum += 2;
						if (MapData.getType(gp(realX, realY  + 1)) == E_Type.Rock)	rockIDnum += 4;
						
						if (rockIDnum == 15) {
							if (MapData.getType(gp(realX - 1, realY - 1)) != E_Type.Rock) { rockIDnum += 1; }
							else if (MapData.getType(gp(realX + 1, realY - 1)) != E_Type.Rock) { rockIDnum += 2;}
							else if (MapData.getType(gp(realX - 1, realY + 1)) != E_Type.Rock) { rockIDnum += 3;}
							else if (MapData.getType(gp(realX + 1, realY + 1)) != E_Type.Rock) { rockIDnum += 4;}
						}
						
						FM.copyFrame(data, getTile(E_Type.Ground, uid), Game.SHEET_TILES, Game.TAP);
						FM.copyFrame(data, getTile(t), Game.SHEET_TILES, Game.TAP);
					case E_Type.Water:
						rockIDnum = 0;
						if(MapData.getType(gp(realX, realY  - 1)) == E_Type.Water)	rockIDnum += 1;
						if(MapData.getType(gp(realX - 1, realY ))== E_Type.Water)		rockIDnum += 8;
						if(MapData.getType(gp(realX + 1, realY ))== E_Type.Water)		rockIDnum += 2;
						if(MapData.getType(gp(realX, realY  + 1)) == E_Type.Water)	rockIDnum += 4;
						
						switch(rockIDnum) {
							case 10:if (MapData.getType(gp(realX + 1, realY  - 1))== E_Type.Water || MapData.getType(gp(realX + 1, realY  + 1))== E_Type.Water || MapData.getType(gp(realX - 1, realY  - 1))== E_Type.Water || MapData.getType(gp(realX - 1, realY  - 1))== E_Type.Water) {
										rockIDnum = 0;
									}
							case 2:	if (MapData.getType(gp(realX + 1, realY  - 1))== E_Type.Water || MapData.getType(gp(realX + 1, realY  + 1))== E_Type.Water) {
										rockIDnum = 0;
									}
							case 1:	if (MapData.getType(gp(realX - 1, realY  + 1)) == E_Type.Water || MapData.getType(gp(realX + 1, realY  + 1))== E_Type.Water) {
										rockIDnum = 0;
									}
							case 4:	if (MapData.getType(gp(realX - 1, realY  - 1))== E_Type.Water || MapData.getType(gp(realX + 1, realY  - 1))== E_Type.Water) {
										rockIDnum = 0;
									}
							case 8: if (MapData.getType(gp(realX - 1, realY  - 1))== E_Type.Water || MapData.getType(gp(realX - 1, realY  + 1))== E_Type.Water) {
										rockIDnum = 0;
									}
							case 15:if (MapData.getType(pixelData.getPixel(scrollPoint.x - 1 + x, realY  - 1)) != E_Type.Water) { rockIDnum += 1; }
									else if (MapData.getType(gp(realX + 1, realY  - 1)) != E_Type.Water) { rockIDnum += 2;}
									else if (MapData.getType(gp(realX - 1, realY  + 1)) != E_Type.Water) { rockIDnum += 3;}
									else if (MapData.getType(gp(realX + 1, realY  + 1)) != E_Type.Water) { rockIDnum += 4;}
						}
						FrameManager.copyFrame(data, getTile(E_Type.Ground), Game.SHEET_TILES, Game.TAP);
						FrameManager.copyFrame(data, getTile(t), Game.SHEET_TILES, Game.TAP);
						
					default:
						FM.copyFrame(data, getTile(E_Type.Ground, uid), Game.SHEET_TILES, Game.TAP);
						FM.copyFrame(data, getTile(t, uid), Game.SHEET_TILES, Game.TAP);
				}
			}
		}
		/*Game.TAP.x = (pixelData.playerStart.x - current.x) * Game.TILE_SIZE - 15;
		Game.TAP.y = (pixelData.playerStart.y - current.y) * Game.TILE_SIZE + 20;
		FM.copyFrame(data, "base", Game.SHEET_TILES, Game.TAP);*/
		bitmap.x = bitmap.y = 0;
	}
	
	static function getTile (type:E_Type, ?uid:Int) :String {
		var rand:Rand;
		if (uid != null)	rand = new Rand(uid);
		else				rand = new Rand(123456);
		return switch (type) {
			case E_Type.Ground:	"ground" + rand.random(3);
			case E_Type.GroundDug:	"dug";
			case E_Type.Rock:	"rock"+ rockIDnum;
			case E_Type.RockMined:"oreMined" + rand.random(3);
			//case E_Type.Rock:	"rock0";
			case E_Type.Ore:	"ore0";
			case E_Type.Bush:	"bush0";
			case E_Type.BushCut:"bush0Cut";
			case E_Type.Water:	"water"+ rockIDnum;
			default: "";
		}
	}
	
}
