package com.lnet.pandora.viewmodels {
	
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.response.station.supportClasses.Track;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.Sort;
	
	[Bindable]
	public class SongListViewModel {
		
		private var _songList:IList;
		private var _currentTrack:Track;
		private var internalList:IList;
		
		public function SongListViewModel() {
			initSongLists();
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.STATION_SELECTED, initSongLists, false, 0, true);
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.SONG_LOADED, updateSongList, false, 0, true);
		}

		private function initSongLists(event:ApplicationEvent=null):void {
			_songList = new ArrayCollection();
			internalList = new ArrayCollection();
		}

		private function updateSongList(event:ApplicationEvent):void {
			_currentTrack = event.data as Track;
			internalList.addItem(currentTrack);
			songList = internalList as IList;
//			MonsterDebugger.trace("SongListViewModel.updateSongList","Updating song list - added::"+currentTrack.songName);
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.UPDATE_SELECTED_INDEX, currentTrack));
		}

		public function get songList():IList {
			return _songList;
		}

		public function set songList(value:IList):void {
			_songList = value;
		}

		public function get currentTrack():Track {
			return _currentTrack;
		}

		public function set currentTrack(value:Track):void {
			_currentTrack = value;
		}
	}
}