package com.lnet.pandora.viewmodels {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	
	import mx.core.FlexGlobals;
	
	[Bindable]
	public class ErrorViewModel {
		private var _errorText:String;
		
		public function ErrorViewModel() {
			MonsterDebugger.trace("ErrorViewModel::ErrorViewModel","Created!");
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SHOW_ERROR, showErrorHandler);
		}
		
		private function showErrorHandler(event:ApplicationEvent):void {
			errorText = event.data as String;
			FlexGlobals.topLevelApplication.preErrorState = FlexGlobals.topLevelApplication.currentState;
			FlexGlobals.topLevelApplication.currentState = "error";
			MonsterDebugger.trace("ErrorViewModel::showErrorHandler","Displaying error screen...");
		}

		public function get errorText():String {
			return _errorText;
		}

		public function set errorText(value:String):void {
			_errorText = value;
		}
	}
}