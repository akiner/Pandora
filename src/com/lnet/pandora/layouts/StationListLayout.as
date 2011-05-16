package com.lnet.pandora.layouts{
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.geom.Point;
	
	import mx.core.ILayoutElement;
	
	import spark.components.supportClasses.GroupBase;
	import spark.core.NavigationUnit;
	import spark.layouts.supportClasses.LayoutBase;
	
	public class StationListLayout extends LayoutBase {
		private var currentYPosition:Number;
		private var minEligibleScrollPosition:Number = 0;
		private var maxEligibleScrollPosition:Number = 0;
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
		
		// -------------------------
		// Virtual Layout Version
		// -------------------------
		
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
			
			// Step 2: Given the scroll position, figure out the first index that should be in view
			// keep track of the remainder in case the first index is only partially in view
			
			firstIndexInView = target.verticalScrollPosition / typicalLayoutElement.getLayoutBoundsHeight();
			firstIndexInViewOffset = target.verticalScrollPosition % typicalLayoutElement.getLayoutBoundsHeight();
			
			// Step 3: Figure out how many indices are in view
			
			numIndicesInView = Math.ceil(target.height / typicalLayoutElement.getLayoutBoundsHeight());
			
			// Step 4: Figure out the last index in view
			
			lastIndexInView = Math.min(firstIndexInView + numIndicesInView, target.numElements - 1);
			
			// Step 5: Figure out what coordinates to position the first index at
			
			var maxNumElementsBeforeSelectedIndex:Number = 3;
			var maxNumElementsAfterSelectedIndex:Number = 3;
			
			var selectedIndexY:Number = 134;
			
			var x:Number = 0;
			var y:Number = selectedIndexY;
			
			var lastYPosAboveSelectedIndex:Number = 134;
			// Step 6: Position the renderer of each index that is in view using getVirtualElementAt
			
			//  loop through each index that is in view
			for (var k:int = firstIndexInView; k <= lastIndexInView; k++) {
				MonsterDebugger.trace("StationListLayout::updateDisplayList","selectedIndex====================="+selectedIndex);
				var element:ILayoutElement = target.getVirtualElementAt(k);
				
				if(k < selectedIndex){ // if the element is above the selected index, adjust the position to above
					lastYPosAboveSelectedIndex -= element.getLayoutBoundsHeight() + gap + gap;
					y = lastYPosAboveSelectedIndex;
				} else if(k == selectedIndex) {
					y = selectedIndexY;
				}
				
				MonsterDebugger.trace("StationListLayout::updateDisplayList","setting element "+k+" at xpos::"+x+", yPos::"+y);
				element.setLayoutBoundsPosition(x, y);
				
				// resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(NaN, NaN);
				
				// find the size of the element
				var elementWidth:Number = element.getLayoutBoundsWidth();
				var elementHeight:Number = element.getLayoutBoundsHeight();
				
				// update the target's contentWidth and contentHeight
				target.setContentSize(Math.ceil(Math.max(elementWidth, target.contentWidth)),
					Math.ceil(typicalLayoutElement.getLayoutBoundsHeight() * target.numElements));
				
				// update the x position for where to place the next element
				if(k == selectedIndex) {
					y += 348;
				}
				y += gap + elementHeight;
			}
			
			//
			// Step 7: Keep track of the extent of the renderers that are partially in view
			//
			// ie: how much they stick out of view. Keeping track of that allows us to call  
			// invalidateDisplayList() less in scrollPositionChanged().
			//
			
			minEligibleScrollPosition = target.verticalScrollPosition;
			maxEligibleScrollPosition = minEligibleScrollPosition + target.height;
			
			// now subtract the top offset
			minEligibleScrollPosition -= firstIndexInViewOffset;
			// and add the bottom offset
			maxEligibleScrollPosition += typicalLayoutElement.getLayoutBoundsHeight() - firstIndexInViewOffset;
		}
		
		// ---------------
		// Dan's version
		// ---------------
		
//		override public function updateDisplayList(width:Number, height:Number):void {
//			if (!target || !typicalLayoutElement)
//				return;
//			
//			var selectedIndex:int = index == -1 ? int( target.numElements / 2 ) : index;
//			var element:ILayoutElement;
//			var layoutTarget:GroupBase = target as GroupBase;
//			var itemDim:int = typicalLayoutElement.getLayoutBoundsHeight();
//			var scrollDim:int = (layoutTarget.scrollRect) ? (layoutTarget.scrollRect.height) : (height);
//			var scrollPos:int = verticalScrollPosition;
//			var edgeIndex:int = (scrollPos - gap) / (itemDim + gap);
//			var itemIndex:int = edgeIndex;
//			var upperBounds:int = scrollPos + scrollDim;;
//			var xPos:int = 0;
//			var yPos:int = gap + (itemDim + gap) * (itemIndex);
//			
//			MonsterDebugger.trace("StationListLayout::updateDisplayList","selectedIndex::"+selectedIndex);
//			if ( itemDim == 0 )
//				return;
//			while ( xPos < upperBounds ) {
//				MonsterDebugger.trace("StationListLayout::updateDisplayList", "positioning itemIndex = " + itemIndex + " at (" + xPos + ", " + yPos +")");
//				
//				// resize the element to its preferred size by
//				// passing NaN for the width and height constraints.
//				element = layoutTarget.getVirtualElementAt(wrapIndex(itemIndex++));
//				element.setLayoutBoundsSize(NaN, NaN);
//				
//				element.setLayoutBoundsPosition( xPos, yPos );
//				xPos += itemDim + gap;
//			}
//			
//			updateContentSize();
//		}
		
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