package ui;
import cards.CardStack;
import Data;
import flash.events.MouseEvent;
import SoundManager;

/**
 * ...
 * @author 01101101
 */

class PrepaState extends State {
	
	public function new () {
		super();
	}
	
	override public function activate () :Void {
		super.activate();
		
		SoundManager.me.selectTrack(SM.TRK_MENU);
		
		Level.me.robot.update();
		addChild(Level.me);
		
		ActionManager.init();
		
		var draw:CardStack = new CardStack(E_CardStackType.pioche);
		draw.pickCards(Game.me.deck);
		
		for (c in draw.cardlist) {
			ActionManager.pushAction(ActionManager.getActionFromCard(c));
		}
		
		Level.me.fakeStart();
	}
	
	override public function update () :Void {
		super.update();
		MainUI.me.update();
	}
	
	override public function deactivate () :Void {
		super.deactivate();
		removeChild(Level.me);
	}
	
}
