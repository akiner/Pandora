package com.lnet.streamingvideo.viewmodels {
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class BrowseViewModel extends EventDispatcher{
		private var _defaultCategoryList:XML;
		private var _allCategoryList:XML;
		private var _currentCategoryList:XML;
		private var _allCategoriesActive:Boolean;
		private var _defaultCategoriesActive:Boolean;
		
		public function getCategoryResults(category:String, url:String):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CATEGORY_SELECTED, category, url));
		}
		
		public function get defaultCategoryList():XML {
			return _defaultCategoryList;
		}
		
		public function set defaultCategoryList(value:XML):void {
			_defaultCategoryList = value;
			currentCategoryList = _defaultCategoryList;
		}
		
		public function get allCategoryList():XML {
			return _allCategoryList;
		}
		
		public function set allCategoryList(value:XML):void {
			_allCategoryList = value;
		}

		public function get currentCategoryList():XML {
			return _currentCategoryList;
		}

		public function set currentCategoryList(value:XML):void {
			_currentCategoryList = value;
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SET_INITIAL_CATEGORY_FOCUS, _currentCategoryList.children()[0]));
		}

		public function get allCategoriesActive():Boolean {
			return _allCategoriesActive;
		}

		public function set allCategoriesActive(value:Boolean):void {
			_allCategoriesActive = value;
		}

		public function get defaultCategoriesActive():Boolean {
			return _defaultCategoriesActive;
		}

		public function set defaultCategoriesActive(value:Boolean):void {
			_defaultCategoriesActive = value;
		}
	}
}