package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.command.auth.UserLogin;
	import com.lnet.pandora.command.bookmark.AddArtistBookmark;
	import com.lnet.pandora.command.bookmark.AddSongBookmark;
	import com.lnet.pandora.command.music.Search;
	import com.lnet.pandora.command.station.AddFeedback;
	import com.lnet.pandora.command.station.AddMusic;
	import com.lnet.pandora.command.station.CreateStation;
	import com.lnet.pandora.command.station.DeleteStation;
	import com.lnet.pandora.command.station.GetPlaylist;
	import com.lnet.pandora.command.station.RenameStation;
	import com.lnet.pandora.command.track.ExplainTrack;
	import com.lnet.pandora.command.user.GetStationList;
	import com.lnet.pandora.command.user.SleepSong;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.response.music.SearchResponse;
	import com.lnet.pandora.response.station.CreateStationResponse;
	import com.lnet.pandora.response.station.GetPlaylistResponse;
	import com.lnet.pandora.response.station.supportClasses.Station;
	import com.lnet.pandora.response.station.supportClasses.Track;
	import com.lnet.pandora.response.track.ExplainTrackResponse;
	import com.lnet.pandora.views.StationList;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.rpc.events.FaultEvent;
	
	public class Controller {
		private var nextTrackIndex:uint = 0;
		private var userLoginRequest:UserLogin;
		private var getStationListRequest:GetStationList;
		private var getPlaylistRequest:GetPlaylist;
		private var createNewStationRequest:CreateStation;
		private var addFeedbackRequest:AddFeedback;
		private var sleepSongRequest:SleepSong;
		private var renameStationRequest:RenameStation;
		private var deleteStationRequest:DeleteStation;
		private var bookmarkArtistRequest:AddArtistBookmark;
		private var bookmarkSongRequest:AddSongBookmark;
		private var addMusicRequest:AddMusic;
		private var explainTrackRequest:ExplainTrack;
		private var soundInstance:Sound;
		private var soundChannelInstance:SoundChannel;
		private var soundPosition:Number;
		private var musicSearchRequest:Search;
		private var stationList:IList;
		private var currentTrack:Track;
		private var createdStationId:String;
		
		private var _currentTrackPos:int;
		private var _selectedStation:Station;
		
		public function Controller() {
			MonsterDebugger.trace("Controller::Controller","Created!");
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SELECT_STATION, setSelectedStation, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.PAUSE_SONG, pauseSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.PLAY_SONG, playSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.RATE_SONG, rateSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SLEEP_SONG, sleepSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.RENAME_STATION, renameStation, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.DELETE_STATION, deleteStation, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.ADD_VARIETY_TO_STATION, addVarietyToStation, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.BOOKMARK_ARTIST, bookmarkArtist, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.BOOKMARK_SONG, bookmarkSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.GET_ARTIST_BIO, getArtistBio, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.EXPLAIN_TRACK, explainTrack, false, 0, true);
		}

		private function explainTrack(event:ApplicationEvent):void {
			explainTrackRequest = new ExplainTrack;
			explainTrackRequest.trackToken = currentTrack.trackToken;
			
			explainTrackRequest.addEventListener(Event.COMPLETE, explainTrackComplete);
			explainTrackRequest.addEventListener(FaultEvent.FAULT, explainTrackFault);
			explainTrackRequest.submit();
		}
		
		private function explainTrackComplete(event:Event):void {
			var explainTrackResponse:ExplainTrackResponse = explainTrackRequest.response as ExplainTrackResponse;
			var i:int;
			
			var responseString:String = "Based on what you've told us so far, we are playing this song because it features ";
			
			for (i = 0; i < explainTrackResponse.explanations.elements.length; i++){
				responseString += explainTrackResponse.explanations.elements[i].focusTraitName;
				
				if (i < explainTrackResponse.explanations.elements.length - 1) {
					responseString += ", ";
				}
			}
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TRACK_EXPLANATION_LOADED, responseString));
			MonsterDebugger.trace("Controller::explainTrackComplete","Track has been explained");
		}
		
		private function explainTrackFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::explainTrackComplete","ERROR::"+event.fault.faultString);
			var errorMsg:String = "An unexpected error has occurred while attempting to load the track explanation. Please try again."
			displayErrorToUser(errorMsg);
		}

		private function getArtistBio(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::getArtistBio","Getting artist bio...");
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.ARTIST_BIO_LOADED, currentTrack.artistDetailUrl));
		}

		private function bookmarkSong(event:ApplicationEvent):void {
			bookmarkSongRequest = new AddSongBookmark();
			bookmarkSongRequest.trackToken = currentTrack.trackToken;
			
			bookmarkSongRequest.addEventListener(Event.COMPLETE, addBookmarkComplete);
			bookmarkSongRequest.addEventListener(FaultEvent.FAULT, addBookmarkFault);
			
			bookmarkSongRequest.submit();
		}

		private function bookmarkArtist(event:ApplicationEvent):void {
			bookmarkArtistRequest = new AddArtistBookmark();
			bookmarkArtistRequest.trackToken = currentTrack.trackToken;
			
			bookmarkArtistRequest.addEventListener(Event.COMPLETE, addBookmarkComplete);
			bookmarkArtistRequest.addEventListener(FaultEvent.FAULT, addBookmarkFault);
			
			bookmarkArtistRequest.submit();
		}
		
		private function addBookmarkComplete(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			MonsterDebugger.trace("Controller::addBookmarkComplete","Bookmark sucessfully added");
		}
		
		private function addBookmarkFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::addBookmarkFault","ERROR::"+event.fault);
			var errorMsg:String = "An unexpected error has occurred while attempting to add your bookmark. Please try again."
			displayErrorToUser(errorMsg);
		}

		private function addVarietyToStation(event:ApplicationEvent):void {
			var searchText:String = event.data as String;
			
			musicSearchRequest = new Search();
			musicSearchRequest.searchText = searchText;
			musicSearchRequest.includeNearMatches = true;
			
			musicSearchRequest.addEventListener(Event.COMPLETE, addVarietyToStationHandler, false, 0, true);
			musicSearchRequest.addEventListener(FaultEvent.FAULT, onMusicSearchFault, false, 0, true);
			
			MonsterDebugger.trace("Controller::addVarietyToStation","Searching for music token to add varietty");
			musicSearchRequest.submit();
		}
		
		private function onVarietySearchComplete(event:Event):void {
			var responseArray:IList = new ArrayCollection();
			var searchResponse:SearchResponse = musicSearchRequest.response as SearchResponse;
			var i:int;
			
			for (i = 0; i < searchResponse.artists.elements.length; i++){ // TODO:: include song results not just artists
				responseArray.addItem(searchResponse.artists.elements[i]);
			}
			
			responseArray.toArray().sortOn("score");
			
			addVarietyToStationHandler(responseArray[0].musicToken);
		}
		
		private function addVarietyToStationHandler(musicToken:String):void {
			MonsterDebugger.trace("Controller::addVarietyToStationHandler","Attempting to add variety::stationToken::"+selectedStation.stationToken);
			MonsterDebugger.trace("Controller::addVarietyToStationHandler","Attempting to add variety::musicToken::"+musicToken);
			addMusicRequest = new AddMusic();
			addMusicRequest.stationToken = selectedStation.stationToken;
			addMusicRequest.musicToken = musicToken;
			
			addMusicRequest.addEventListener(Event.COMPLETE, onAddVarietyComplete);
			addMusicRequest.addEventListener(FaultEvent.FAULT, onAddVarietyFault);
			
			addMusicRequest.submit();
		}

		private function onAddVarietyComplete(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			MonsterDebugger.trace("Controller::onAddVarietyComplete","Sucessfully added music to the station");
		}
		
		private function onAddVarietyFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onAddVarietyFault","ERROR::"+event.fault);
			var errorMsg:String = "An unexpected error has occurred while attempting to add music to this station. Please try again."
			displayErrorToUser(errorMsg);
		}

		private function deleteStation(event:ApplicationEvent):void {
			deleteStationRequest = new DeleteStation();
			deleteStationRequest.stationToken = selectedStation.stationToken;
			
			deleteStationRequest.addEventListener( Event.COMPLETE, onDeleteComplete );
			deleteStationRequest.addEventListener( FaultEvent.FAULT, onDeleteFault );
			
			deleteStationRequest.submit();
		}

		private function onDeleteComplete(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			getStationList();
			MonsterDebugger.trace("Controller::onDeleteComplete","Delete request complete - reload station list");
		}

		private function onDeleteFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onDeleteFault","ERROR::"+event.fault);
			var errorMsg:String = "An unexpected error has occurred while attempting to delete this station. Please try again."
			displayErrorToUser(errorMsg);
		}

		private function renameStation(event:ApplicationEvent):void {
			var newStationName:String = event.data as String;
			
			renameStationRequest = new RenameStation();
			renameStationRequest.stationName = newStationName;
			renameStationRequest.stationToken = selectedStation.stationToken;
			
			renameStationRequest.addEventListener( Event.COMPLETE, onRenameComplete );
			renameStationRequest.addEventListener( FaultEvent.FAULT, onRenameFault );
			
			renameStationRequest.submit();
			
			selectedStation.stationName = newStationName;
		}

		private function onRenameFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onRenameComplete","ERROR::"+event.fault);
			var errorMsg:String = "An unexpected error has occurred while attempting to rename this station. Please try again."
			displayErrorToUser(errorMsg);
		}

		private function onRenameComplete(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			MonsterDebugger.trace("Controller::onRenameComplete","Rename was successfull!");
		}

		private function rateSong(event:ApplicationEvent):void {
			var isPositive:Boolean = event.data as Boolean;
			
			addFeedbackRequest = new AddFeedback();
			addFeedbackRequest.isPositive = isPositive;
			addFeedbackRequest.trackToken = currentTrack.trackToken;
			
			addFeedbackRequest.addEventListener( Event.COMPLETE, onFeedbackComplete );
			addFeedbackRequest.addEventListener( FaultEvent.FAULT, onFeedbackFault );
			
			addFeedbackRequest.submit();
			
			currentTrack.songRating = (isPositive) ? 1 : -1;
			
			if (!isPositive) getPlaylist();
		}

		private function onFeedbackComplete(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			MonsterDebugger.trace("Controller::onFeedbackComplete","Rating was successfull!");
		}
		
		private function onFeedbackFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onFeedbackFault","ERROR::"+event.fault);
			var errorMsg:String = "An unexpected error has occurred while attempting to rate this song. Please try again."
			displayErrorToUser(errorMsg);
		}
		
		private function sleepSong(event:ApplicationEvent):void {
			sleepSongRequest = new SleepSong();
			sleepSongRequest.trackToken = currentTrack.trackToken;
			
			sleepSongRequest.addEventListener(Event.COMPLETE, onSleepComplete);
			sleepSongRequest.addEventListener(FaultEvent.FAULT, onFeedbackFault);
			
			sleepSongRequest.submit();
		}
		
		private function onSleepComplete(event:Event):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			MonsterDebugger.trace("Controller::onFeedbackComplete","Sleep was successfull!");
			getPlaylist();
		}
		
		private function playSong(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::playSong","Play song");
			soundChannelInstance = soundInstance.play(soundPosition);
		}
		
		private function pauseSong(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::pauseSong","Pause song");
			soundPosition = soundChannelInstance.position;
			soundChannelInstance.stop();
		}
		
		public function loginUser(u:String,p:String):void {
			userLoginRequest = new UserLogin();
			userLoginRequest.username = u;
			userLoginRequest.password = p;
			
			userLoginRequest.addEventListener( Event.COMPLETE, onUserLoginComplete );
			userLoginRequest.addEventListener( FaultEvent.FAULT, onUserLoginFault );
			try{
				userLoginRequest.submit();
			}catch(e:Error){
				try{
					userLoginRequest.submit();
				}catch(e:Error){
					MonsterDebugger.trace("Controller::loginUser","Unable to login user...");
					var errorMsg:String = "An error has occurred with the login service. Please try again.";
					ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.LOGIN_ERROR, errorMsg));
				}
			}
		}
		
		private function onUserLoginFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onUserLoginFault","Fault:: " + String( userLoginRequest.fault));
			var errorMsg:String = "Invalid email or password. Please try again.";
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.LOGIN_ERROR, errorMsg));
		}
		
		private function onUserLoginComplete(e:Event):void {
			userLoginRequest.removeEventListener(Event.COMPLETE, onUserLoginComplete);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.RESET_FOCUS));
			getStationList();
		}
		
		private function getStationList():void {
			getStationListRequest = new GetStationList();
			getStationListRequest.includeStationArtUrl = true;
			getStationListRequest.sortField = "dateCreated";
			getStationListRequest.sortOrder = "desc";
			
			getStationListRequest.addEventListener( Event.COMPLETE, onStationListComplete );
			getStationListRequest.addEventListener( FaultEvent.FAULT, onStationListFault );
			getStationListRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			getStationListRequest.submit();
		}
		
		private function onIOError(event:IOErrorEvent):void {
			MonsterDebugger.trace("Controller::onIOError","IOERROR!!!!!!!!!!!!!" + event.text);
		}
		
		private function onStationListFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onStationListFault","Fault:: " + String(getStationListRequest.fault));
		}
		
		private function onStationListComplete(event:Event):void {
			stationList = new ArrayCollection();
			
			for (var i:int = 0; i<getStationListRequest.response.stations.elements.length; i++){
				var station:Station = getStationListRequest.response.stations.elements[i] as Station;
				stationList.addItem(station);
			}
			
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STATION_LIST_LOADED,
				stationList));
			
			if (createdStationId) {
				MonsterDebugger.trace("Controller::onStationListComplete","Station has just been created - tune to it");
				for(var ii:int = 0; ii<stationList.length; ii++) {
					var thisStation:Station = stationList[ii] as Station;
					if(thisStation.stationId == createdStationId) {
						MonsterDebugger.trace("Controller::onStationListComplete","Found station - tune to::"+thisStation.stationName);
						ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TUNE_TO_STATION, ii));
						break;
					}
				}
			} else {
				MonsterDebugger.trace("Controller::onStationListComplete","Tune to 1st station in list");
				ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.TUNE_TO_STATION, 1));
			}
		}
		
		public function setSelectedStation(event:ApplicationEvent):void {
			_selectedStation = event.data as Station;
			getPlaylist();
			_currentTrackPos = 0;
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STATION_SELECTED, selectedStation));
			MonsterDebugger.trace("Controller::setSelectedStation","Station Selected::"+selectedStation.stationName);
		}
		
		private function getPlaylist():void {
			getPlaylistRequest = new GetPlaylist();
			getPlaylistRequest.stationToken = selectedStation.stationToken;
			
			getPlaylistRequest.addEventListener( Event.COMPLETE, onPlaylistComplete );
			getPlaylistRequest.addEventListener( FaultEvent.FAULT, onPlaylistFault );
			getPlaylistRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			getPlaylistRequest.submit();
		}
		
		private function onPlaylistFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onPlaylistFault","Fault:: " + String( getPlaylistRequest.fault));
		}
		
		private function onPlaylistComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onPlaylistComplete","Playlist Complete - load first track");
			nextTrackIndex = 0;
			playTrack(getNextTrack());
		}
		
		public function getNextTrack(e:Event=null):Track {
			var playlist:GetPlaylistResponse = getPlaylistRequest.response;
			var track:Track = null;
			
			if (!playlist) return track;
			
			for( var i:uint = nextTrackIndex++ ; i < playlist.items.elements.length ; i++ ) {
				if ( ( track = playlist.items.elements[ i ] as Track ) ) // TODO:: determine if there was an ad returned and display
					break;
			}
			currentTrack = track;
			_currentTrackPos ++;
			return track;
		}
		
		private function playTrack(track:Track):void {
			try	{
				if (soundChannelInstance) soundChannelInstance.stop();
				if (soundInstance) soundInstance.close();
			} catch (e:Error) {
				MonsterDebugger.trace("PandoraStandalone::playTrack","sound channel stop error " + e);
			}
			
			if(!track) return;
			
			soundInstance = new Sound();
			
			soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioSoundError);
			soundInstance.addEventListener(Event.COMPLETE, soundLoaded);
			
			var req:URLRequest =  new URLRequest( track.audioUrl );
			var context:SoundLoaderContext = new SoundLoaderContext(0, false);
			
			try {
				soundInstance.load(req, context);
				soundChannelInstance = soundInstance.play();
				soundChannelInstance.addEventListener(Event.SOUND_COMPLETE, playNextSong);
				ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SONG_LOADED, track));
			}
			catch (err:Error) {
				MonsterDebugger.trace("Controller::playTrack","ERROR::"+err.message);
				var errorMsg:String = "We are having trouble playing the current track. Please stand by."
				displayErrorToUser(errorMsg);
			}
		}
		
		private function soundLoaded(event:Event):void {
			var currentTime:uint = Math.round(soundChannelInstance.position/1000);
			var totalTime:uint = Math.round(soundInstance.length/1000);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SOUND_READY,
				soundInstance, soundChannelInstance, totalTime));
		}
		
		private function ioSoundError(e:IOErrorEvent):void {
			MonsterDebugger.trace("PandoraStandalone::ioSoundError","sound channel ioSoundError " + e.text);
			playNextSong();
		}
		
		public function playNextSong(e:Event=null):void {
			MonsterDebugger.trace("Controller::playTrack","Playing song::"+currentTrackPos);
			if(currentTrackPos % 3 == 0) {
				MonsterDebugger.trace("Controller::playTrack","Playing third song - need to grab new playlist");
				getPlaylist();
			} else {
				playTrack(getNextTrack());
			}
		}
		
		public function createNewStation(stationTxt:String):void {
			MonsterDebugger.trace("Controller::createStation","Attempting to create new station for ::"+stationTxt);
			
			musicSearchRequest = new Search();
			musicSearchRequest.searchText = stationTxt;
			musicSearchRequest.includeNearMatches = true;
			
			musicSearchRequest.addEventListener(Event.COMPLETE, onMusicSearchComplete, false, 0, true);
			musicSearchRequest.addEventListener(FaultEvent.FAULT, onMusicSearchFault, false, 0, true);
			
			musicSearchRequest.submit();
		}
		
		private function onMusicSearchComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onMusicSearchComplete","response::"+musicSearchRequest.response);
			MonsterDebugger.trace("Controller::onMusicSearchComplete","songs::"+musicSearchRequest.response.songs.elements.length);
			MonsterDebugger.trace("Controller::onMusicSearchComplete","artists::"+musicSearchRequest.response.artists.elements.length);
			
			var responseArray:IList = new ArrayCollection();
			var searchResponse:SearchResponse = musicSearchRequest.response as SearchResponse;
			var i:int;
			
			for (i = 0; i < searchResponse.artists.elements.length; i++){ // TODO:: include song results not just artists
				responseArray.addItem(searchResponse.artists.elements[i]);
			}
			
			responseArray.toArray().sortOn("score");
			
			createStation(responseArray[0].musicToken);
		}
		
		private function onMusicSearchFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onMusicSearchFault","Fault:: " + String( musicSearchRequest.fault));
			var errorMsg:String = "An unexpected error has occurred while attempting to create your station. Please try again."
			displayErrorToUser(errorMsg);
		}
		
		private function createStation(token:String):void {
			createNewStationRequest = new CreateStation();
			createNewStationRequest.musicToken = token;
			
			createNewStationRequest.addEventListener( Event.COMPLETE, onCreateStationComplete );
			createNewStationRequest.addEventListener( FaultEvent.FAULT, onCreateStationFault );
			createNewStationRequest.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			
			createNewStationRequest.submit();
		}
		
		private function onCreateStationComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onCreateStationComplete","createNewStationRequest::"+createNewStationRequest.response);
			var stationResponse:CreateStationResponse = createNewStationRequest.response as CreateStationResponse;
			createdStationId = stationResponse.stationId;
			getStationList();
		}
		
		private function onCreateStationFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onCreateStationFault","Fault:: " + String( createNewStationRequest.fault));
			var errorMsg:String = "An unexpected error has occurred while attempting to create your station. Please try again.";
			displayErrorToUser(errorMsg);
		}
		
		private function displayErrorToUser(msg:String):void {
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SHOW_ERROR, msg));
		}


		public function get currentTrackPos():int {
			return _currentTrackPos;
		}

		public function set currentTrackPos(value:int):void {
			_currentTrackPos = value;
		}

		public function get selectedStation():Station {
			return _selectedStation;
		}

		public function set selectedStation(value:Station):void {
			_selectedStation = value;
		}

	}
}