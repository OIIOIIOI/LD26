package ;

import anim.Animation;
import Data;
import entities.Entity;
import entities.Robot;
import events.EventManager;
import events.GameEvent;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.Event;
import flash.geom.Point;
import flash.ui.Keyboard;
import utils.DepthManager;
import utils.FTimer;
import utils.IntPoint;

/**
 * ...
 * @author 01101101
 */

class Level extends Sprite {
	
	static inline var MAP_DEPTH = 0;
	static inline var ENTITIES_DEPTH = 10;
	static inline var PLAYER_DEPTH = 20;
	static inline var FX_DEPTH = 30;
	static var DEPTHS = [MAP_DEPTH, ENTITIES_DEPTH, PLAYER_DEPTH, FX_DEPTH];
	var dm:DepthManager;
	
	var entities:Array<Entity>;
	
	var container:Sprite;
	var map:Map;
	var robot:Robot;
	var robotCenter:IntPoint;
	
	var scrollFloat:Point;
	
	static public var me:Level;
	
	public function new () {
		super();
		
		if (me != null)	throw new Error("nope");
		me = this;
		
		ActionManager.init();
		
		container = new Sprite();
		//container.x = (Game.SIZE.width - Game.REAL_MAP_SIZE.width * Game.TILE_SIZE) / 2;
		//container.y = (Game.SIZE.height - Game.REAL_MAP_SIZE.height * Game.TILE_SIZE) / 2;
		addChild(container);
		
		dm = new DepthManager(container);
		for (i in DEPTHS) {
			var p = dm.getPlan(i);
		}
		
		scrollFloat = new Point();
		
		var mapData = new MapData(1986);
		
		var minimap = new Bitmap(mapData);
		minimap.x = Game.SIZE.width - mapData.width;
		minimap.y = Game.SIZE.height - mapData.height;
		minimap.scaleX = minimap.scaleY = 2;
		dm.add(minimap, FX_DEPTH);
		
		container.x = (Game.SIZE.width / Game.TILE_SIZE - Game.REAL_MAP_SIZE.width) / 2 * Game.TILE_SIZE;
		container.y = (Game.SIZE.height / Game.TILE_SIZE - Game.REAL_MAP_SIZE.height) / 2 * Game.TILE_SIZE;
		
		map = new Map(mapData);
		map.render(new IntPoint(25, 25));
		dm.add(map, MAP_DEPTH);
		
		entities = new Array<Entity>();
		
		robot = new Robot();
		robotCenter = new IntPoint();
		robot.x = robot.xTarget = robotCenter.x = Std.int(Game.REAL_MAP_SIZE.width / 2) * Game.TILE_SIZE;
		robot.y = robot.yTarget = robotCenter.y = Std.int(Game.REAL_MAP_SIZE.height / 2) * Game.TILE_SIZE;
		entities.push(robot);
		dm.add(robot, PLAYER_DEPTH);
		
		//EventManager.me.addEventListener(GE.SPAWN_ENTITY, eventHandler);
		
		FTimer.delay(nextTurn, 12);
	}
	
	public function update () {
		for (e in entities) {
			e.update();
		}
		map.update();
	}
	
	function moveRobot (p:IntPoint) :IntPoint {
		var rxt = Std.int(robot.xTarget / Game.TILE_SIZE) + p.x + map.current.x;
		var ryt = Std.int(robot.yTarget / Game.TILE_SIZE) + p.y + map.current.y;
		
		var tileType = MapData.getType(map.pixelData.getPixel(rxt, ryt));
		switch (tileType) {
			case E_Type.Rock:
				map.pixelData.setPixel(rxt, ryt, MapData.getColor(E_Type.RockMined));
			case E_Type.Ore, E_Type.Rift:
				return new IntPoint();
			case E_Type.Bush:
				map.pixelData.setPixel(rxt, ryt, MapData.getColor(E_Type.BushCut));
			default:
		}
		
		if (p.x != 0 && robot.xTarget != robotCenter.x) {
			var newPosX:Float = robot.xTarget + p.x * Game.TILE_SIZE;
			newPosX = Math.max(-container.x, newPosX);
			newPosX = Math.min((Game.REAL_MAP_SIZE.width - 1) * Game.TILE_SIZE + container.x, newPosX);
			if (newPosX != robot.xTarget) {
				robot.xTarget = Std.int(newPosX);
				p.x = 0;
			}
		}
		if (p.y != 0 && robot.yTarget != robotCenter.y) {
			var newPosY:Float = robot.yTarget + p.y * Game.TILE_SIZE;
			newPosY = Math.max(-container.y, newPosY);
			newPosY = Math.min((Game.REAL_MAP_SIZE.height - 1) * Game.TILE_SIZE + container.y, newPosY);
			if (newPosY != robot.yTarget) {
				robot.yTarget = Std.int(newPosY);
				p.y = 0;
			}
		}
		return p;
	}
	
	function nextTurn () {
		
		var sx = 0;
		var sy = 0;
		if (KeyboardManager.isDown(Keyboard.RIGHT)) {
			robot.facing = Robot.FACING_RIGHT;
			sx += 1;
		}
		else if (KeyboardManager.isDown(Keyboard.LEFT)) {
			robot.facing = Robot.FACING_LEFT;
			sx -= 1;
		}
		if (KeyboardManager.isDown(Keyboard.UP)) {
			robot.facing = Robot.FACING_UP;
			sy -= 1;
		}
		else if (KeyboardManager.isDown(Keyboard.DOWN)) {
			robot.facing = Robot.FACING_DOWN;
			sy += 1;
		}
		
		if (sx != 0 || sy != 0) {
			// Place the robot back in the center if possible
			var p = moveRobot(new IntPoint(sx, sy));
			// Scroll the map if possible
			if (p.x != 0 || p.y != 0) {
				p = map.scroll(p);
			} else {
				map.render(map.current);
			}
			// If there still is scroll left, move the robot
			if (p.x != 0) {
				var newPosX:Float = robot.xTarget + p.x * Game.TILE_SIZE;
				newPosX = Math.max(-container.x, newPosX);
				newPosX = Math.min((Game.REAL_MAP_SIZE.width - 1) * Game.TILE_SIZE + container.x, newPosX);
				if (newPosX != robot.xTarget) {
					robot.xTarget = Std.int(newPosX);
				}
			}
			if (p.y != 0) {
				var newPosY:Float = robot.yTarget + p.y * Game.TILE_SIZE;
				newPosY = Math.max(-container.y, newPosY);
				newPosY = Math.min((Game.REAL_MAP_SIZE.height - 1) * Game.TILE_SIZE + container.y, newPosY);
				if (newPosY != robot.yTarget) {
					robot.yTarget = Std.int(newPosY);
				}
			}
		}
		FTimer.delay(nextTurn, Game.TURN_DELAY);
	}
	
	/*function eventHandler (e:GameEvent) {
		switch (e.type) {
			case GE.SPAWN_ENTITY:
				//trace("spawnEntity");
		}
	}*/
	
}
















