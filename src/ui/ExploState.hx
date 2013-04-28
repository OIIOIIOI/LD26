package ui;

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
		addChild(Level.me);
	}
	
	override public function update () :Void {
		super.update();
		Level.me.update();
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		removeChild(Level.me);
	}
	
}
