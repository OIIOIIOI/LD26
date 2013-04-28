package ;

/**
 * ...
 * @author 01101101
 */

class ActionManager {
	
	static private var cycleIndex:Int;
	static private var cycle:Array<E_Action>;
	
	static public function init () {
		cycle = new Array<E_Action>();
		cycle.push(ARight);
		cycle.push(ARight);
		cycle.push(ADown);
		cycle.push(ARight);
		cycle.push(ARight);
		
		cycleIndex = 0;
	}
	
	static public function nextAction () :E_Action {
		if (cycleIndex == cycle.length) {
			cycleIndex = 0;
			return null;
		}
		var a = cycle[cycleIndex];
		cycleIndex++;
		return a;
	}
	
}

enum E_Action {
	AUp;
	ALeft;
	ADown;
	ARight;
}







