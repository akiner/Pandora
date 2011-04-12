package com.lnet.streamingvideo.viewmodels {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.data.VideoResultObject;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.Application;
	
	[Bindable]
	public class BrowseViewModel extends EventDispatcher{
		private var _categoryList:IList;
		private var _topCategoryList:IList;
		
		public function BrowseViewModel() {
			_categoryList = new ArrayCollection();
			_topCategoryList = new ArrayCollection();
			addEventListeners();
		}
		
		private function addEventListeners():void {
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.CATEGORIES_LOADED, createCategoryList,
				false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.TOP_CATEGORIES_LOADED, createTopCategoryList,
				false, 0, true);
		}
		
		public function getCategoryResults(category:String, url:String):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CATEGORY_SELECTED, category, url));
		}
		
		private function createCategoryList(event:ApplicationEvent):void {
			ApplicationEventBus.getInstance().removeEventListener(ApplicationEvent.CATEGORIES_LOADED, createCategoryList);
			var tempCategoryList:ArrayCollection = new ArrayCollection();
			for each(var category:Object in event.data) {
				tempCategoryList.addItem(category);
			}
			categoryList = tempCategoryList;
		}
		
		private function createTopCategoryList(event:ApplicationEvent):void {
			ApplicationEventBus.getInstance().removeEventListener(ApplicationEvent.TOP_CATEGORIES_LOADED, createTopCategoryList);
			var tempCategoryList:ArrayCollection = new ArrayCollection();
			for each(var category:Object in event.data) {
				tempCategoryList.addItem(category);
			}
			topCategoryList = tempCategoryList;
		}
		
		public function get categoryList():IList {
			return _categoryList;
		}
		
		public function set categoryList(value:IList):void {
			_categoryList = value;
			MonsterDebugger.trace("BrowseViewModel::categoryList","categoryList has been set...dispatching setInitialFocus event...");
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SET_INITIAL_CATEGORY_FOCUS, categoryList[0]));
		}
		
		public function get topCategoryList():IList {
			return _topCategoryList;
		}
		
		public function set topCategoryList(value:IList):void {
			_topCategoryList = value;
		}
	}
}