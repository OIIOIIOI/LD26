package cards;

import Data;
/**
 * ...
 * @author ...
 */
class CardStack
{
	public var cardlist :Array<Card>;
	public var nbofCards :Int;
	
	public function addCard(newcard:Card):Void {
		cardlist.push(newcard);
	}
	public function randomcard() {
		var selectedCard :Card = cardlist[Std.random(cardlist.length)];
		return selectedCard;
	}
	
	public function getCard(index:Int) {
		var selectedCard :Card = cardlist[index];
		return selectedCard;
	}
	
	
	public function new(type:E_CardStackType) 
	{
		switch(type) {
			case E_CardStackType.deck:	cardlist = new Array();
											cardlist.push(new Card(avancerhaut));
											cardlist.push(new Card(avancerhaut));
											cardlist.push(new Card(avancerbas));
											cardlist.push(new Card(avancerbas));
											cardlist.push(new Card(avancerdroite));
											cardlist.push(new Card(avancerdroite));
											cardlist.push(new Card(avancergauche));
											cardlist.push(new Card(avancergauche));
											nbofCards = cardlist.length;
											
			case E_CardStackType.pioche: 	nbofCards = 12;
			
			case E_CardStackType.jeu: 		nbofCards = 4;
		}
	}
	
}