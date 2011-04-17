package com.lnet.streamingvideo.data {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	

	public class DefaultCategoriesLoader extends URLLoader {
		private static const DEFAULT_CATEGORY_URL:String = "DefaultCategories.xml";
		
		public function DefaultCategoriesLoader() {
			addEventListener(Event.COMPLETE, xmlReturned, false, 0, true);
			load(new URLRequest(DEFAULT_CATEGORY_URL));
		}
		
		private function xmlReturned(e:Event):void {
			removeEventListener(Event.COMPLETE, xmlReturned);
			var xmlData:XML = new XML(e.target.data);
			parseXML(xmlData);
		}

		private function parseXML(xmlData:XML):void {
			var categoryList:XMLList = xmlData.category;
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.DEFAULT_CATEGORIES_LOADED, categoryList));
		}
	}
}