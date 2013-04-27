package ;

/**
 * ...
 * @author 01101101
 */

class Data {
	
	static public var MAP_RESOURCES:Array<E_Type> = new Array<E_Type>();
	
	static public function init () {
		MAP_RESOURCES.push(Ore(50));
		MAP_RESOURCES.push(Rock(20));
	}
	
}

enum E_Type {
	Ground;
	Rock(c:Int);
	Ore(c:Int);
}
