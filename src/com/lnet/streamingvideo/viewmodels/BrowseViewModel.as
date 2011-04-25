package com.lnet.streamingvideo.viewmodels {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	
	[Bindable]
	public class BrowseViewModel extends EventDispatcher{
		private var _defaultCategoryList:XML;
		private var _allCategoryList:XML;
		private var _currentCategoryList:XML;
		private var _allCategoriesActive:Boolean;
		private var _defaultCategoriesActive:Boolean;
		
		public function BrowseViewModel() {
//			_defaultCategoryList = new ArrayCollection();
//			_allCategoryList = new ArrayCollection();
//			addEventListeners();
		}
		
//		private function addEventListeners():void {
//			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.DEFAULT_CATEGORIES_LOADED, createDefaultCategoryList,
//				false, 0, true);
//			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.ALL_CATEGORIES_LOADED, createAllCategoryList,
//				false, 0, true);
//		}
		
		public function getCategoryResults(category:String, url:String):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CATEGORY_SELECTED, category, url));
		}
		
//		private function createDefaultCategoryList(event:ApplicationEvent):void {
//			ApplicationEventBus.getInstance().removeEventListener(ApplicationEvent.DEFAULT_CATEGORIES_LOADED, createDefaultCategoryList);
//			var tempCategoryList:ArrayCollection = new ArrayCollection();
//			for each(var category:Object in event.data) {
//				tempCategoryList.addItem(category);
//			}
//			defaultCategoryList = tempCategoryList;
//		}
		
//		private function createAllCategoryList(event:ApplicationEvent):void {
//			ApplicationEventBus.getInstance().removeEventListener(ApplicationEvent.ALL_CATEGORIES_LOADED, createAllCategoryList);
//			var tempCategoryList:ArrayCollection = new ArrayCollection();
//			for each(var category:Object in event.data) {
//				tempCategoryList.addItem(category);
//			}
//			allCategoryList = tempCategoryList;
//		}
		
		public function get defaultCategoryList():XML {
			return _defaultCategoryList;
		}
		
		public function set defaultCategoryList(value:XML):void {
			_defaultCategoryList = value;
			currentCategoryList = _defaultCategoryList;
			MonsterDebugger.trace("BrowseViewModel::defaultCategoryList","Setting current category list");
		}
		
		public function get allCategoryList():XML {
			return _allCategoryList;
		}
		
		public function set allCategoryList(value:XML):void {
//			var listColl:XMLListCollection = XMLListCollection(value.children());	
			_allCategoryList = value;
		}

		public function get currentCategoryList():XML {
			return _currentCategoryList;
		}

		public function set currentCategoryList(value:XML):void {
			_currentCategoryList = value;
			MonsterDebugger.trace("BrowseViewModel::currentCategoryList","Dispatching event to set focus");
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