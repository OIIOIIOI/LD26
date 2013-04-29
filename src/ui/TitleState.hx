package ui;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import SoundManager;

/**
 * ...
 * @author 01101101
 */

class TitleState extends State {
	
	var button:Button;
	
	public function new () {
		super();
		
		button = new Button("base",50,50);
		
		/*var tf:TextField = new TextField();
		tf.embedFonts = true;
		tf.antiAliasType = AntiAliasType.ADVANCED;
		tf.selectable = false;
		tf.multiline = false;
		tf.defaultTextFormat = new TextFormat("OrbMedium", 60);
		tf.text = "Start";
		tf.width = 200;
		tf.y = 100;
		addChild(tf);*/
	}
	
	override public function activate () :Void {
		super.activate();
		
		button.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(button);
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		
		button.removeEventListener(MouseEvent.CLICK, clickHandler);
		removeChild(button);
	}
	
	private function clickHandler (e:MouseEvent) :Void {
		Game.me.selectState(Game.me.prepaState);
	}
	
}










