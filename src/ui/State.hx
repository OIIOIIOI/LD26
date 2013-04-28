package ui;

import flash.display.Sprite;

/**
 * ...
 * @author 01101101
 */

class State extends Sprite {
	
	public var type:E_State;
	
	public function new () {
		super();
	}
	
	public function activate () :Void {
		
	}
	
	public function update () :Void {
		
	}
	
	public function deactivate () :Void {
		
	}
	
}

enum E_State {
	ETitle;
	EPrepa;
	EExplo;
}