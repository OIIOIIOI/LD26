package ;

import ActionManager;
import anim.Animation;
import anim.FrameManager;
import Data;
import entities.Entity;
import entities.Robot;
import events.EventManager;
import events.GameEvent;
import flash.display.Bitmap;
import flash.display.BlendMode;
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
		addChild(container);
		
		dm = new DepthManager(container);
		for (i in DEPTHS) {
			var p = dm.getPlan(i);
		}
		
		scrollFloat = new Point();
		
		var mapData = new MapData(987456);
		
		var minimap = new Bitmap(mapData);
		minimap.x = Game.SIZE.width - mapData.width * 2;
		minimap.y = Game.SIZE.height - mapData.height * 2;
		minimap.scaleX = minimap.scaleY = 2;
		dm.add(minimap, FX_DEPTH);
		
		container.x = (Game.SIZE.width / Game.TILE_SIZE - Game.REAL_MAP_SIZE.width) / 2 * Game.TILE_SIZE;
		container.y = (Game.SIZE.height / Game.TILE_SIZE - Game.REAL_MAP_SIZE.height) / 2 * Game.TILE_SIZE;
		
		entities = new Array<Entity>();
		
		map = new Map(mapData);
		dm.add(map, MAP_DEPTH);
		
		robot = new Robot();
		robotCenter = mapData.playerStart.clone();
		robotCenter.x = Std.int(Game.REAL_MAP_SIZE.width / 2) * Game.TILE_SIZE;
		robotCenter.y = Std.int(Game.REAL_MAP_SIZE.height / 2) * Game.TILE_SIZE;
		robot.x = robot.xTarget = 9 * Game.TILE_SIZE;
		robot.y = robot.yTarget = 9 * Game.TILE_SIZE;
		entities.push(robot);
		dm.add(robot, PLAYER_DEPTH);
		
		map.render(new IntPoint(mapData.playerStart.x - 9, mapData.playerStart.y - 9));
	}
	
	public function start () {
		//EventManager.instance.addEventListener(GE.PAINT_ENTITY, eventHandler);
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
			case E_Type.Ore, E_Type.Rift:
				return null;
			case E_Type.Rock:
				if (ActionManager.canMine) {
					if (p.x == 1)		ActionManager.insertAction(E_Action.ARight(1), false);
					else if (p.x == -1)	ActionManager.insertAction(E_Action.ALeft(1), false);
					else if (p.y == -1)	ActionManager.insertAction(E_Action.AUp(1), false);
					else if (p.y == 1)	ActionManager.insertAction(E_Action.ADown(1), false);
					ActionManager.insertAction(E_Action.AMine);
				}
				return null;
			case E_Type.Bush:
				if (ActionManager.canSaw) {
					if (p.x == 1)		ActionManager.insertAction(E_Action.ARight(1), false);
					else if (p.x == -1)	ActionManager.insertAction(E_Action.ALeft(1), false);
					else if (p.y == -1)	ActionManager.insertAction(E_Action.AUp(1), false);
					else if (p.y == 1)	ActionManager.insertAction(E_Action.ADown(1), false);
					ActionManager.insertAction(E_Action.ASaw);
				}
				return null;
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
			else return null;
		}
		if (p.y != 0 && robot.yTarget != robotCenter.y) {
			var newPosY:Float = robot.yTarget + p.y * Game.TILE_SIZE;
			newPosY = Math.max(-container.y, newPosY);
			newPosY = Math.min((Game.REAL_MAP_SIZE.height - 1) * Game.TILE_SIZE + container.y, newPosY);
			if (newPosY != robot.yTarget) {
				robot.yTarget = Std.int(newPosY);
				p.y = 0;
			}
			else return null;
		}
		return p;
	}
	
	function nextTurn () {
		//trace("next turn");
		if (!ActionManager.isStillRunning()) {
			autoDestruct();
			return;
		}
		
		var rxt = Std.int(robot.xTarget / Game.TILE_SIZE) + map.current.x;
		var ryt = Std.int(robot.yTarget / Game.TILE_SIZE) + map.current.y;
		var sx = 0;
		var sy = 0;
		
		var a = ActionManager.nextAction;
		if (a == null)	autoDestruct();
		switch (a.type) {
			case E_Action.ARight(n):
				robot.facing = Robot.FACING_RIGHT;
				sx += 1;
			case E_Action.ALeft(n):
				robot.facing = Robot.FACING_LEFT;
				sx -= 1;
			case E_Action.AUp(n):
				robot.facing = Robot.FACING_UP;
				sy -= 1;
			case E_Action.ADown(n):
				robot.facing = Robot.FACING_DOWN;
				sy += 1;
			case E_Action.ADig:
				if (MapData.getType(map.pixelData.getPixel(rxt, ryt)) != E_Type.Ground)
					a.discard();
				else {
					map.pixelData.setPixel(rxt, ryt, MapData.getColor(E_Type.GroundDug));
					map.render(map.current);
				}
			case E_Action.AMine:
				switch (robot.facing) {
					case Robot.FACING_LEFT:		rxt -= 1;
					case Robot.FACING_RIGHT:	rxt += 1;
					case Robot.FACING_UP:		ryt -= 1;
					case Robot.FACING_DOWN:		ryt += 1;
				}
				if (MapData.getType(map.pixelData.getPixel(rxt, ryt)) != E_Type.Rock)
					a.discard();
				else {
					map.pixelData.setPixel(rxt, ryt, MapData.getColor(E_Type.RockMined));
					map.render(map.current);
				}
			case E_Action.ASaw:
				switch (robot.facing) {
					case Robot.FACING_LEFT:		rxt -= 1;
					case Robot.FACING_RIGHT:	rxt += 1;
					case Robot.FACING_UP:		ryt -= 1;
					case Robot.FACING_DOWN:		ryt += 1;
				}
				if (MapData.getType(map.pixelData.getPixel(rxt, ryt)) != E_Type.Bush)
					a.discard();
				else {
					map.pixelData.setPixel(rxt, ryt, MapData.getColor(E_Type.BushCut));
					map.render(map.current);
				}
		}
		
		if (sx != 0 || sy != 0) {
			// Place the robot back in the center if possible
			var p = moveRobot(new IntPoint(sx, sy));
			// null means the action was not possible and must be discarded
			if (p == null)	a.discard(false);
			else {
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
		}
		FTimer.delay(nextTurn, Game.TURN_DELAY);
	}
	
	function autoDestruct () {
		robot.autoDestruct();
	}
	
	/*function eventHandler (e:GameEvent) {
		switch (e.type) {
			case GameEvent.PAINT_ENTITY:
				Game.TAP.x = data.x;
				Game.TAP.y = data.y;
				FrameManager.copyFrame(map.pixelData, data.f, Game.SHEET_ROAD, Game.TAP, true, false, data.b);
		}
	}*/
	
}
















