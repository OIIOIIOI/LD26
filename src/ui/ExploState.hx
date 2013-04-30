package ui;
import SoundManager;

/**
 * ...
 * @author 01101101
 */

class ExploState extends State {
	
	public function new () {
		super();
	}
	
	override public function activate () :Void {
		super.activate();
		
		SoundManager.me.selectTrack(SM.TRK_EXPLO);
		
		addChild(Level.me);
		
		Level.me.start();
	}
	
	override public function update () :Void {
		super.update();
		Level.me.update();
		MainUI.me.update();
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		removeChild(Level.me);
	}
	
}
