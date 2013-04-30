package ;
import events.EventManager;
import events.GameEvent;
import flash.errors.Error;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import haxe.Resource;
import utils.FTimer;

/**
 * ...
 * @author 01101101
 */

typedef SM = SoundManager;
class SoundManager {
	
	static public var SND_DIG:String = "SndDig";
	static public var SND_SAW:String = "SndSaw";
	static public var SND_MINE:String = "SndMine";
	static public var SND_DEAD:String = "SndDead";
	
	static public var TRK_MENU:String = "TrkMenu";
	static public var TRK_EXPLO:String = "TrkExplo";
	static public var TRK_WATER:String = "TrkWater";
	
	var menu:SoundPair;
	var explo:SoundPair;
	var water:SoundPair;
	var common:SoundPair;
	
	var SOUNDS:Hash<SoundPair>;
	
	var tick:Int;
	var queue:Array<String>;
	
	public var delayed:Bool;
	public var currentTheme:String;
	
	static public var me:SoundManager;
	
	public function new () {
		if (me != null)	throw new Error("nope");
		me = this;
		
		queue = new Array<String>();
		
		delayed = false;
		
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
		
		data = Resource.getBytes("TrackCommon");
		common = { s:null, c:null };
		common.s = new Sound();
		common.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		
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
		data = Resource.getBytes("SndSaw");
		sp.s = new Sound();
		sp.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		SOUNDS.set("SndSaw", sp);
		
		sp = { s:null, c:null };
		data = Resource.getBytes("SndDead");
		sp.s = new Sound();
		sp.s.loadCompressedDataFromByteArray(data.getData(), data.length);
		SOUNDS.set("SndDead", sp);
		
		currentTheme = null;
	}
	
	public function start () {
		common.c = common.s.play(0, 99);
		//common.c.soundTransform = new SoundTransform(0);
		
		menu.c = menu.s.play(0, 99);
		menu.c.soundTransform = new SoundTransform(0);
		
		explo.c = explo.s.play(0, 99);
		explo.c.soundTransform = new SoundTransform(0);
		
		water.c = water.s.play(0, 99);
		water.c.soundTransform = new SoundTransform(0);
		
		FTimer.delay(soundTick, 12);
	}
	
	public function soundTick () {
		if (!delayed) {
			while (queue.length > 0) {
				var s = queue.shift();
				if (tick % 2 == 0) {
					playSound(s);
				} else {
					delayed = true;
					FTimer.delay(callback(playSound, s), 10);
				}
			}
		}
		else delayed = false;
		tick++;
		FTimer.delay(soundTick, 10);
		EventManager.instance.dispatchEvent(new GameEvent(GE.SND_TICK));
	}
	
	public function selectTrack (?trk:String) {
		menu.c.soundTransform = new SoundTransform(0);
		explo.c.soundTransform = new SoundTransform(0);
		water.c.soundTransform = new SoundTransform(0);
		
		switch (trk) {
			case TRK_MENU:	menu.c.soundTransform = new SoundTransform(1);
			case TRK_EXPLO:	explo.c.soundTransform = new SoundTransform(1);
			case TRK_WATER:	water.c.soundTransform = new SoundTransform(2);
		}
		currentTheme = trk;
	}
	
	public function queueSound (s:String) {
		queue.push(s);
	}
	
	public function playSound (s:String) {
		if (SOUNDS.exists(s)) {
			SOUNDS.get(s).c = SOUNDS.get(s).s.play(0);
		}
	}
	
}

typedef SoundPair = {
	var s:Sound;
	var c:SoundChannel;
}















