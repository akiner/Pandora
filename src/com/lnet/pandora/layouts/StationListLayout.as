package com.lnet.pandora.layouts{
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import mx.core.ILayoutElement;
	
	import spark.core.NavigationUnit;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class StationListLayout extends LayoutBase {
		private static const GAP_SPACER:Number = 345;
		private static const SELECTED_INDEX_Y:Number = 129;
		
		//----------------------------------
		//  selectedIndex
		//----------------------------------
		private var _selectedIndex:int = 0;

		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function set selectedIndex( value:int ):void {
			if ( _selectedIndex != value ) {
				_selectedIndex = value;
				invalidateTargetSizeAndDisplayList();
			}
		}
		//----------------------------------
		//  gap
		//----------------------------------
		
		private var _gap : int = 2;
		
		[Inspectable(category="General")]
		
		public function get gap():int {
			return _gap;
		}
		
		public function set gap(value:int):void {
			if (_gap == value)
				return;
			
			_gap = value;
			invalidateTargetSizeAndDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  LayoutBase Override
		//
		//--------------------------------------------------------------------------
		
		override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int {
			if (!target || target.numElements < 1)
				return -1; 
			
			var indicesPerPage:int = target.getLayoutBoundsHeight() / typicalLayoutElement.getLayoutBoundsHeight();
			
			switch (navigationUnit) {
				// one less than the currrent index
				case NavigationUnit.UP:
					return Math.max(0, currentIndex - 1); 
					
					// one more than the current index
				case NavigationUnit.DOWN:
					return Math.min(target.numElements - 1, currentIndex + 1); 
					
				default:
					return -1;
			}
		}
		
		override public function measure():void	{
			var width:Number = 0;
			var height:Number = 0;
			
			// calculate size based on typicalLayoutElement
			if (typicalLayoutElement) {
				width  = typicalLayoutElement.getLayoutBoundsWidth(false);
				height = typicalLayoutElement.getLayoutBoundsHeight(false);
			}
			
			// assign calculation
			if (target) {
				target.measuredWidth  = target.measuredMinWidth  = width;
				target.measuredHeight = target.measuredMinHeight = height;
			}
		}

		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (!target)
				return;
			
			if (!typicalLayoutElement)
				return;
			
			if (target.numElements <= 0)
				return;
			
			var firstIndexInView:int = 0;
			var firstIndexInViewOffset:Number = 0;
			var lastIndexInView:int = 0;
			var numIndicesInView:int = 0;
			
			firstIndexInView = target.verticalScrollPosition / typicalLayoutElement.getLayoutBoundsHeight();
			firstIndexInViewOffset = target.verticalScrollPosition % typicalLayoutElement.getLayoutBoundsHeight();
			
			numIndicesInView = Math.ceil(target.height / typicalLayoutElement.getLayoutBoundsHeight());
			
			lastIndexInView = Math.min(firstIndexInView + numIndicesInView, target.numElements - 1);
			
			var x:Number = 0;
			var y:Number = 0;
			
			for (var i:int = firstIndexInView; i <= lastIndexInView; i++) {
				var element:ILayoutElement = target.getVirtualElementAt(i);
				
				element.setLayoutBoundsSize(NaN, NaN);
				
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				if(i <= selectedIndex){
					var positionUpTheChain:Number = selectedIndex - i;
					y = SELECTED_INDEX_Y - (elementHeight * positionUpTheChain) - (gap * positionUpTheChain);
				}
				
				element.setLayoutBoundsPosition(x, y);
				
				if(i == selectedIndex) {
					y += GAP_SPACER;
				}
				
				y += (gap + elementHeight);
				
				target.setContentSize(Math.ceil(Math.max(elementWidth, target.contentWidth)),
					Math.ceil(typicalLayoutElement.getLayoutBoundsHeight() * target.numElements));
				
			}
		}
		
		//---------------------
		//
		// Scroll
		//
		//---------------------
		
		override protected function scrollPositionChanged() : void {
			if ( target )
				target.invalidateDisplayList();
		}
		
		private function invalidateTargetSizeAndDisplayList():void {
			if ( target ) {
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
		
		private function updateContentSize():void {
			var numElements:int = target.numElements;
			var width:int = typicalLayoutElement.getLayoutBoundsWidth(false);
			var height:int = typicalLayoutElement.getLayoutBoundsHeight(false);
			
			height = gap + ( height + gap ) * (numElements);
			target.setContentSize( width, height );
		}
		
		private function wrapIndex(itemIndex:int):int {
			var itemCount:int = target.numElements;
			
			if (itemCount > 0) {
				while(itemIndex >= itemCount){
					itemIndex -= itemCount;	
				}
				while(itemIndex < 0) {
					itemIndex += itemCount;
				}
			} else {
				itemIndex = undefined;
			}
			
			return itemIndex;
		}
	}
}