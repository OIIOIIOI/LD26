package utils;

/**
 * Frame Timer
 * Like haxe.Timer.delay() but frame based
 *
 * @author fbarbut
 * @adapted
 */

class FTimer
{
	public static var timer = 0;
	public static var delayed = new List<{func:Void->Void,end:Int,id:String}>();
	public static var ticked = new List<{func:Float->Void,end:Int,dur:Int}>();
	
	/**
	 * @param	func	Function to call
	 * @param	delay	Delay in frames
	 */
	public static function delay(func:Void->Void,delay:Int,?id:String) {
		delayed.push( { func:func, end:timer+delay, id:id} );
	}
	
	public static function tick(func:Float->Void,delay:Int) {
		ticked.push( { func:func, end:timer+delay,dur:delay} );
	}
	
	public static function update() {
		for (a in delayed) {
			if(timer >= a.end) {
				a.func();
				delayed.remove(a);
			}
		}
		
		for (a in ticked) {
			a.func( 1.0 - ((a.end - timer) / a.dur) );
			if(timer >= a.end) {
				ticked.remove(a);
			}
		}
		timer++;
	}
	
	public static function clear(?id:String) {
		if (id == null) {
			delayed.clear();
			ticked.clear();
			timer = 0;
		}
		else {
			var l = new List<{func:Void->Void,end:Int,id:String}>();
			for (o in delayed) {
				if (o.id == id)	l.add(o);
			}
			for (o in l) {
				while (delayed.remove(o)) {}
			}
		}
	}
	
	
}