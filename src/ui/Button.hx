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
	
	public function new (coox:Int,cooy:Int,graphname:String) {
		super();
		//btnlookData = new BitmapData(70, 40);
		btnlookData = FrameManager.getFrame(graphname,Game.SHEET_TILES);
		btnlook = new Bitmap(btnlookData);
		addChild(btnlook);
		trace(btnlookData);
		this.x = coox;
		this.y = cooy;
	}
	
}



