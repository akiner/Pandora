package com.lnet.streamingvideo.services {
	import com.adobe.serialization.json.JSON;
	import com.lnet.streamingvideo.data.VideoResultObject;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class VideoService extends HTTPService{
		private var params:Object;
		private var _searchTerm:String;
		
		private static const BROWSE_CATEGORIES_URL:String = "http://gdata.youtube.com/schemas/2007/categories.cat";
		private static const API_VERSION:String = "2";
		
		public function VideoService() {
			addServiceEventListeners();
			addApplicationEventListeners();
		}
		
		private function addServiceEventListeners():void {
			this.addEventListener(ResultEvent.RESULT, onServiceResult, false, 0, true);
			this.addEventListener(FaultEvent.FAULT, onServiceFault, false, 0, true);
		}
		
		private function addApplicationEventListeners():void {
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SEARCH_REQUESTED, getSearchResults,
				false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.CATEGORY_SELECTED, getCategoryResults,
				false, 0, true);
		}
		
		private function getCategoryResults(event:ApplicationEvent):void {
			MonsterDebugger.trace("VideoService::getCategoryResults","Getting results for::"+event.data);
			searchTerm = event.data as String;
			url = event.optionalData as String;
			params = new Object();
			params["v"] = API_VERSION;
			params["alt"] = "json";
			params["max-results"] = "8";
			send(params);
		}
		
		private function getSearchResults(event:ApplicationEvent):void {
			MonsterDebugger.trace("VideoService::getSearchResults","Getting search results for::"+event.data);
			searchTerm = event.data as String;
			url = event.optionalData as String;
			params = new Object();
			params["q"] = _searchTerm;
			params["v"] = API_VERSION;
			params["alt"] = "json";
			params["max-results"] = "8";
			send(params);
		}
		
		private function onServiceResult(e:ResultEvent): void {
			var feed:Object = JSON.decode(e.result as String).feed;
			var videoList:Array = feed.entry;
			var resultObjects:Array = [];
			MonsterDebugger.trace("VideoService::onServiceResult","Results returned::"+videoList.length);
			for each(var video:Object in videoList) {
				var resultObj:Object = new VideoResultObject(video);
				resultObjects.push(resultObj);
			}
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SEARCH_RESULTS_RETURNED,
				new ArrayCollection(resultObjects), searchTerm));
		}	
		
		private function onServiceFault(e:FaultEvent):void {
			MonsterDebugger.trace("VideoService::onServiceFault","Fault: " + e.fault.faultString);
		}
		
		public function get searchTerm():String {
			return _searchTerm;
		}
		
		public function set searchTerm(value:String):void {
			_searchTerm = value;
		}
	}
}