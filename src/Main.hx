package ;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author 01101101
 */

class Main {
	
	static function main () {
		KeyboardManager.init(Lib.current.stage);
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		//Lib.current.stage.align = StageAlign.TOP;
		Lib.current.stage.addChild(new Game());
		//Lib.current.stage.addChild(new Testthib());
		//Lib.current.stage.addChild(new SoundTest());
	}
	
}
