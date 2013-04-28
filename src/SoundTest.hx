package ;

import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.ui.Keyboard;
import haxe.Resource;
import utils.FTimer;
import KeyboardManager;

/**
 * ...
 * @author 01101101
 */

class SoundTest extends Sprite {
	
	var menu:SoundPair;
	var explo:SoundPair;
	var water:SoundPair;
	
	var locked:Bool;
	var delayed:Bool;
	
	var SOUNDS:Hash<SoundPair>;
	
	var robot:Sprite;
	var rTarget:Int;
	var col:UInt;
	
	var tick:Int;
	
	public function new () {
		super();
		
		var data = Resource.getBytes("TrackMenu");
		menu = { s:null, c:null };
		menu.s = new Sound();
		menu.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		
		data = Resource.getBytes("TrackExplo");
		explo = { s:null, c:null };
		explo.s = new Sound();
		explo.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		
		data = Resource.getBytes("TrackWater");
		water = { s:null, c:null };
		water.s = new Sound();
		water.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		
		menu.c = menu.s.play(0, 99);
		menu.c.soundTransform = new SoundTransform(0);
		explo.c = explo.s.play(0, 99);
		//explo.c.soundTransform = new SoundTransform(0);
		water.c = water.s.play(0, 99);
		water.c.soundTransform = new SoundTransform(0);
		
		SOUNDS = new Hash<SoundPair>();
		
		var sp:SoundPair = { s:null, c:null };
		data = Resource.getBytes("SndMine");
		sp.s = new Sound();
		sp.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		SOUNDS.set("SndMine", sp);
		
		sp = { s:null, c:null };
		data = Resource.getBytes("SndDig");
		sp.s = new Sound();
		sp.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		SOUNDS.set("SndDig", sp);
		
		sp = { s:null, c:null };
		data = Resource.getBytes("SndCut");
		sp.s = new Sound();
		sp.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		SOUNDS.set("SndCut", sp);
		
		robot = new Sprite();
		robot.graphics.beginFill(0x000000);
		robot.graphics.drawRect(0, 0, 40, 40);
		robot.graphics.endFill();
		robot.x = robot.y = 20;
		addChild(robot);
		rTarget = 20;
		
		locked = delayed = false;
		
		addEventListener(Event.ENTER_FRAME, update);
		FTimer.delay(simulateEvent, 12);
	}
	
	function lockKeys () {
		locked = !locked;
	}
	
	private function update (e:Event) {
		if (!locked) {
			if (KM.isDown(Keyboard.UP)) {
				trace("Menu <-> Explo");
				switchTrack(menu.c, explo.c);
			}
			if (KM.isDown(Keyboard.RIGHT)) {
				trace("Explo <-> Water");
				switchTrack(explo.c, water.c);
			}
			if (KM.isDown(Keyboard.LEFT)) {
				trace("Menu <-> Water");
				switchTrack(menu.c, water.c);
			}
		}
		
		if (robot.x != rTarget) {
			if (Math.abs(rTarget - robot.x) < 0.2)	robot.x = rTarget;
			else {
				robot.x += (rTarget - robot.x) * 0.5;
			}
		}
		
		//tick++;
		FTimer.update();
	}
	
	function change (c:UInt = 0x000000) {
		col = c;
		robot.graphics.clear();
		robot.graphics.beginFill(c);
		robot.graphics.drawRect(0, 0, 40, 40);
		robot.graphics.endFill();
	}
	
	private function simulateEvent () {
		if (!delayed) {
			if (col != 0x000000) {
				change();
				rTarget += 40;
				if (rTarget > Game.SIZE.width - 60)	robot.x = rTarget = 20;
			} else {
				switch (Std.random(12)) {
					case 0:
						if (tick % 2 == 0) {
							playSnd("SndMine");
						} else {
							change(0xFF0000);
							delayed = true;
							FTimer.delay(callback(playSnd, "SndMine"), 10);
						}
					case 1:
						if (tick % 2 == 0) {
							playSnd("SndDig");
						} else {
							change(0xFF0000);
							delayed = true;
							FTimer.delay(callback(playSnd, "SndDig"), 10);
						}
					case 2:
						if (tick % 2 == 0) {
							playSnd("SndCut");
						} else {
							change(0xFF0000);
							delayed = true;
							FTimer.delay(callback(playSnd, "SndCut"), 10);
						}
					default:
						change();
						rTarget += 40;
						if (rTarget > Game.SIZE.width - 60)	robot.x = rTarget = 20;
				}
			}
		}
		else delayed = false;
		tick++;
		FTimer.delay(simulateEvent, 10);
	}
	
	function playSnd (s:String) {
		if (SOUNDS.exists(s)) {
			change(0x00FF00);
			delayed = true;
			SOUNDS.get(s).c = SOUNDS.get(s).s.play(0, new SoundTransform(0.5));
		}
	}
	
	private function switchTrack (chnA:SoundChannel, chnB:SoundChannel) {
		locked = true;
		FTimer.delay(lockKeys, 10);
		if (chnA.soundTransform.volume > 0) {
			chnA.soundTransform = new SoundTransform(0);
			chnB.soundTransform = new SoundTransform(1);
		} else {
			chnA.soundTransform = new SoundTransform(1);
			chnB.soundTransform = new SoundTransform(0);
		}
	}
	
}

typedef SoundPair = {
	var s:Sound;
	var c:SoundChannel;
}







