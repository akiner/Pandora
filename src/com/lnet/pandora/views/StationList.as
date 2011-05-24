package com.lnet.pandora.views {
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	
	import spark.components.List;
	
	public class StationList extends List {
		public function StationList() {
			super();
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void {
			if(FlexGlobals.topLevelApplication.currentState=="viewOptions"){
				MonsterDebugger.trace("StationListView::checkFocus","Options are being viewed -- don't do anything");
			} else {
				MonsterDebugger.trace("StationListView::checkFocus","Options are NOT being viewed - navigation station list");
				selectedIndex++; // TO DO :: Increment or decrement based on up or down arrow key press
			}
		}
	}
}