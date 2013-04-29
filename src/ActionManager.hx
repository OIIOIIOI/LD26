package ;
import cards.Card;
import Data;
/**
 * ...
 * @author 01101101
 */

class ActionManager {
	
	static private var cycleIndex:Int;
	static private var cycle:Array<Action>;
	static public var nextAction(getNextAction, null):Action;
	
	static public var canMine:Bool;
	static public var canSaw:Bool;
	static public var canSwim:Bool;
	
	static public function init () {
		//canMine = canSaw = canSwim = false;
		canMine = canSaw = canSwim = true;
		cycle = new Array<Action>();
		cycleIndex = 0;
	}
	
	static public function isStillRunning () :Bool {
		for (a in cycle) {
			if (a.isAvailable)	return true;
		}
		return false;
	}
	
	static public function activeActions () :Int {
		var c = 0;
		for (a in cycle) {
			if (a.isAvailable)	c++;
		}
		return c;
	}
	
	static public function visibleActions () {
		for (a in cycle) {
			if (!a.hide)	trace(a);
		}
	}
	
	static function getNextAction () :Action {
		if (!isStillRunning())	return null;
		
		var a = cycle[cycleIndex];
		if (a.temp) {
			cycle.remove(a);
		}
		else cycleIndex++;
		if (cycleIndex == cycle.length)	cycleIndex = 0;
		
		var safety = cycle.length;
		while (!a.isAvailable && safety > 0) {
			a = cycle[cycleIndex];
			if (a.temp) {
				cycle.remove(a);
			}
			else cycleIndex++;
			if (cycleIndex == cycle.length)	cycleIndex = 0;
			safety--;
		}
		return a;
	}
	
	static public function pushAction (type:E_Action) {
		var a:Action = new Action(type, false, false);
		cycle.push(a);
		switch (type) {
			case AUp(n), ALeft(n), ADown(n), ARight(n):
				a.childs = new Array<Action>();
				for (i in 1...n) {
					var aa:Action = new Action(type, false, true);
					aa.parent = a;
					a.childs.push(aa);
					cycle.push(aa);
				}
			case AMine:	canMine = true;
			case ASaw:	canSaw = true;
			case ASwim:	canSwim = true;
			default:
		}
	}
	
	static public function insertAction (type:E_Action, temp:Bool = true) {
		cycle.insert(cycleIndex, new Action(type, temp, true));
	}
	
	static public function getActionFromCard (card:Card) :E_Action {
		return switch (card.type) {
			case avancerhaut:	E_Action.AUp(card.level+1);
			case avancerbas:	E_Action.ADown(card.level+1);
			case avancergauche:	E_Action.ALeft(card.level+1);
			case avancerdroite:	E_Action.ARight(card.level+1);
			case scie:			E_Action.ASaw;
			case bouee:			E_Action.ASwim;
			case creuser:		E_Action.ADig;
			case foreuse:		E_Action.AMine;
			default:
		}
	}
	
}

class Action {
	
	public var type:E_Action;
	public var isAvailable:Bool;
	public var temp:Bool;
	public var hide:Bool;
	public var parent:Action;
	public var childs:Array<Action>;
	
	public function new (type:E_Action, temp:Bool = false, hide:Bool = false) {
		this.type = type;
		this.temp = temp;
		this.hide = hide;
		isAvailable = true;
	}
	
	public function discard (all:Bool = true) {
		isAvailable = false;
		if (!all)	return;
		
		if (parent != null && parent.isAvailable) {
			parent.discard();
		}
		else if (childs != null) {
			for (c in childs) {
				if (c.isAvailable)	c.discard();
			}
		}
	}
	
	public function toString () {
		return "[Action] " + type + ", temp:" + temp + ", isAvailable:" + isAvailable + "\n";
	}
	
}

enum E_Action {
	AUp(n:Int);
	ALeft(n:Int);
	ADown(n:Int);
	ARight(n:Int);
	ADig;
	AMine;
	ASaw;
	ASwim;
}







