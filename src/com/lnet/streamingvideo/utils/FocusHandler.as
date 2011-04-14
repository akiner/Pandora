package com.lnet.streamingvideo.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	import com.lnet.streamingvideo.views.BrowseView;
	import com.lnet.streamingvideo.views.PlayerView;
	import com.lnet.streamingvideo.views.SearchResultsView;
	
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;

	public class FocusHandler {
		private var currentKey:String;
		
		private var _browseView:BrowseView;
		private var _searchResultsView:SearchResultsView;
		private var _playerView:PlayerView;
		
		public function FocusHandler() {
			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}

		private function handleKeyPress(event:KeyboardEvent):void {
			currentKey = KeyHandler.keyPressed(event.keyCode);
			switch(FlexGlobals.topLevelApplication.currentState) {
				case "default":
					handleKeyPressInBrowseView();
					break;
				case "results":
					handleKeyPressInResultsView();
					break;
				case "videoPlaying":
					handleKeyPressInVideoPlayerView();
					break;
				default:
					MonsterDebugger.trace("FocusHandler::constructor","Keyboard event not handled!!!");
					break;
			}
		}

		private function handleKeyPressInBrowseView():void {
			switch(currentKey) {
				case "select":
					MonsterDebugger.trace("FocusHandler::handleKeyPressInBrowseView","Handling select button");
					browseView.currentState = "lostFocus";
					FlexGlobals.topLevelApplication.currentState = "results";
					FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);
					break;
				default:
					MonsterDebugger.trace("FocusHandler::handleKeyPressInBrowseView","Key not found!!!");
					break;
			}
		}
		
		private function handleKeyPressInResultsView():void {
			switch(currentKey) {
				case "select":
					MonsterDebugger.trace("FocusHandler::handleKeyPressInResultsView","Handling select button");
					FlexGlobals.topLevelApplication.currentState = "videoPlaying";
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.VIDEO_SELECTED, searchResultsView.videoList.selectedItem));
					break;
				case "back":
					MonsterDebugger.trace("FocusHandler::handleKeyPressInResultsView","Handling back button");
					browseView.currentState = "hasFocus";
					searchResultsView.videoList.selectedIndex = 0;
					FlexGlobals.topLevelApplication.currentState = "default";
					FlexGlobals.topLevelApplication.focusManager.setFocus(browseView.categoryList);
					break;
				default:
					MonsterDebugger.trace("FocusHandler::handleKeyPressInResultsView","Key not found!!!");
					break;
			}
		}
		
		private function handleKeyPressInVideoPlayerView():void {
			switch(currentKey) {
				case "back":
					FlexGlobals.topLevelApplication.currentState = "results";
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STOP_VIDEO));
					break;
				case "pause":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PAUSE_VIDEO));
					break;
				case "play":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PLAY_VIDEO));
					break;
				default:
					MonsterDebugger.trace("FocusHandler::handleKeyPressInVideoPlayerView","Key not found!!!");
					break;
			}
		}

		public function get browseView():BrowseView {
			return _browseView;
		}

		public function set browseView(value:BrowseView):void {
			_browseView = value;
		}

		public function get searchResultsView():SearchResultsView {
			return _searchResultsView;
		}

		public function set searchResultsView(value:SearchResultsView):void {
			_searchResultsView = value;
		}

		public function get playerView():PlayerView {
			return _playerView;
		}

		public function set playerView(value:PlayerView):void {
			_playerView = value;
		}
	}
}