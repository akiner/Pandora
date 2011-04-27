package com.lnet.streamingvideo.viewmodels {
	import com.lnet.streamingvideo.data.VideoResultObject;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.IList;
	
	[Bindable]
	public class PlayerViewModel extends EventDispatcher {
		private static const CHROMELESS_PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		private static const EMBEDDED_PLAYER_URL:String = "http://www.youtube.com/v/";
		private var _selectedVideo:VideoResultObject;
		private var _playerSource:String;
		private var _relatedVideos:IList;
		
		public function PlayerViewModel() {
			_playerSource = CHROMELESS_PLAYER_URL;
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.VIDEO_SELECTED, updateSelectedVideo,
				false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.RELATED_VIDEOS_RETURNED, updateRelatedVideos,
				false, 0, true);
		}

		private function updateRelatedVideos(event:ApplicationEvent):void {
			relatedVideos = event.data as IList;
		}

		public function updateSelectedVideo(e:ApplicationEvent):void {
			selectedVideo = e.data as VideoResultObject;
		}

		public function get playerSource():String {
			return _playerSource;
		}

		public function set playerSource(value:String):void {
			_playerSource = value;
		}

		public function get selectedVideo():VideoResultObject {
			return _selectedVideo;
		}

		public function set selectedVideo(value:VideoResultObject):void {
			_selectedVideo = value;
		}

		public function get relatedVideos():IList {
			return _relatedVideos;
		}

		public function set relatedVideos(value:IList):void {
			_relatedVideos = value;
		}

	}
}