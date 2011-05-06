package com.lnet.pandora.utils {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.Session;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.response.station.GetPlaylistResponse;
	import com.lnet.pandora.response.station.supportClasses.Track;
	
	import flash.events.Event;

	public class Controller {
		private var nextTrackIndex:uint = 0;
		
		public function Controller() {
			MonsterDebugger.trace("Controller::Controller","Created!");
		}
		
		public function loginUser(u:String,p:String):void {
			Session.instance.addEventListener( "PlaylistReady", onPlaylistReady );
//			Session.instance.login( "daniel.froistad@lodgenet.com", "kraken987!JJJ" );
			Session.instance.login( u, p );
		}
		
		private function onPlaylistReady( e:Event ):void {
			nextTrackIndex = 0;
			playTrack( getNextTrack() );
		}
		
		private function playTrack( track:Track ):void {
			//				try	{
			//					if ( soundChannelInstance )
			//						soundChannelInstance.stop();
			//					
			//					if ( soundInstance )
			//						soundInstance.close();
			//				} catch (e:Error) {
			//					MonsterDebugger.trace("PandoraStandalone::playTrack","sound channel stop error " + e);
			//				}
			
			if( !track ) return;
			
			MonsterDebugger.trace("PandoraStandalone::playTrack","Playing::"+track.songName);
			MonsterDebugger.trace("PandoraStandalone::playTrack","AlbumArt::"+track.albumArtUrl);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.SONG_LOADED, track));
			
			//				artist.text = track.artistName;
			//				album.text = track.albumName;
			//				song.text = track.songName;
			//				albumArt.source = track.albumArtUrl;
			
			//				soundInstance = new Sound();
			//				soundInstance.load( new URLRequest( track.audioUrl ), new SoundLoaderContext(0, false) );
			//				soundChannelInstance = soundInstance.play(0,0,null);
			//				soundChannelInstance.addEventListener( Event.SOUND_COMPLETE, onSoundComplete );
		}
		
		private function onSoundComplete( e:Event ):void {
			playTrack( getNextTrack() );
		}
		
		private function getNextTrack( ):Track {
			var playlist : GetPlaylistResponse = Session.instance.getPlaylistResponse;
			var track : Track = null;
			
			for( var i:uint = nextTrackIndex++ ; i < playlist.items.elements.length ; i++ ) {
				if ( ( track = playlist.items.elements[ i ] as Track ) )
					break;
			}
			
			return track;
		}
	}
}