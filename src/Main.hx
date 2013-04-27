package ;

import anim.FrameManager;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author 01101101
 */

@:bitmap("bin/tiles.png") class TilesBD extends flash.display.BitmapData { }

class Main {
	
	static function main () {
		FrameManager.store("tiles", new TilesBD(0, 0), haxe.Resource.getString("tilesJson"));
		
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.addChild(new Game());
	}
	
}
