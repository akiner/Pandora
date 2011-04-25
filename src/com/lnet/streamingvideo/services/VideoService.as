package com.lnet.streamingvideo.services {
	import com.adobe.serialization.json.JSON;
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.data.VideoResultObject;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	import com.lnet.streamingvideo.utils.TextFormatter;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	public class VideoService extends HTTPService{
		private var params:Object;
		private var resultsLabel:String;
		private var searchTerm:String;
		private var resultsType:String;
		
		private static const BROWSE_CATEGORIES_URL:String = "http://gdata.youtube.com/schemas/2007/categories.cat";
		private static const SEARCH_URL:String = "http://gdata.youtube.com/feeds/api/videos";
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
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.RELATED_VIDEOS_REQUESTED, getRelatedVideos,
				false, 0, true);
		}
		
		private function getCategoryResults(event:ApplicationEvent):void {
			resultsType = "browse";
			searchTerm = event.data as String;
			url = event.optionalData as String;
			params = new Object();
			params["v"] = API_VERSION;
			params["alt"] = "json";
			params["max-results"] = "32";
			params["format"] = "5";
			send(params);
		}
		
		private function getSearchResults(event:ApplicationEvent):void {
			resultsType = "search"
			searchTerm = event.data as String;
			url = SEARCH_URL;
			params = new Object();
			params["q"] = searchTerm;
			params["v"] = API_VERSION;
			params["alt"] = "json";
			params["max-results"] = "32";
			params["format"] = "5";
			send(params);
		}
		
		private function getRelatedVideos(event:ApplicationEvent):void {
			resultsType = "relatedVideos"
			url = event.data.toString();
			MonsterDebugger.trace("VideoService::getRelatedVideos","Attempting to load related videos::"+url);
			params = new Object();
			params["alt"] = "json";
			params["max-results"] = "8";
			params["format"] = "5";
			send(params);
		}
		
		private function onServiceResult(e:ResultEvent): void {
			var feed:Object = JSON.decode(e.result as String).feed;
			var videoList:Array = feed.entry;
			var resultObjects:Array = [];
			for each(var video:Object in videoList) {
				var resultObj:Object = new VideoResultObject(video);
				resultObjects.push(resultObj);
			}
			if (resultsType != "relatedVideos") {
				resultsLabel = configureLabel(feed.openSearch$totalResults.$t);
				ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SEARCH_RESULTS_RETURNED,
					new ArrayCollection(resultObjects), resultsLabel));
			} else {
				ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RELATED_VIDEOS_RETURNED,
					new ArrayCollection(resultObjects)));
			}
		}

		private function configureLabel(numResults:String):String {
			if(resultsType == "search") {
				return TextFormatter.FormatNumWithCommas(numResults) +" search results for '"+searchTerm+"'";
			} else {
				return searchTerm;
			}
		}
		
		private function onServiceFault(e:FaultEvent):void {
			MonsterDebugger.trace("VideoService::onServiceFault","Fault: " + e.fault.faultString);
		}
	}
}