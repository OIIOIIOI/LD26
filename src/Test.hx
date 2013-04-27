package ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;

/**
 * ...
 * @author 01101101
 */
class Test extends Sprite
{

	public function new()
	{
		super();
		
		var bdA = new BitmapData(48, 48, false, 0xFFFF00);
		var bdB = new BitmapData(96, 96, false);
		
		bdA.fillRect(new Rectangle(16, 16, 16, 16), 0xFF0000);
		bdA.fillRect(new Rectangle(17, 17, 14, 14), 0xFFCC00);
		
		var bA = new Bitmap(bdA);
		bA.x = bA.y = 1;
		Lib.current.stage.addChild(bA);
		
		var bB = new Bitmap(bdB);
		bB.x = bA.x + bA.width + 1;
		bB.y = bA.y;
		Lib.current.stage.addChild(bB);
		
		var r = new Rectangle(0, 0, 32, 32);// Do not define x and y of the area to clip, apply future scale to area with/height (WTF ADOBE?!)
		var m = new Matrix();
		m.translate(-16, -16);// These define the x and y of the area to clip
		m.scale(2, 2);
		bdB.draw(bdA, m, null, null, r);
	}
	
}