package cards;
/**
 * ...
 * @author ...
 */
class Deck
{
	public var cardlist :Array<Card>;
	
	private function addCard(newcard:Card):Void {
		cardlist.push(newcard);
	}
	public function randomcard() {
		var selectedCard :Card = cardlist[Std.random(cardlist.length)];
		return selectedCard;
		trace(selectedCard);
	}
	
	
	public function new() 
	{
		cardlist = new Array();
	}
	
}