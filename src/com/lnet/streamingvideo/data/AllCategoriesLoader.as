package com.lnet.streamingvideo.data {
	import com.demonsters.debugger.MonsterDebugger;
	import com.lnet.streamingvideo.events.ApplicationEvent;
	import com.lnet.streamingvideo.events.ApplicationEventBus;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
	public class AllCategoriesLoader extends URLLoader {
		private static const ALL_CATEGORIES_URL:String = "http://gdata.youtube.com/schemas/2007/categories.cat";
		
		public function AllCategoriesLoader() {
			addEventListener(Event.COMPLETE, xmlReturned, false, 0, true);
			load(new URLRequest(ALL_CATEGORIES_URL));
		}
		
		private function xmlReturned(e:Event):void {
			removeEventListener(Event.COMPLETE, xmlReturned);
			var xmlData:XML = new XML(e.target.data);
			parseXML(xmlData);
		}
		
		private function parseXML(xmlData:XML):void {
			var atomNS:Namespace = new Namespace("atom", "http://www.w3.org/2005/Atom");
			xmlData.addNamespace(atomNS);
			var categoryList:XMLList = xmlData.atomNS::category;
			var categoryArray:ArrayCollection = new ArrayCollection();
			for each(var category in categoryList) {
				categoryArray.addItem(category.@label);
			}
			ApplicationEventBus.getInstance().dispatchEvent(new ApplicationEvent(ApplicationEvent.ALL_CATEGORIES_LOADED, categoryArray));
		}
	}
}