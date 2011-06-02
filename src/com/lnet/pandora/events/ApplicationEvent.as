package com.lnet.pandora.events {
	import flash.events.Event;
	
	public class ApplicationEvent extends Event {
		public static const SONG_LOADED:String = "songLoaded";
		public static const STATION_SELECTED:String = "stationSelected";
		public static const NEW_TRACK_REQUESTED:String = "newTrackRequested";
		public static const GET_NEXT_TRACK:String = "getNextTrack";
		public static const SELECT_STATION:String = "selectStation";
		public static const TUNE_TO_STATION:String = "tuneToStation";
		public static const RENAME_STATION:String = "renameStation";
		public static const DELETE_STATION:String = "deleteStation";
		public static const BOOKMARK_ARTIST:String = "bookmarkArtist";
		public static const BOOKMARK_SONG:String = "bookmarkSong";
		public static const ADD_VARIETY_TO_STATION:String = "addVarietyToStation";
		public static const STATION_LIST_LOADED:String = "stationListLoaded";
		public static const UPDATE_SELECTED_INDEX:String = "updateSelectedIndex";
		public static const RESET_FOCUS:String = "resetFocus";
		public static const PLAY_SONG:String = "playSong";
		public static const PAUSE_SONG:String = "pauseSong";
		public static const RATE_SONG:String = "rateSong";
		public static const SLEEP_SONG:String = "sleepSong";
		public static const GET_ARTIST_BIO:String = "getArtistBio";
		public static const ARTIST_BIO_LOADED:String = "artistBioLoaded";
		public static const EXPLAIN_TRACK:String = "explainTrack";
		public static const TRACK_EXPLANATION_LOADED:String = "trackExplanationLoaded";
		public static const LOGIN_ERROR:String = "loginError";
		public static const SOUND_READY:String = "soundReady";
		public static const INIT_OPTIONS_MENU:String = "initOptionsMenu";
		public static const KEY_PRESS_IN_RATING:String = "keyPressInRating";
		public static const KEY_PRESS_IN_STATION:String = "keyPressInStation";
		public static const KEY_PRESS_IN_BOOKMARK:String = "keyPressInBookmark";
		public static const KEY_PRESS_IN_INFO:String = "keyPressInInfo";
		public static const SHOW_ERROR:String = "showError";
		
		public var data:Object;
		public var optionalData:Object;	
		public var optionalData2:Object;
		
		public function ApplicationEvent(type:String, eventData:Object=null, optionalDataField:Object=null, optionalDataField2:Object=null, 
										 bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			data = eventData;
			if(optionalDataField != null) {
				optionalData = optionalDataField;
			}
			if(optionalDataField2 != null) {
				optionalData2 = optionalDataField2;
			}
		}
	}
}