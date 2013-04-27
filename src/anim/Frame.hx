package anim;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import haxe.Public;

/**
 * ...
 * @author 01101101
 */

class Frame implements Public
{
	
	var spritesheet:BitmapData;
	var name:String;
	var uid:String;
	var x:Int;
	var y:Int;
	var width:Int;
	var height:Int;
	
	/**
	 * @param	?n		name
	 * @param	?id		frame UID
	 * @param	?xPos	x
	 * @param	?yPos	y
	 * @param	?w		width
	 * @param	?h		height
	 */
	function new (?n:String = "", ?id:String = "", ?xPos:Int = 0, ?yPos:Int = 0, ?w:Int = 1, ?h:Int = 1) {
		name = n;
		uid = id;
		x = xPos;
		y = yPos;
		width = w;
		height = h;
		trace("frame " + name);
	}
	
	function fromObject (d:Dynamic) :Void {
		name = d.name;
		uid = d.uid;
		x = d.x;
		y = d.y;
		width = d.width;
		height = d.height;
	}
	
	function toString () :String {
		return "[Frame] { name:" + name + ", uid:" + uid + ", x:" + x + ", y:" + y + ", width:" + width + ", height:" + height + " }";
	}
	
}