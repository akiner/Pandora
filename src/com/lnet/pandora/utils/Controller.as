package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.Session;
	import com.lnet.pandora.command.auth.UserLogin;
	import com.lnet.pandora.command.station.CreateStation;
	import com.lnet.pandora.command.station.GetPlaylist;
	import com.lnet.pandora.command.user.GetStationList;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.response.station.GetPlaylistResponse;
	import com.lnet.pandora.response.station.supportClasses.Station;
	import com.lnet.pandora.response.station.supportClasses.Track;
	
	import flash.events.Event;
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
		private var soundInstance:Sound;
		private var soundChannelInstance:SoundChannel;
		
		private var _currentTrackPos:int;
		private var _selectedStation:Station;
		
		public function Controller() {
			MonsterDebugger.trace("Controller::Controller","Created!");
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.PAUSE_SONG, pauseSong, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.PLAY_SONG, playSong, false, 0, true);
		}

		private function playSong(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::playSong","Play song");
		}

		private function pauseSong(event:ApplicationEvent):void {
			MonsterDebugger.trace("Controller::pauseSong","Pause song");
		}
		
		public function loginUser(u:String,p:String):void {
			try{
				// configure request
				userLoginRequest = new UserLogin();
//				userLoginRequest.username = "daniel.froistad@lodgenet.com";
//				userLoginRequest.password = "kraken987!JJJ";
				userLoginRequest.username = u;
				userLoginRequest.password = p;
				
				userLoginRequest.addEventListener( Event.COMPLETE, onUserLoginComplete );
//				userLoginRequest.addEventListener( Event.FAULT, onUserLoginFault );
				
				userLoginRequest.submit();
			}catch(e:Error){
				MonsterDebugger.trace("Controller::loginUser","Unable to login user...");
				throw new Error("User Login Failed");
			}
		}
		
		private function onUserLoginComplete( e:Event ):void {
			userLoginRequest.removeEventListener( Event.COMPLETE, onUserLoginComplete );
			MonsterDebugger.trace("Controller::onUserLoginComplete","e::"+e);
			getStationList();
		}
		
		private function getStationList():void {
			getStationListRequest = new GetStationList();
			getStationListRequest.includeStationArtUrl = true;
			
			getStationListRequest.addEventListener( Event.COMPLETE, onStationListComplete );
			getStationListRequest.addEventListener( FaultEvent.FAULT, onStationListFault );
			
			getStationListRequest.submit();
		}

		private function onStationListFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onStationListFault","Fault:: " + String( getStationListRequest.fault));
		}
		
		private function onStationListComplete(event:Event):void {
			var stationList:IList = new ArrayCollection();
			
			for (var i:int = 0; i<getStationListRequest.response.stations.elements.length; i++){
				var station:Station = getStationListRequest.response.stations.elements[i] as Station;
				stationList.addItem(station);
			}
			
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STATION_LIST_LOADED,
				stationList));
			
			setSelectedStation(stationList[1]);
		}

		public function setSelectedStation(station:Station):void {
			_selectedStation = station;
			getPlaylist(selectedStation);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.STATION_SELECTED, station));
			MonsterDebugger.trace("Controller::setSelectedStation","Station Selected::"+station.stationName);
		}

		private function getPlaylist(thisStation:Station):void {
			getPlaylistRequest = new GetPlaylist();
			getPlaylistRequest.stationToken = thisStation.stationToken;
		
			getPlaylistRequest.addEventListener( Event.COMPLETE, onPlaylistComplete );
			getPlaylistRequest.addEventListener( FaultEvent.FAULT, onPlaylistFault );
		
			getPlaylistRequest.submit();
		}


		private function onPlaylistFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onPlaylistFault","Fault:: " + String( getPlaylistRequest.fault));
		}

		private function onPlaylistComplete(event:Event):void {
			nextTrackIndex = 0;
			playTrack(getNextTrack());
		}
		
		private function playTrack( track:Track ):void {
			try	{
				if ( soundChannelInstance )
					soundChannelInstance.stop();
				
				if ( soundInstance )
					soundInstance.close();
			} catch (e:Error) {
				MonsterDebugger.trace("PandoraStandalone::playTrack","sound channel stop error " + e);
			}
			
			if( !track ) return;
			
			MonsterDebugger.trace("Controller::playTrack","Playing::"+track.songName);
			MonsterDebugger.trace("Controller::playTrack","AlbumArt::"+track.albumArtUrl);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SONG_LOADED, track));
			
			soundInstance = new Sound();
			soundInstance.load( new URLRequest( track.audioUrl ), new SoundLoaderContext(0, false) );
			soundChannelInstance = soundInstance.play(0,0,null);
			soundChannelInstance.addEventListener( Event.SOUND_COMPLETE, playNextSong );
		}
		
		public function playNextSong(e:Event=null):void {
			playTrack(getNextTrack());
		}

		public function createStation(stationTxt:String):void {
			MonsterDebugger.trace("Controller::createStation","Attempting to create new station for ::"+stationTxt);
			createNewStationRequest = new CreateStation();
			createNewStationRequest.musicToken = stationTxt;
			
			createNewStationRequest.addEventListener( Event.COMPLETE, onCreateStationComplete );
			createNewStationRequest.addEventListener( FaultEvent.FAULT, onCreateStationFault );
			
			createNewStationRequest.submit();
		}

		private function onCreateStationComplete(event:Event):void {
			MonsterDebugger.trace("Controller::onCreateStationComplete","Created station!!!!!!!!!!!"+event);
			MonsterDebugger.trace("Controller::onCreateStationComplete","createNewStationRequest::"+createNewStationRequest.response);
//			var station:Station = createNewStationRequest.response as Station;
		}
		
		private function onCreateStationFault(event:FaultEvent):void {
			MonsterDebugger.trace("Controller::onCreateStationFault","Fault:: " + String( createNewStationRequest.fault));
		}
		
		private function getNextTrack( ):Track {
			var playlist:GetPlaylistResponse = getPlaylistRequest.response;
			var track:Track = null;
			
			for( var i:uint = nextTrackIndex++ ; i < playlist.items.elements.length ; i++ ) {
				if ( ( track = playlist.items.elements[ i ] as Track ) )
					break;
			}
			
			return track;
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