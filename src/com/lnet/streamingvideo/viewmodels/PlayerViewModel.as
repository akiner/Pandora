package com.lnet.streamingvideo.viewmodels {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.data.VideoResultObject;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.EventDispatcher;
	
	[Bindable]
	public class PlayerViewModel extends EventDispatcher {
		private static const CHROMELESS_PLAYER_URL:String = "http://www.youtube.com/apiplayer?version=3";
		private static const EMBEDDED_PLAYER_URL:String = "http://www.youtube.com/v/";
		private var _selectedVideo:VideoResultObject;
		private var _playerSource:String;
		private var _author:String;
		
		public function PlayerViewModel() {
			_playerSource = CHROMELESS_PLAYER_URL;
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.VIDEO_SELECTED, updatePlayerSource,
				false, 0, true);
		}
		
		public function get author():String {
			return _author;
		}

		public function set author(value:String):void {
			_author = value;
		}

		public function updatePlayerSource(e:ApplicationEvent):void {
			selectedVideo = e.data as VideoResultObject;
			MonsterDebugger.trace("PlayerViewModel::setPlayerSource","Updating player source..."+selectedVideo.videoID);
			playerSource = CHROMELESS_PLAYER_URL + selectedVideo.videoID+"?version=3&autoplay=1";
			author = selectedVideo.author;
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
	}
}