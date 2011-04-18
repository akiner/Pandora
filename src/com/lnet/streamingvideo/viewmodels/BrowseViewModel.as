package com.lnet.streamingvideo.viewmodels {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	[Bindable]
	public class BrowseViewModel extends EventDispatcher{
		private var _defaultCategoryList:IList;
		private var _allCategoryList:IList;
		private var _currentCategoryList:IList;
		
		public function BrowseViewModel() {
			_defaultCategoryList = new ArrayCollection();
			_allCategoryList = new ArrayCollection();
			addEventListeners();
		}
		
		private function addEventListeners():void {
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.DEFAULT_CATEGORIES_LOADED, createDefaultCategoryList,
				false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.ALL_CATEGORIES_LOADED, createAllCategoryList,
				false, 0, true);
		}
		
		public function getCategoryResults(category:String, url:String):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CATEGORY_SELECTED, category, url));
		}
		
		private function createDefaultCategoryList(event:ApplicationEvent):void {
			ApplicationEventBus.getInstance().removeEventListener(ApplicationEvent.DEFAULT_CATEGORIES_LOADED, createDefaultCategoryList);
			var tempCategoryList:ArrayCollection = new ArrayCollection();
			for each(var category:Object in event.data) {
				tempCategoryList.addItem(category);
			}
			defaultCategoryList = tempCategoryList;
		}
		
		private function createAllCategoryList(event:ApplicationEvent):void {
			ApplicationEventBus.getInstance().removeEventListener(ApplicationEvent.ALL_CATEGORIES_LOADED, createAllCategoryList);
			var tempCategoryList:ArrayCollection = new ArrayCollection();
			for each(var category:Object in event.data) {
				tempCategoryList.addItem(category);
			}
			allCategoryList = tempCategoryList;
		}
		
		public function get defaultCategoryList():IList {
			return _defaultCategoryList;
		}
		
		public function set defaultCategoryList(value:IList):void {
			_defaultCategoryList = value;
			currentCategoryList = _defaultCategoryList;
			MonsterDebugger.trace("BrowseViewModel::categoryList","categoryList has been set...dispatching setInitialFocus event...");
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SET_INITIAL_CATEGORY_FOCUS, defaultCategoryList[0]));
		}
		
		public function get allCategoryList():IList {
			return _allCategoryList;
		}
		
		public function set allCategoryList(value:IList):void {
			_allCategoryList = value;
		}

		public function get currentCategoryList():IList {
			return _currentCategoryList;
		}

		public function set currentCategoryList(value:IList):void {
			_currentCategoryList = value;
		}

	}
}