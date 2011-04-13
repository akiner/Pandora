package com.lnet.streamingvideo.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends Event {
		public static const STARTUP_COMPLETED:String = "startupCompleted";
		public static const SEARCH_REQUESTED:String = "searchRequested";
		public static const SEARCH_RESULTS_RETURNED:String = "searchResultsReturned";
		public static const VIDEO_SELECTED:String = "videoSelected";
		public static const CATEGORIES_LOADED:String = "categoriesLoaded";
		public static const TOP_CATEGORIES_LOADED:String = "topCategoriesLoaded";
		public static const CATEGORY_SELECTED:String = "categorySelected";
		public static const NAVIGATE_CATEGORIES:String = "navigateCategories";
		public static const SET_FOCUS_TO_RESULTS:String = "setFocusToResults";
		public static const SET_INITIAL_CATEGORY_FOCUS:String = "setInitialCategoryFocus";
		public static const PLAY_SELECTED_VIDEO:String = "playSelectedVideo";
		
		public var data:Object;
		public var optionalData:Object;
		
		public function ApplicationEvent(type:String, eventData:Object=null, optionalDataField:Object=null, 
										 bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			data = eventData;
			if(optionalDataField != null) {
				optionalData = optionalDataField;
			}
			if(optionalDataField != null) {
				optionalData = optionalDataField;
			}
		}
	}
}