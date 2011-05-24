package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.views.CreateNewStationView;
	import com.lnet.pandora.views.LoginView;
	import com.lnet.pandora.views.OptionsPopupView;
	import com.lnet.pandora.views.SongListView;
	import com.lnet.pandora.views.StationListView;
	
	import flash.events.KeyboardEvent;
	
	import mx.core.FlexGlobals;
	import mx.managers.IFocusManagerComponent;
	
	public class FocusHandler {
		private var currentKey:String;
		
		private var _createNewStationView:CreateNewStationView;
		private var _loginView:LoginView;
		private var _songListView:SongListView;
		private var _stationListView:StationListView;
		private var _optionsPopupView:OptionsPopupView;
		private var isTyping:Boolean;
		private var preSearchState:String;
		private var controller:Controller;
		private var optionViewsArray:Array;
		private var optionViewIndex:int = 0;
		
		public static const SEARCH_DEFAULT_TEXT:String = "Begin Typing to Search";
		
		public function FocusHandler() {
			MonsterDebugger.trace("FocusHandler::FocusHandler","Created!");
			isTyping = false;
			controller = new Controller();
			addStageKeyListener();
			optionViewsArray = new Array("rating", "station", "bookmark", "info");
		}

		private function addStageKeyListener():void {
			FlexGlobals.topLevelApplication.stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPress, false, 0, true);
		}

		public function handleKeyPress(event:KeyboardEvent):void {
			MonsterDebugger.trace("FocusHandler::handleKeyPress","Handling Key Press in::"+FlexGlobals.topLevelApplication.currentState);
			if (userIsTyping(event)) {
				if (!isTyping && FlexGlobals.topLevelApplication.currentState == "default"){
					FlexGlobals.topLevelApplication.focusManager.setFocus(createNewStationView.stationName);
					initCreateStation(event);
					
				} else if(!isTyping && FlexGlobals.topLevelApplication.currentState == "login") {
					isTyping = true;
					loginView.username.cursorManager.hideCursor();
				}
			} else {
				currentKey = KeyHandler.keyPressed(event.keyCode);
				switch(FlexGlobals.topLevelApplication.currentState) {
					case "login":
						handleKeyPressInLoginView();
						break;
					case "createStation":
						handleKeyPressInCreateStationView();
						break;
					case "viewOptions":
						handleKeyPressInOptionsView();
						break;
					case "default":
						handleKeyPressInDefaultView();
						break;
					default:
						MonsterDebugger.trace("FocusHandler::constructor","Keyboard event not handled!!!");
						break;
				}
			}
		}
		
		private function handleKeyPressInDefaultView():void {
			switch(currentKey) {
				case "select":
					FlexGlobals.topLevelApplication.currentState = "viewOptions";
					FlexGlobals.topLevelApplication.focusManager.setFocus(optionsPopupView.hiddenOptionsList);
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SET_FOCUS_TO_RATING));
					break;
				case "rightArrow":
				case "skipForward":
					controller.playNextSong();
					break;
				case "play":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PLAY_SONG));
					break;
				case "pause":
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.PAUSE_SONG));
					break;
				case "back":
					// Pass off to exit service
					break;
				default:
					break;
			}
		}
		
		private function handleKeyPressInOptionsView():void {
			switch(currentKey) {
				case "select":
				case "downArrow":
				case "upArrow":
					switch(optionsPopupView.currentState) {
						case "rating":
							MonsterDebugger.trace("FocusHandler::handleKeyPressInOptionsView","Rating View");
							optionViewIndex = 0;
							ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.KEY_PRESS_IN_RATING, currentKey));
							break;
						case "station":
							MonsterDebugger.trace("FocusHandler::handleKeyPressInOptionsView","Station View");
							optionViewIndex = 1;
							break;
						case "bookmark":
							MonsterDebugger.trace("FocusHandler::handleKeyPressInOptionsView","Bookmark View");
							optionViewIndex = 2;
							break;
						case "info":
							MonsterDebugger.trace("FocusHandler::handleKeyPressInOptionsView","Info View");
							optionViewIndex = 3;
							break;
						default:
							break;
					}
					break;
				case "back":
					resetToDefaultView();
					break;
				case "rightArrow":
					navigationOptionViewRight();
					break;
				case "leftArrow":
					navigationOptionViewLeft();
					break;
				default:
					break;
			}
		}

		private function navigationOptionViewLeft():void {
			if(optionViewIndex > 0) {
				optionViewIndex--;
			} else {
				optionViewIndex = optionViewsArray.length - 1;
			}
			optionsPopupView.currentState = optionViewsArray[optionViewIndex];
		}

		private function navigationOptionViewRight():void {
			if(optionViewIndex < optionViewsArray.length - 1){
				optionViewIndex++;
			} else {
				optionViewIndex = 0;
			}
			optionsPopupView.currentState = optionViewsArray[optionViewIndex];
		}


		private function resetToDefaultView():void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
		}

		
		private function handleKeyPressInLoginView():void {
			switch(currentKey) {
				case "select":
					MonsterDebugger.trace("FocusHandler::handleKeyPressInLoginView","Attempting to login user");
					isTyping = false;
					controller.loginUser(loginView.username.text, loginView.password.text);
					break;
				case "downArrow":
					var nextComponent:IFocusManagerComponent = loginView.focusManager.getNextFocusManagerComponent();
					loginView.focusManager.setFocus(nextComponent);    
					break;
				case "upArrow":
					var prevComponent:IFocusManagerComponent = loginView.focusManager.getNextFocusManagerComponent();
					loginView.focusManager.setFocus(prevComponent);    
					break;
				default:
					break;
			}
		}
		
		private function handleKeyPressInCreateStationView():void {
			switch(currentKey) {
				case "select":
					controller.createNewStation(createNewStationView.stationName.text);
					exitCreateStationView();
					break;
				case "back":
					exitCreateStationView();
					break;
				default:
					break;
			}
		}
		
		private function exitCreateStationView():void {
			isTyping = false;
			createNewStationView.stationName.text = SEARCH_DEFAULT_TEXT;
			createNewStationView.currentState = "default";
			resetToDefaultView();
		}
		
		private function userIsTyping(event:KeyboardEvent):Boolean {
			if(KeyHandler.isAlphaKey(event.keyCode) || KeyHandler.isNumericKey(event.keyCode)) {
				return true;
			} else {
				return false;
			}
		}
		
		private function initCreateStation(event:KeyboardEvent):void {
			MonsterDebugger.trace("FocusHandler::initCreateStation","Initializing create station...");
			isTyping = true;
			FlexGlobals.topLevelApplication.currentState = "createStation";
			createNewStationView.stationName.text = "";
			createNewStationView.currentState = "selected";
			createNewStationView.stationName.insertText(String.fromCharCode(event.charCode));
			createNewStationView.stationName.cursorManager.showCursor();
		}
		
		public function get createNewStationView():CreateNewStationView {
			return _createNewStationView;
		}
		
		public function set createNewStationView(value:CreateNewStationView):void {
			_createNewStationView = value;
		}
		
		public function get loginView():LoginView {
			return _loginView;
		}
		
		public function set loginView(value:LoginView):void {
			_loginView = value;
		}
		
		public function get songListView():SongListView {
			return _songListView;
		}
		
		public function set songListView(value:SongListView):void {
			_songListView = value;
		}
		
		public function get stationListView():StationListView {
			return _stationListView;
		}
		
		public function set stationListView(value:StationListView):void {
			_stationListView = value;
		}

		public function get optionsPopupView():OptionsPopupView {
			return _optionsPopupView;
		}

		public function set optionsPopupView(value:OptionsPopupView):void {
			_optionsPopupView = value;
		}
	}
}