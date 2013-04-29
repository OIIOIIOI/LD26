package ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import anim.FrameManager;

/**
 * ...
 * @author 01101101
 */

class Button extends Sprite {
	
	var btnlookData :BitmapData;
	var btnlook :Bitmap;
	
	public function new (?graphname:String, coox:Int = 0, cooy:Int = 0) {
		super();
		
		buttonMode = true;
		
		if (graphname != null) {
			btnlookData = FrameManager.getFrame(graphname,Game.SHEET_TILES);
			btnlook = new Bitmap(btnlookData);
			addChild(btnlook);
		}
		else {
			graphics.beginFill(0);
			graphics.drawRect(0, 0, 160, 60);
			graphics.endFill();
		}
		
		this.x = coox;
		this.y = cooy;
	}
	
}



