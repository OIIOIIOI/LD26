package ui;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import SoundManager;
import utils.FTimer;

/**
 * ...
 * @author 01101101
 */

class TitleState extends State {
	
	var button:Button;
	var creditentries :Array<String>;
	var creditCounter :Int;
	var creditfield:TextField;
	var creditfieldformat :TextFormat;
	
	
	
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
		
		creditCounter = -1;
		creditentries = ["Gamedesign: The whole Gagabu team", "Main programer: 01101101", "Support programer: Grmpf", "Graphic designer: Noc"];
		creditfield = new TextField();
		creditfieldformat = new TextFormat("OrbMedium", 15);
		creditfield.embedFonts = true;
		creditfield.antiAliasType = AntiAliasType.ADVANCED;
		creditfield.selectable = false;
		creditfield.multiline = false;
		creditfieldformat.align = TextFormatAlign.CENTER;
		creditfield.defaultTextFormat = creditfieldformat;
		creditfield.width = 600;
		creditfield.y = 450;
		
	}
	
	override public function activate () :Void {
		super.activate();
		
		button.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(button);
		addChild(creditfield);
		FTimer.delay(refreshCredit, 75);
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		
		button.removeEventListener(MouseEvent.CLICK, clickHandler);
		removeChild(button);
		removeChild(creditfield);
		FTimer.clear;
	}
	
	private function clickHandler (e:MouseEvent) :Void {
		Game.me.selectState(Game.me.prepaState);
	}
	
	function refreshCredit ():Void {
			if (creditCounter < 3) {
				creditCounter++;
			}
			else {
				creditCounter = 0;
			}
			creditfield.text = creditentries[creditCounter];
			FTimer.delay(refreshCredit, 80);
	}
}










