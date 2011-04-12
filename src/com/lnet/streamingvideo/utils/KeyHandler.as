package com.lnet.streamingvideo.utils {
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	
	public class KeyHandler	{
//		public function KeyHandler() {
//			MonsterDebugger.trace("KeyHandler::KeyHandler","Created!");
//			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress);
//		}

//		private function handleKeyPress(event:KeyboardEvent):void {
//			switch (event.keyCode) {
//				case 38:
//					MonsterDebugger.trace("KeyHandler::handleKeyPress","The up arrow was pressed");
//					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.NAVIGATE_CATEGORIES, "up"));
//					break;
//				case 40:
//					MonsterDebugger.trace("KeyHandler::handleKeyPress","The down arrow was pressed");
//					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.NAVIGATE_CATEGORIES, "down"));
//					break;
//				case 39:
//					MonsterDebugger.trace("KeyHandler::handleKeyPress","The right arrow was pressed");
//					break;
//				case 37:
//					MonsterDebugger.trace("KeyHandler::handleKeyPress","The left arrow was pressed");
//					break;
//				case 13:
//					MonsterDebugger.trace("KeyHandler::handleKeyPress","The enter key was pressed");
//					break;
//				default:
//					MonsterDebugger.trace("KeyHandler::handleKeyPress","Key not recognized::"+event.keyCode);
//					break;
//			}
//		}
		public static function keyPressed(keyCode:uint):String {
			var keyToReturn:String;
			switch (keyCode) {
				case 38:
					keyToReturn = "upArrow";
					break;
				case 40:
					keyToReturn = "downArrow";
					break;
				case 39:
					keyToReturn = "rightArrow";
					break;
				case 37:
					keyToReturn = "leftArrow";
					break;
				case 13:
					keyToReturn = "select"; // This is for keyboard nav only - not used for remote
					break;
				case 125:
					keyToReturn = "select";
					break;
				case 27:
					keyToReturn = "back";
					break;
				default:
					keyToReturn = "undefined";
					break;
			}
			return keyToReturn;
		}
	}
}