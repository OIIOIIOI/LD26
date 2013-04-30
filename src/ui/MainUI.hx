package ui;
import ActionManager;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.MouseEvent;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFormat;
import Game;

/**
 * ...
 * @author 01101101
 */

class MainUI extends Sprite {
	
	var bgbd:BitmapData;
	var bg:Bitmap;
	
	var startButton:Button;
	var destroyButton:Button;
	
	var listTF:TextField;
	
	public var gold(default, setGold):Int;
	
	function setGold (g:Int) {
		dirty = true;
		gold = g;
		return g;
	}
	var goldTF:TextField;
	
	var container:Sprite;
	
	public var dirty:Bool;
	
	static public var me:MainUI;
	
	public function new () {
		super();
		
		if (me != null)	throw new Error("nope");
		me = this;
		
		bgbd = new UIBD(0, 0);
		bg = new Bitmap(bgbd);
		addChild(bg);
		
		gold = 0;
		
		var format:TextFormat = new TextFormat("OrbLight", 20, 0x6d284a);
		
		goldTF = new TextField();
		goldTF.defaultTextFormat = format;
		goldTF.embedFonts = true;
		goldTF.antiAliasType = AntiAliasType.ADVANCED;
		goldTF.selectable = false;
		goldTF.multiline = false;
		goldTF.width = 255;
		goldTF.x = 625;
		goldTF.y = 20;
		goldTF.text = Std.string(gold) + " Gold";
		addChild(goldTF);
		
		format = new TextFormat("OrbLight", 20, 0x6d284a);
		//format.align = TextFormatAlign.CENTER;
		
		listTF = new TextField();
		listTF.defaultTextFormat = format;
		listTF.embedFonts = true;
		listTF.antiAliasType = AntiAliasType.ADVANCED;
		listTF.selectable = false;
		listTF.multiline = false;
		listTF.width = 255;
		listTF.x = 625;
		listTF.y = 50;
		listTF.text = "Instructions:";
		addChild(listTF);
		
		container = new Sprite();
		container.x = 625;
		container.y = 75;
		addChild(container);
		
		startButton = new Button("startButton");
		startButton.x = 715;
		startButton.y = 455;
		startButton.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(startButton);
		
		destroyButton = new Button("autoDestruct");
		destroyButton.x = 715;
		destroyButton.y = 455;
		destroyButton.addEventListener(MouseEvent.CLICK, clickHandler);
		//addChild(destroyButton);
		dirty = true;
	}
	
	function clickHandler (e:MouseEvent) {
		if (Level.me.robot.parent == null)	return;
		switch (e.currentTarget) {
			case startButton:
				Game.me.selectState(Game.me.exploState);
				dirty = true;
				//removeChild(startButton);
				//addChild(destroyButton);
				
			case destroyButton:
				Level.me.autoDestruct();
				dirty = true;
				//Game.me.selectState(Game.me.prepaState);
				//removeChild(destroyButton);
				//addChild(startButton);
		}
		
	}
	
	public function update () {
		if (!dirty)	return;
		if (Game.me.currentState != Game.me.titleState) {
			while (container.numChildren > 0) container.removeChildAt(0);
			//listTF.text = "Instructions:\n";
			for (i in 0...ActionManager.cycle.length) {
			//for (a in ActionManager.cycle) {
				/*var txt = "";
				if (a.isAvailable)	txt = " + ";
				else				txt = "       - ";
				listTF.text += txt + Std.string(a.type + "\n");*/
				var a = ActionManager.cycle[i];
				if (a.hide || a.temp)	continue;
				var picto = new Picto(a);
				picto.y = Std.int(i / 3) * (picto.height + 10);
				picto.x = (i % 3) * (picto.width + 10);
				if (a.isAvailable)	picto.alpha = 1;
				else				picto.alpha = 0.5;
				container.addChild(picto);
			}
			
			goldTF.text = Std.string(gold) + " Gold";
		}
		
		if (Game.me.currentState == Game.me.prepaState) {
			if (contains(destroyButton))	removeChild(destroyButton);
			addChild(startButton);
			dirty = false;
		}
		else if (Game.me.currentState == Game.me.exploState) {
			if (contains(startButton))	removeChild(startButton);
			addChild(destroyButton);
			dirty = false;
		}
	}
	
}
















