package ui;
import SoundManager;

/**
 * ...
 * @author 01101101
 */

class PrepaState extends State {
	
	public function new () {
		super();
	}
	
	override public function activate () :Void {
		super.activate();
		SoundManager.me.selectTrack(SM.TRK_MENU);
	}
	
	override public function update () :Void {
		super.update();
	}
	
	override public function deactivate () :Void {
		super.deactivate();
	}
	
}
