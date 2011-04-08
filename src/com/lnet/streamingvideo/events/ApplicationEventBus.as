package com.lnet.streamingvideo.events{
	import flash.events.EventDispatcher;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class ApplicationEventBus extends EventDispatcher {
		
		protected static var instance:ApplicationEventBus;
		
		public function ApplicationEventBus() {
			MonsterDebugger.trace("ApplicationEventBus::constructor", "Created!");
		}
		
		public static function getInstance():ApplicationEventBus {
			if ( instance == null ) {
				trace("CREATED APP EVENT BUS");
				instance = new ApplicationEventBus();
			}
			return instance;
		}
	}
}
//internal class SingletonBlocker {}