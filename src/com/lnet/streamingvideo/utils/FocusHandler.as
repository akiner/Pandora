package com.lnet.streamingvideo.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	import com.lnet.streamingvideo.views.BrowseView;
	import com.lnet.streamingvideo.views.PlayerView;
	import com.lnet.streamingvideo.views.SearchResultsView;
	import com.lnet.streamingvideo.views.SearchView;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;

	public class FocusHandler {
		private var currentKey:String;
		
		private var _browseView:BrowseView;
		private var _searchView:SearchView;
		private var _searchResultsView:SearchResultsView;
		private var _playerView:PlayerView;
		private var isTyping:Boolean;
		
		public function FocusHandler() {
			isTyping = false;
			FlexGlobals.topLevelApplication.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}

		private function handleKeyPress(event:KeyboardEvent):void {
			// Check if key pressed was a letter or a number
			if (KeyHandler.isNumericKey(event.keyCode) || KeyHandler.isAlphaKey(event.keyCode)) {
				var searchTerm:String = "";
				if(!isTyping) {
					isTyping = true;
//					FlexGlobals.topLevelApplication.focusManager.setFocus(searchView.searchTxt);
					FlexGlobals.topLevelApplication.currentState = "search";
					searchView.searchTxt.text = searchTerm;
					searchTerm.concat("a");
					searchView.searchTxt.text = searchTerm;
	//				ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SEARCH_INITIATED, event.keyCode));
				} else {
					searchTerm.concat("a");
					searchView.searchTxt.text = searchTerm;
				}
			} else {
				// If it isn't - check what other function key was pressed
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
		}

		private function handleKeyPressInBrowseView():void {
			switch(currentKey) {
				case "select":
					MonsterDebugger.trace("FocusHandler::handleKeyPressInBrowseView","Handling select button");
					MonsterDebugger.trace("FocusHandler::handleKeyPressInBrowseView","Current Category::"+browseView.categoryList.selectedItem.name);
					if (browseView.categoryList.selectedItem.name == "All Categories") {
						
					} else {
						browseView.currentState = "lostFocus";
						FlexGlobals.topLevelApplication.currentState = "results";
						FlexGlobals.topLevelApplication.focusManager.setFocus(searchResultsView.videoList);
					}
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

		public function get searchView():SearchView {
			return _searchView;
		}

		public function set searchView(value:SearchView):void {
			_searchView = value;
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