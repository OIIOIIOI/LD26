package ui;
import ActionManager;

/**
 * ...
 * @author 01101101
 */

class Picto extends Button{
	
	public function new (a:Action) {
		super(bdFromAction(a));
		btnlook.scaleX = btnlook.scaleY = 2;
		buttonMode = false;
	}
	
	function bdFromAction (a:Action) :String {
		return switch (a.type) {
			case E_Action.AUp(n):	"pictoUp";
			case E_Action.ARight(n):"pictoRight";
			case E_Action.ADown(n):	"pictoDown";
			case E_Action.ALeft(n):	"pictoLeft";
			case E_Action.ADig:		"pictoDig";
			case E_Action.AMine:	"pictoMine";
			case E_Action.ASaw:		"pictoSaw";
			case E_Action.ASwim:	"pictoSwim";
			default: 				"";
		}
	}
	
}
