package entities;
import anim.Animation;
import anim.FrameManager;
import Data;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;

/**
 * ...
 * @author 01101101
 */

class Entity extends Sprite {
	
	var type:E_Entity;
	
	public var xTarget:Int;
	public var yTarget:Int;
	
	var w:Int;
	var h:Int;
	
	var curFrame:Int;
	var frames:Array<String>;
	var bd:BitmapData;
	var b:Bitmap;
	
	var shadow:Shape;
	
	public function new (type:E_Entity) {
		super();
		
		this.type = type;
		
		w = h = 40;
		
		frames = new Array();
	}
	
	public function update () {
		if (bd == null)	initGraphics();
		else {
			curFrame++;
			if (curFrame >= frames.length)	curFrame = 0;
			FrameManager.getFrameOpt(bd, frames[curFrame], Game.SHEET_TILES);
		}
	}
	
	public function initGraphics () {
		shadow = new Shape();
		shadow.graphics.beginFill(0x000000, 0.2);
		shadow.graphics.drawEllipse(0, 33, 40, 14);
		shadow.graphics.endFill();
		addChild(shadow);
		//
		bd = new BitmapData(w, h, true, 0x33FF00FF);
		b = new Bitmap(bd);
		if (frames.length > 0) {
			curFrame = 0;
			FrameManager.getFrameOpt(bd, frames[curFrame], Game.SHEET_TILES);
		}
		addChild(b);
	}
	
}







