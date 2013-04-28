package entities;
import Data;

/**
 * ...
 * @author 01101101
 */

class Robot extends Entity {
	
	public function new () {
		super(E_Entity.ERobot);
		
		for (i in 0...5)	frames.push("robot_right_0");
		for (i in 0...5)	frames.push("robot_right_1");
	}
	
	override public function update () :Dynamic {
		super.update();
		
		if (Math.abs(x - xTarget) < Game.SMOOTH_CUT)	x = xTarget;
		else								x -= (x - xTarget) * Game.SMOOTH_MOD;
		if (Math.abs(y - yTarget) < Game.SMOOTH_CUT)	y = yTarget;
		else								y -= (y - yTarget) * Game.SMOOTH_MOD;
	}
	
}
