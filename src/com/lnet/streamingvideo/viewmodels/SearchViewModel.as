package com.lnet.streamingvideo.viewmodels {
	
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	
	[Bindable]
	public class SearchViewModel extends EventDispatcher {
		private var _searchResultList:IList;
		private var _searchTerm:String;
		
		public function SearchViewModel() {
			_searchResultList = new ArrayCollection();
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SEARCH_RESULTS_RETURNED,
				updateSearchResults, false, 0, true);
		}
		
		private function updateSearchResults(event:ApplicationEvent):void {
			searchResultList = event.data as IList;
			searchTerm = event.optionalData as String;
		}
		
		public function getSearchResults(searchTerm:String):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SEARCH_REQUESTED, searchTerm));
		}

		public function get searchResultList():IList {
			return _searchResultList;
		}

		public function set searchResultList(value:IList):void {
			_searchResultList = value;
		}

		public function get searchTerm():String {
			return _searchTerm;
		}

		public function set searchTerm(value:String):void {
			_searchTerm = value;
		}
	}
}