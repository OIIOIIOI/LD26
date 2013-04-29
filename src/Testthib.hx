package ;
import cards.CardStack;
import flash.display.Sprite;

/**
 * ...
 * @author ...
 */
class Testthib extends Sprite
{
	
	public function new() 
	{
		super();
		var mapioche :CardStack = new CardStack (pioche);
		var mondeck :CardStack = new CardStack (deck);
		mapioche.pickCards(mondeck);
	}
	
}