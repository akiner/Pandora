package com.lnet.pandora.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends Event {
		public static const SONG_LOADED:String = "songLoaded";
		public static const UPDATE_SELECTED_INDEX:String = "updateSelectedIndex";
		
		public var data:Object;
		public var optionalData:Object;
		public var optionalData2:Object;
		
		public function ApplicationEvent(type:String, eventData:Object=null, optionalDataField:Object=null, optionalDataField2:Object=null, 
										 bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			data = eventData;
			if(optionalDataField != null) {
				optionalData = optionalDataField;
			}
			if(optionalDataField2 != null) {
				optionalData2 = optionalDataField2;
			}
		}
	}
}