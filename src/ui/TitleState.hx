package ui;
import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * ...
 * @author 01101101
 */

class TitleState extends State {
	
	var button:Button;
	
	public function new () {
		super();
		
		button = new Button(50,50,"base");
	}
	
	override public function activate () :Void {
		super.activate();
		
		button.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(button);
	}
	
	override public function update () :Void {
		super.update();
	}
	
	override public function deactivate () :Void {
		super.deactivate();
	}
	
	private function clickHandler (e:MouseEvent) :Void {
		Game.me.selectState(Game.me.exploState);
	}
	
}










