package entities;
import Data;

/**
 * ...
 * @author 01101101
 */

class Robot extends Entity {
	
	static public var FACING_UP:String = "up";
	static public var FACING_LEFT:String = "left";
	static public var FACING_DOWN:String = "down";
	static public var FACING_RIGHT:String = "right";
	public var facing(default, setFacing):String;
	
	public function new () {
		super(E_Entity.ERobot);
		
		setFacing(FACING_RIGHT);
	}
	
	override public function update () :Dynamic {
		super.update();
		
		if (Math.abs(x - xTarget) < Game.SMOOTH_CUT)	x = xTarget;
		else											x -= (x - xTarget) * Game.SMOOTH_MOD;
		if (Math.abs(y - yTarget) < Game.SMOOTH_CUT)	y = yTarget;
		else											y -= (y - yTarget) * Game.SMOOTH_MOD;
	}
	
	function setFacing (f:String) :String {
		facing = f;
		while (frames.length > 0)	frames.shift();
		for (i in 0...5)	frames.push("robot_" + facing + "_0");
		for (i in 0...5)	frames.push("robot_" + facing + "_1");
		return f;
	}
	
}
