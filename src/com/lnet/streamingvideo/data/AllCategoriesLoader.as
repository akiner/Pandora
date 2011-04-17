package com.lnet.streamingvideo.data {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class AllCategoriesLoader extends URLLoader {
		
		private var urlToLoad:String;
		private var completionEvent:String;
		
		public function AllCategoriesLoader(url:String, eventString:String) {
			urlToLoad = url;
			completionEvent = eventString;
			loadXML();
		}

		private function loadXML():void {
			this.addEventListener(Event.COMPLETE, xmlReturned, false, 0, true);
			load(new URLRequest(urlToLoad));
		}
		
		private function xmlReturned(e:Event):void {
			this.removeEventListener(Event.COMPLETE, xmlReturned);
			var xmlData:XML = new XML(e.target.data);
			MonsterDebugger.trace("CategoriesXMLLoader::xmlReturned","XML loaded::"+xmlData);
			parseXML(xmlData);
		}
		
		private function parseXML(xmlData:XML):void {
			var xmlList:XMLList = xmlData.category;
			MonsterDebugger.trace("CategoriesXMLLoader::parseXML","category::"+xmlList.length());
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(completionEvent, xmlList));
		}
	}
}