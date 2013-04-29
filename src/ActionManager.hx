package ;

/**
 * ...
 * @author 01101101
 */

class ActionManager {
	
	static private var cycleIndex:Int;
	static private var cycle:Array<Action>;
	static public var nextAction(getNextAction, null):Action;
	
	static public function init () {
		cycle = new Array<Action>();
		cycle.push(new Action(ADown(1)));
		//cycle.push(new Action(ARight(1)));
		//cycle.push(new Action(ARight(1)));
		//cycle.push(new Action(ADig));
		
		cycleIndex = 0;
	}
	
	static public function isStillRunning () :Bool {
		for (a in cycle) {
			if (a.isAvailable)	return true;
		}
		return false;
	}
	
	static function getNextAction () :Action {
		if (cycleIndex == cycle.length) {
			cycleIndex = 0;
		}
		var a = cycle[cycleIndex];
		cycleIndex++;
		var safety = cycle.length;
		while (!a.isAvailable && safety > 0) {
			a = cycle[cycleIndex];
			cycleIndex++;
			safety--;
		}
		if (safety == 0)	return null;
		return a;
	}
	
	
	
}

class Action {
	public var type:E_Action;
	public var isAvailable:Bool;
	public function new (type:E_Action) {
		this.type = type;
		isAvailable = true;
	}
	public function discard () {
		isAvailable = false;
		trace("discarded action " + type);
	}
}

enum E_Action {
	AUp(n:Int);
	ALeft(n:Int);
	ADown(n:Int);
	ARight(n:Int);
	ADig;
}







