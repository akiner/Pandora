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
		private var _rating:String;
		
		public function VideoResultObject(video:Object) {
			try {_title = video.media$group.media$title.$t}
				catch(e:Error) {_title = ""}
			try {_description = video.media$group.media$description.$t}
				catch(e:Error) {_description = ""}
			try {_author = video.author[0].name.$t}
				catch(e:Error) {_author = ""}
			try {_views = formatViewsText(video.yt$statistics.viewCount)}
				catch(e:Error) {_views = ""}
			try {_published = video.published.$t}
				catch(e:Error) {_published = ""}
			try {_videoID = video.media$group.yt$videoid.$t}
				catch(e:Error) {}
			try {_thumbnail = video.media$group.media$thumbnail[0].url}
				catch(e:Error) {}
			try {_rating = video.gd$rating.average}
				catch(e:Error) {}
		}

		private function formatViewsText(numViews:String):String {
				var num:String = numViews;
				var results:Array = num.split(/\./);
				num = results[0];
				if (num.length>3) {
					var mod:Number = num.length%3;
					var output:String = num.substr(0, mod);
					for (var i:Number = mod; i<num.length; i += 3) {
						output += ((mod == 0 && i == 0) ? "" : ",")+num.substr(i, 3);
					}
					if(results.length > 1){
						if(results[1].length == 1){
							return output+"."+results[1]+"0";
							
						}else{
							return output+"."+results[1];
						}
					}else{
						return output;
					}
				}
				
				if(results.length > 1){
					if(results[1].length == 1){
						return num+"."+results[1]+"0";
						
					}else{
						return num+"."+results[1];
					}
				}else{
					return num;
				}
			
			return num;
		}
		
		public function get title():String {
			return _title;
		}

		public function get published():String {
			return _published;
		}

		public function get author():String {
			return _author;
		}

		public function get thumbnail():String {
			return _thumbnail;
		}

		public function get description():String {
			return _description;
		}

		public function get videoID():String {
			return _videoID;
		}

		public function get views():String {
			return _views;
		}
		
		public function get rating():String {
			return _rating;
		}
	}
}