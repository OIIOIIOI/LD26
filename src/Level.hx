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
import SoundManager;
import ui.Fx;
import ui.MainUI;
import utils.DepthManager;
import utils.FTimer;
import utils.IntPoint;

/**
 * ...
 * @author 01101101
 */

class Level extends Sprite {
	
	static public inline var MAP_DEPTH = 0;
	static public inline var ENTITIES_DEPTH = 10;
	static public inline var PLAYER_DEPTH = 20;
	static public inline var FX_DEPTH = 30;
	static var DEPTHS = [MAP_DEPTH, ENTITIES_DEPTH, PLAYER_DEPTH, FX_DEPTH];
	var dm:DepthManager;
	var fx:Fx;
	
	var entities:Array<Entity>;
	
	var container:Sprite;
	var map:Map;
	
	public var robot:Robot;
	var robotCenter:IntPoint;
	
	var scrollFloat:Point;
	
	var UI:MainUI;
	
	static public var me:Level;
	
	public function new () {
		super();
		
		if (me != null)	throw new Error("nope");
		me = this;
		
		ActionManager.init();
		
		container = new Sprite();
		addChild(container);
		
		UI = new MainUI();
		addChild(UI);
		
		dm = new DepthManager(container);
		for (i in DEPTHS) {
			var p = dm.getPlan(i);
		}
		fx = new Fx(dm);
		
		scrollFloat = new Point();
		
		var mapData = new MapData(Game.RAND.random(99999));
		//var mapData = new MapData(4019);
		
		/*var minimap = new Bitmap(mapData);
		minimap.scaleX = minimap.scaleY = 2;
		minimap.x = Game.SIZE.width - mapData.width;
		minimap.y = Game.SIZE.height - mapData.height;
		dm.add(minimap, FX_DEPTH);*/
		
		container.x = (Game.SIZE.width / Game.TILE_SIZE - Game.REAL_MAP_SIZE.width) / 2 * Game.TILE_SIZE;
		container.y = (Game.SIZE.height / Game.TILE_SIZE - Game.REAL_MAP_SIZE.height) / 2 * Game.TILE_SIZE;
		
		entities = new Array<Entity>();
		
		map = new Map(mapData);
		dm.add(map, MAP_DEPTH);
		
		robot = new Robot();
		//entities.push(robot);
		/*robotCenter = mapData.playerStart.clone();
		robotCenter.x = Std.int(Game.REAL_MAP_SIZE.width / 2) * Game.TILE_SIZE;
		robotCenter.y = Std.int(Game.REAL_MAP_SIZE.height / 2) * Game.TILE_SIZE;
		robot.x = robot.xTarget = 9 * Game.TILE_SIZE;
		robot.y = robot.yTarget = 9 * Game.TILE_SIZE;*/
		
		map.render(new IntPoint(map.pixelData.playerStart.x - 9, map.pixelData.playerStart.y - 9));
	}
	
	public function fakeStart () {
		FTimer.delay(spawnRobot, 30);
	}
	
	public function start () {
		EventManager.instance.addEventListener(GE.SND_TICK, nextTurn);
		//FTimer.delay(nextTurn, 12);
	}
	
	public function update () {
		/*for (e in entities) {
			e.update();
		}*/
		robot.update();
		map.update();
		fx.update();
	}
	
