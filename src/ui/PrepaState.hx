package ui;
import cards.CardStack;
import flash.events.MouseEvent;
import SoundManager;

/**
 * ...
 * @author 01101101
 */

class PrepaState extends State {
	
	var button:Button;
	
	public function new () {
		super();
		
		button = new Button();
	}
	
	override public function activate () :Void {
		super.activate();
		
		SoundManager.me.selectTrack(SM.TRK_MENU);
		
		addChild(Level.me);
		
		
		ActionManager.init();
		
		var numCards = 4 + Game.me.rank;
		for (i in 0...numCards) {
			var c = Game.me.deck.randomcard();
			ActionManager.pushAction(ActionManager.getActionFromCard(c));
		}
		
		trace(ActionManager.visibleActions());
		
		button.addEventListener(MouseEvent.CLICK, clickHandler);
		addChild(button);
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		removeChild(Level.me);
		button.removeEventListener(MouseEvent.CLICK, clickHandler);
		removeChild(button);
	}
	
	private function clickHandler (e:MouseEvent) :Void {
		Game.me.selectState(Game.me.exploState);
	}
	
}
