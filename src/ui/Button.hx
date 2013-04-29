package ui;

import flash.display.Sprite;

/**
 * ...
 * @author 01101101
 */

class Button extends Sprite {
	
	public function new () {
		super();
		graphics.beginFill(0);
		graphics.drawRect(0, 0, 150, 30);
		graphics.endFill();
		buttonMode = true;
	}
	
}