	function nextTurn (e:GameEvent) {
		if (!ActionManager.isStillRunning()) {
			autoDestruct();
			return;
		}
		
		if (!SoundManager.me.delayed) {
			//Fx.instance.text("yeah!", 0xD9995F, 20, robot.x, robot.y);
			
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
				case E_Action.ASwim:
					switch (robot.facing) {
						case Robot.FACING_LEFT:		sx = 1;
						case Robot.FACING_RIGHT:	sx = 1;
						case Robot.FACING_UP:		sy = 1;
						case Robot.FACING_DOWN:		sy = 1;
					}
				case E_Action.ADig:
					if (MapData.getType(map.pixelData.getPixel(rxt, ryt)) != E_Type.Ground)
						a.discard();
					else {
						map.pixelData.setPixel(rxt, ryt, MapData.getColor(E_Type.GroundDug));
						map.render(map.current);
						SoundManager.me.queueSound(SM.SND_DIG);
						var gold = 101 + Std.random(9);
						MainUI.me.gold += gold;
						Fx.instance.text("+" + gold, 0xD9995F, 20, robot.x, robot.y);
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
						SoundManager.me.queueSound(SM.SND_MINE);
						var gold = 501 + Std.random(19);
						MainUI.me.gold += gold;
						Fx.instance.text("+" + gold, 0xD9995F, 20, robot.x, robot.y);
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
						SoundManager.me.queueSound(SM.SND_SAW);
						var gold = 251 + Std.random(9);
						MainUI.me.gold += gold;
						Fx.instance.text("+" + gold, 0xD9995F, 20, robot.x, robot.y);
					}
				default:
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
			
		}
		//else SoundManager.me.delayed = false;
		
		//SoundManager.me.tick++;
		//FTimer.delay(nextTurn, Game.TURN_DELAY);
	}
	
	function moveRobot (p:IntPoint) :IntPoint {
		var rxt = Std.int(robot.xTarget / Game.TILE_SIZE) + p.x + map.current.x;
		var ryt = Std.int(robot.yTarget / Game.TILE_SIZE) + p.y + map.current.y;
		
		var tileType = MapData.getType(map.pixelData.getPixel(rxt, ryt));
		switch (tileType) {
			case E_Type.Ore:
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
			case E_Type.Base:
				if (p.x == 1)		ActionManager.insertAction(E_Action.ARight(1), true);
				else if (p.x == -1)	ActionManager.insertAction(E_Action.ALeft(1), true);
				else if (p.y == -1)	ActionManager.insertAction(E_Action.AUp(1), true);
				else if (p.y == 1)	ActionManager.insertAction(E_Action.ADown(1), true);
			/*case E_Type.Water:
				if (ActionManager.canSwim) {
					if (p.x == 1)		ActionManager.insertAction(E_Action.ARight(1), false);
					else if (p.x == -1)	ActionManager.insertAction(E_Action.ALeft(1), false);
					else if (p.y == -1)	ActionManager.insertAction(E_Action.AUp(1), false);
					else if (p.y == 1)	ActionManager.insertAction(E_Action.ADown(1), false);
					ActionManager.insertAction(E_Action.ASwim);
				}*/
				//return null;
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
	
	public function getTypeUnderRobot () :E_Type {
		var rxt = Std.int(robot.xTarget / Game.TILE_SIZE) + map.current.x;
		var ryt = Std.int(robot.yTarget / Game.TILE_SIZE) + map.current.y;
		var t = MapData.getType(map.pixelData.getPixel(rxt, ryt));
		return t;
	}
	
	public function autoDestruct (step:Int = 0) {
		switch (step) {
			case 0:
				EventManager.instance.removeEventListener(GE.SND_TICK, nextTurn);
				robot.autoDestruct();
				FTimer.delay(callback(autoDestruct, 1), 90);
			case 1:
				container.removeChild(robot);
				FTimer.delay(spawnRobot, 30);
		}
	}
	
	function spawnRobot () {
		robot.facing = Robot.FACING_DOWN;
		robotCenter = map.pixelData.playerStart.clone();
		robotCenter.x = Std.int(Game.REAL_MAP_SIZE.width / 2) * Game.TILE_SIZE;
		robotCenter.y = Std.int(Game.REAL_MAP_SIZE.height / 2) * Game.TILE_SIZE;
		robot.x = robot.xTarget = 9 * Game.TILE_SIZE;
		robot.y = robot.yTarget = 9 * Game.TILE_SIZE;
		dm.add(robot, PLAYER_DEPTH);
		
		map.render(new IntPoint(map.pixelData.playerStart.x - 9, map.pixelData.playerStart.y - 9));
		
		if (Game.me.currentState != Game.me.prepaState)	Game.me.selectState(Game.me.prepaState);
		
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
















