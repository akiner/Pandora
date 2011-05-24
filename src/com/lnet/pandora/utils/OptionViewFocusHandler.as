package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	
	public class OptionViewFocusHandler extends FocusHandler {
		private var currentKey:String;
		
		public function OptionViewFocusHandler() {
			MonsterDebugger.trace("OptionViewFocusHandler::OptionViewFocusHandler","Options view focus handler created!!");
//			FlexGlobals.topLevelApplication.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}
		
		public override function handleKeyPress(event:KeyboardEvent):void {
			MonsterDebugger.trace("OptionViewFocusHandler::handleKeyPress","Handling Key Press in::"+FlexGlobals.topLevelApplication.currentState);
			currentKey = KeyHandler.keyPressed(event.keyCode);
			
//			switch(FlexGlobals.topLevelApplication.currentState) {
//				case "login":
//					handleKeyPressInLoginView();
//					break;
//				case "createStation":
//					handleKeyPressInCreateStationView();
//					break;
//				case "viewOptions":
//					handleKeyPressInOptionsView();
//					break;
//				case "default":
//					handleKeyPressInDefaultView();
//					break;
//				default:
//					MonsterDebugger.trace("FocusHandler::constructor","Keyboard event not handled!!!");
//					break;
//			}
		}
	}
}