package com.lnet.streamingvideo.data {
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import nl.demonsters.debugger.MonsterDebugger;

	public class CategoriesXMLLoader extends URLLoader {
		private static const CATEGORY_URL:String = "Categories.xml";
		
		public function CategoriesXMLLoader() {
			addEventListener(Event.COMPLETE, xmlReturned, false, 0, true);
			load(new URLRequest(CATEGORY_URL));
		}
		
		private function xmlReturned(e:Event):void {
			removeEventListener(Event.COMPLETE, xmlReturned);
			var xmlData:XML = new XML(e.target.data);
			parseXML(xmlData);
			MonsterDebugger.trace("CategoriesXMLLoader::LoadXML","Category XML loaded::"+xmlData);
		}

		private function parseXML(xmlData:XML):void {
			var categoryList:XMLList = xmlData.category;
			MonsterDebugger.trace("CategoriesXMLLoader::parseXML","category::"+categoryList.length());
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.CATEGORIES_LOADED, categoryList));
		}
	}
}