package com.lnet.streamingvideo.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends Event {
		public static const SEARCH_INITIATED:String = "searchInitiated";
		public static const SEARCH_REQUESTED:String = "searchRequested";
		public static const SEARCH_RESULTS_RETURNED:String = "searchResultsReturned";
		
		public static const DEFAULT_CATEGORIES_LOADED:String = "defaultCategoriesLoaded";
		public static const ALL_CATEGORIES_LOADED:String = "allCategoriesLoaded";
		public static const SET_INITIAL_CATEGORY_FOCUS:String = "setInitialCategoryFocus";
		public static const SET_ALL_CATEGORY_FOCUS:String = "setAllCategoryFocus";
		public static const CATEGORY_SELECTED:String = "categorySelected";
		
		public static const PAUSE_VIDEO:String = "pauseVideo";
		public static const PLAY_VIDEO:String = "playVideo";
		public static const STOP_VIDEO:String = "stopVideo";
		public static const VIDEO_SELECTED:String = "videoSelected";
		
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