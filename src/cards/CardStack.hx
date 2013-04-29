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
	public var stckCrdType : E_CardStackType;
	
	public function addCard(newcard:Card):Void {
		cardlist.push(newcard);
	}
	public function randomcard() :Card {
		var selectedCard :Card = cardlist[Std.random(cardlist.length)];
		return selectedCard;
	}
	
	public function getCard(index:Int) :Card {
		var selectedCard :Card = cardlist[index];
		return selectedCard;
	}
	
	public function pickCards (deck:CardStack):Void {
		if(stckCrdType == E_CardStackType.pioche && deck.stckCrdType == E_CardStackType.deck){
			var tempdeck = deck.clone();
			var pickedCard:Card;
			for (i in 0...nbofCards) {
				if (cardlist[i] != null)	cardlist[i].dansPioche = false;
				pickedCard = tempdeck.randomcard();
				tempdeck.cardlist.remove(pickedCard);
				cardlist.push(pickedCard);
				//trace (pickedCard.type);
			}
		}
		else {
			trace("ne peut être pioché");
		}
	}
	
	public function clone () :CardStack {
		var cs = new CardStack(this.stckCrdType);
		while (cs.cardlist.length > 0)	cs.cardlist.shift();
		for (c in cardlist) {
			cs.addCard(c.clone());
		}
		return cs;
	}
	
	
	public function new(type:E_CardStackType)
	{
		switch(type) {
			case E_CardStackType.deck:	cardlist = new Array();
											stckCrdType = E_CardStackType.deck;
											cardlist.push(new Card(E_Card.avancerhaut));
											cardlist.push(new Card(E_Card.avancerhaut));
											cardlist.push(new Card(E_Card.avancerbas));
											cardlist.push(new Card(E_Card.avancerbas));
											cardlist.push(new Card(E_Card.avancerdroite));
											cardlist.push(new Card(E_Card.avancerdroite));
											cardlist.push(new Card(E_Card.avancergauche));
											cardlist.push(new Card(E_Card.avancergauche));
											cardlist.push(new Card(E_Card.creuser));
											cardlist.push(new Card(E_Card.creuser));
											cardlist.push(new Card(E_Card.creuser));
											cardlist.push(new Card(E_Card.creuser));
											cardlist.push(new Card(E_Card.creuser));
											cardlist.push(new Card(E_Card.creuser));
											nbofCards = cardlist.length;
											
			case E_CardStackType.pioche:	cardlist = new Array();
											nbofCards = 5 + Game.me.rank;
											stckCrdType = E_CardStackType.pioche;
			
			case E_CardStackType.jeu:		cardlist = new Array();
											nbofCards = 4;
											stckCrdType = E_CardStackType.jeu;
		}
	}
	
}