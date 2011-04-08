package com.lnet.streamingvideo.data {
	import nl.demonsters.debugger.MonsterDebugger;
	
	[Bindable]
	public class VideoResultObject {
		private var _title:String;
		private var _description:String;
		private var _published:String;
		private var _author:String;
		private var _views:String;
		private var _thumbnail:String;
		private var _videoID:String;
		
		public function VideoResultObject(video:Object) {
			try {_title = video.media$group.media$title.$t}
				catch(e:Error) {_title = ""}
			try {_description = video.media$group.media$description.$t}
				catch(e:Error) {_description = ""}
			try {_author = video.author[0].name.$t}
				catch(e:Error) {_author = ""}
			try {_views = video.yt$statistics.viewCount}
				catch(e:Error) {_views = ""}
			try {_published = video.published.$t}
				catch(e:Error) {_published = ""}
			try {_videoID = video.media$group.yt$videoid.$t}
				catch(e:Error) {}
			try {_thumbnail = video.media$group.media$thumbnail[0].url}
				catch(e:Error) {}
		}
		
		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}

		public function get published():String {
			return _published;
		}

		public function set published(value:String):void {
			_published = value;
		}

		public function get author():String {
			return _author;
		}

		public function set author(value:String):void {
			_author = value;
		}

		public function get thumbnail():String {
			return _thumbnail;
		}

		public function set thumbnail(value:String):void {
			_thumbnail = value;
		}

		public function get description():String {
			return _description;
		}

		public function set description(value:String):void {
			_description = value;
		}


		public function get videoID():String {
			return _videoID;
		}

		public function set videoID(value:String):void {
			_videoID = value;
		}

		public function get views():String {
			return _views;
		}

		public function set views(value:String):void {
			_views = value;
		}

	}
}