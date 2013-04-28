package cards;
/**
 * ...
 * @author ...
 */
class Deck
{
	public var cardlist :Array<Card>;
	
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
	
	
	public function new() 
	{
		cardlist = new Array();
		cardlist.push(new Card(avancerhaut));
		cardlist.push(new Card(avancerhaut));
		cardlist.push(new Card(avancerbas));
		cardlist.push(new Card(avancerbas));
		cardlist.push(new Card(avancerdroite));
		cardlist.push(new Card(avancerdroite));
		cardlist.push(new Card(avancergauche));
		cardlist.push(new Card(avancergauche));
	}
	
}