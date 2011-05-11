package com.lnet.pandora.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends Event {
		public static const SONG_LOADED:String = "songLoaded";
		public static const STATION_SELECTED:String = "stationSelected";
		public static const STATION_LIST_LOADED:String = "stationListLoaded";
		public static const UPDATE_SELECTED_INDEX:String = "updateSelectedIndex";
		public static const RESET_FOCUS:String = "resetFocus";
		public static const PLAY_SONG:String = "playSong";
		public static const PAUSE_SONG:String = "pauseSong";
		public static const LOGIN_ERROR:String = "loginError";
		
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