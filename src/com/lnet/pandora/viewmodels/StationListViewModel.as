package com.lnet.pandora.viewmodels {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.pandora.events.ApplicationEvent;
	import com.lnet.pandora.events.ApplicationEventBus;
	import com.lnet.pandora.response.station.supportClasses.Station;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	[Bindable]
	public class StationListViewModel {
		
		private var _stationList:IList;
		private var _currentStationIndex:int;
		
		public function StationListViewModel() {
			_stationList = new ArrayCollection();
			ApplicationEventBus.getInstance().addEventListener(ApplicationEvent.STATION_LIST_LOADED, updateStationList, false, 0, true);
		}

		private function updateStationList(event:ApplicationEvent):void {
			stationList = event.data as IList;
			MonsterDebugger.trace("StationListViewModel::updateStationList","Updated station list::"+stationList);
		}
		
		public function get stationList():IList {
			return _stationList;
		}

		public function set stationList(value:IList):void {
			_stationList = value;
		}

		public function get currentStationIndex():int {
			return _currentStationIndex;
		}

		public function set currentStationIndex(value:int):void {
			_currentStationIndex = value;
		}
	}
}