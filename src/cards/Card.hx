package cards;

import Data;
/**
 * ...
 * @author ...
 */
class Card
{
	public var type: E_Card;
	public var level: Int;
	public var lvlmax: Int;
	public var dansPioche : Bool;
	public var dansJeu : Bool;
	
	private function upgrade():Void {
		level++;
	}
	private function resetlvl():Void {
		level = 0;
	}
	
	public function new(newtype:E_Card) 
	{
		switch(newtype) {
			case avancerhaut:		lvlmax = 4;
			case avancerbas:		lvlmax = 4;
			case avancergauche:		lvlmax = 4;
			case avancerdroite:		lvlmax = 4;
			case creuser:			lvlmax = 2;
			case foreuse:			lvlmax = 0;
			case scie:				lvlmax = 0;
			case bouee:				lvlmax = 0;
		}
		type = newtype;
		dansJeu = false;
		dansPioche = true;
	}
	
}