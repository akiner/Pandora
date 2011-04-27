package com.lnet.streamingvideo.components {
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.display.MovieClip;
	
	public class StarRating extends MovieClip {
		private var rating:Number;
		private var star1:MovieClip;
		private var star2:MovieClip;
		private var star3:MovieClip;
		private var star4:MovieClip;
		private var star5:MovieClip;
		
		public function StarRating(passedRating:String):void {
			rating = Number(passedRating);
//			calculateStars();
		}
		
		private function calculateStars():void {
//			try {
				MonsterDebugger.trace("SearchResultsItemRenderer::calculateStars","CALCULATING STARS FOR RATING::"+rating);
				if(rating >= 4.65) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("full");
					star4.gotoAndStop("full");
					star5.gotoAndStop("full");
				} else if(rating >= 4.25) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("full");
					star4.gotoAndStop("full");
					star5.gotoAndStop("half");
				} else if(rating >= 3.65) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("full");
					star4.gotoAndStop("full");
					star5.gotoAndStop("none");
				} else if(rating >= 3.25) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("full");
					star4.gotoAndStop("half");
					star5.gotoAndStop("none");
				} else if(rating >= 2.65) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("full");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				} else if(rating >= 2.25) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("half");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				} else if(rating >= 1.65) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("full");
					star3.gotoAndStop("none");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				} else if(rating >= 1.25) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("half");
					star3.gotoAndStop("none");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				} else if(rating >= 0.65) {
					star1.gotoAndStop("full");
					star2.gotoAndStop("none");
					star3.gotoAndStop("none");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				} else if(rating >= 0.25) {
					star1.gotoAndStop("half");
					star2.gotoAndStop("none");
					star3.gotoAndStop("none");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				} else {
					star1.gotoAndStop("none");
					star2.gotoAndStop("none");
					star3.gotoAndStop("none");
					star4.gotoAndStop("none");
					star5.gotoAndStop("none");
				}
//			} catch(e:Error) {
//				MonsterDebugger.trace("SearchResultsItemRenderer::calculateStars","ERROR::Rating could not be calculated");
//			}
		}
	}
}