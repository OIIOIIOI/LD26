package ui;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import Game;
import SoundManager;
import utils.FTimer;

/**
 * ...
 * @author 01101101
 */

class TitleState extends State {
	
	var bgbd:BitmapData;
	var bg:Bitmap;
	
	var titleTF:TextField;
	var titleSubTF:TextField;
	
	var credits :Array<String>;
	var creditCounter :Int;
	var creditsTF:TextField;
	
	var startTF:TextField;
	
	var clickArea:Sprite;
	
	public function new () {
		super();
		
		//{
		credits = [	"A game made by the Gagabu Team for Ludum Dare 26",
					"Code by 01101101 & Grmpf",
					"Art by noc.",
					"Music & SFX: Capt. CAPSLOCK & Fleacontent",
					"",
					"Thanks for playing!",
					"Or at least reading this...",
					"",
					"",
					"Still there?",
					"",
					"",
					"Do you know about Margot by any chance?",
					"Me neither.",
					"But apparently she was born like yesterday or something...",
					"So yeah...",
					"Hey Margot! :)",
					"Have fun!",
					"",
					"...",
					"",
					"",
					"",
					"",
					""];
		creditCounter = 0;//}
		
		var format:TextFormat = new TextFormat("OrbMedium", 120, 0xA3D1D7);
		format.align = TextFormatAlign.CENTER;
		
		titleTF = new TextField();
		titleTF.defaultTextFormat = format;
		titleTF.embedFonts = true;
		titleTF.antiAliasType = AntiAliasType.ADVANCED;
		titleTF.selectable = false;
		titleTF.multiline = false;
		titleTF.width = 900;
		titleTF.y = 30;
		titleTF.text = "F.I.P.S.";
		
		format = new TextFormat("OrbMedium", 16, 0x55888D);
		format.align = TextFormatAlign.CENTER;
		
		titleSubTF = new TextField();
		titleSubTF.defaultTextFormat = format;
		titleSubTF.embedFonts = true;
		titleSubTF.antiAliasType = AntiAliasType.ADVANCED;
		titleSubTF.selectable = false;
		titleSubTF.multiline = false;
		titleSubTF.width = 900;
		titleSubTF.y = 130;
		titleSubTF.text = "Few Instructions Per Sequence";
		
		format = new TextFormat("OrbLight", 20, 0xA3D1D7);
		format.align = TextFormatAlign.CENTER;
		
		startTF = new TextField();
		startTF.defaultTextFormat = format;
		startTF.embedFonts = true;
		startTF.antiAliasType = AntiAliasType.ADVANCED;
		startTF.selectable = false;
		startTF.multiline = false;
		startTF.width = 900;
		startTF.y = 305;
		startTF.text = "Click to play";
		
		format = new TextFormat("OrbLight", 16, 0xD9995F);
		format.align = TextFormatAlign.CENTER;
		
		creditsTF = new TextField();
		creditsTF.defaultTextFormat = format;
		creditsTF.embedFonts = true;
		creditsTF.antiAliasType = AntiAliasType.ADVANCED;
		creditsTF.selectable = false;
		creditsTF.multiline = false;
		creditsTF.width = 900;
		creditsTF.y = 570;
		
		clickArea = new Sprite();
		clickArea.graphics.beginFill(0xFF00FF, 0);
		clickArea.graphics.drawRect(0, 0, 900, 610);
		clickArea.graphics.endFill();
		clickArea.buttonMode = true;
	}
	
	override public function activate () :Void {
		super.activate();
		
		bgbd = new TitleBD(0, 0);
		bg = new Bitmap(bgbd);
		addChild(bg);
		
		addChild(titleTF);
		addChild(titleSubTF);
		addChild(creditsTF);
		addChild(startTF);
		
		clickArea.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(clickArea);
		
		FTimer.delay(refreshCredit, 45);
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		
		removeChild(bg);
		bg = null;
		bgbd.dispose();
		bgbd = null;
		
		removeChild(titleTF);
		removeChild(titleSubTF);
		removeChild(creditsTF);
		removeChild(startTF);
		
		clickArea.removeEventListener(MouseEvent.CLICK, clickHandler);
		removeChild(clickArea);
	}
	
	function clickHandler (e:MouseEvent) :Void {
		Game.me.selectState(Game.me.prepaState);
	}
	
	function refreshCredit () {
		creditsTF.text = credits[creditCounter];
		creditCounter++;
		if (creditCounter == credits.length)	creditCounter = 0;
		if (contains(creditsTF))	FTimer.delay(refreshCredit, 90);
	}
}










