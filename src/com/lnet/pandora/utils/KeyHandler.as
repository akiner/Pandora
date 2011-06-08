package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	
	public class KeyHandler	{
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
				case 13: // This is for keyboard nav only - not used for remote
				case 125:
					keyToReturn = "select";
					break;
				case 27:
					keyToReturn = "back";
					break;
				case 19:
					keyToReturn = "pause";
					break;
				case 119:
					keyToReturn = "play";
					break;
				case 122:
					keyToReturn = "skipBack";
					break;
				case 120:
					keyToReturn = "skipForward";
					break;
				case 145:
//				case 144: // For keyboard testing only - mapped to num lock key
					keyToReturn = "dotCom"
					break;
				default:
					MonsterDebugger.trace("KeyHandler::keyPressed","Key not currently being handled::"+keyCode);
					keyToReturn = "undefined";
					break;
			}
			return keyToReturn;
		}
		
		public static function isNumericKey(keyCode:uint):Boolean {
			if (keyCode >=48 && keyCode <=57) {
				MonsterDebugger.trace("KeyHandler::isNumericKey","A numeric key was pressed");
				return true;
			} else {
				return false;
			}
		}
		
		public static function isAlphaKey(keyCode:uint):Boolean {
			if (keyCode >=65 && keyCode <=90) {
				MonsterDebugger.trace("KeyHandler::isAlphaKey","An alpha key was pressed");
				return true;
			} else {
				return false;
			}
		}
	}
}