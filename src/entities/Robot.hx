package entities;
import anim.FrameManager;
import Data;
import SoundManager;

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
	
	//var sndFrame:Int;
	
	public function new () {
		super(E_Entity.ERobot);
		setFacing(FACING_RIGHT);
	}
	
	override public function update () :Dynamic {
		super.update();
		//if (sndFrame != -1 && curFrame == sndFrame) trace("play sound");
		
		if (Math.abs(x - xTarget) < Game.SMOOTH_CUT)	x = xTarget;
		else											x -= (x - xTarget) * Game.SMOOTH_MOD;
		if (Math.abs(y - yTarget) < Game.SMOOTH_CUT)	y = yTarget;
		else											y -= (y - yTarget) * Game.SMOOTH_MOD;
		
		var t = Level.me.getTypeUnderRobot();
		if (t == E_Type.Water && SoundManager.me.currentTheme != SoundManager.TRK_WATER)
			SoundManager.me.selectTrack(SoundManager.TRK_WATER);
		else if (t != E_Type.Water && SoundManager.me.currentTheme == SoundManager.TRK_WATER)
			SoundManager.me.selectTrack(SoundManager.TRK_EXPLO);
	}
	
	function setFacing (f:String) :String {
		//sndFrame = -1;
		facing = f;
		while (frames.length > 0)	frames.shift();
		for (i in 0...5)	frames.push("robot_" + facing + "_0");
		for (i in 0...5)	frames.push("robot_" + facing + "_1");
		return f;
	}
	
	public function autoDestruct () {
		SoundManager.me.queueSound(SM.SND_DEAD);
		
		while (frames.length > 0)	frames.shift();
		for (i in 0...3)	frames.push("robot_up_0");
		for (i in 0...3)	frames.push("robot_left_0");
		for (i in 0...3)	frames.push("robot_right_0");
		for (i in 0...3)	frames.push("robot_up_0");
		for (i in 0...3)	frames.push("robot_down_0");
		for (i in 0...3)	frames.push("robot_right_0");
		for (i in 0...3)	frames.push("robot_down_0");
		for (i in 0...3)	frames.push("robot_left_0");
		for (i in 0...3)	frames.push("robot_down_0");
		for (i in 0...3)	frames.push("robot_up_0");
		for (i in 0...3)	frames.push("robot_left_0");
		for (i in 0...3)	frames.push("robot_right_0");
		for (i in 0...3)	frames.push("robot_up_0");
		for (i in 0...3)	frames.push("robot_down_0");
		//sndFrame = frames.length;
		for (i in 0...3)	frames.push("boom0");
		for (i in 0...6)	frames.push("boom1");
		for (i in 0...6)	frames.push("boom2");
		for (i in 0...6)	frames.push("boom3");
		for (i in 0...4)	frames.push("boom4");
		for (i in 0...6)	frames.push("boom3");
		for (i in 0...4)	frames.push("boom4");
		for (i in 0...6)	frames.push("boom3");
		for (i in 0...4)	frames.push("boom4");
		for (i in 0...6)	frames.push("boom3");
		for (i in 0...60)	frames.push("boom4");
	}
	
}
