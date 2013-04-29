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
		
		button = new Button(50,50,"base");
		
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
		
		SoundManager.me.start();
		SoundManager.me.selectTrack();
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










