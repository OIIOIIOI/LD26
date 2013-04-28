package cards;

/**
 * ...
 * @author ...
 */
class Card
{
	public var type: String;
	public var level: Int;
	public var lvlmax: Int;
	
	private function upgrade():Void {
		level++;
	}
	private function resetlvl():Void {
		level = 0;
	}
	
	public function new(newtype:String) 
	{
		switch(newtype) {
			case "avancerhaut": lvlmax = 4;
			case "avancerbas": lvlmax = 4;
			case "avancergauche": lvlmax = 4;
			case "avancerdroite": lvlmax = 4;
			case "creuser": lvlmax = 2;
			case "foreuse": lvlmax = 0;
			case "scie": lvlmax = 0;
			case "bouée": lvlmax = 0;
		}
		type = newtype;
	}
	
}