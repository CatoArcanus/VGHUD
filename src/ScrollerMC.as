package {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;

	/////////////////
	// Description //
	/////////////////
	/**
	 * The ChatPanel is extended from the Panel class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.2 (12/29/2014)
	 */

	/////////////////////
	// ScrollerMC Class //
	/////////////////////
	public class ScrollerMC extends AbstractScroller {
	
		var target:Sprite;	
				
		public function ScrollerMC(target:Sprite, TAB_SIZE:int, stageRef:Stage, windowHeight:Number) {
			super(TAB_SIZE, stageRef, windowHeight);
			this.target = target;		
						
			target.addEventListener (Event.ENTER_FRAME, moveHandle);
		}		
				
		//set the height of the handle dynamically on enter frame
		override public function sethandle (e:Event):void {
			//trace("doing this every frame");
			//get the ratio of the track to the max scroll of the textbox.
			var ratio:Number = track.height / target.height;
			//trace(ratio);
			if(ratio > 1) {
				handle.visible = false;
				track.visible = false;
			} else {
				handle.height = ratio * track.height; 
				handle.visible = true;
				track.visible = true;
			}
			//assign the ratio to the height of the handle + 40 pixels, to give it a decent initial size. 
		}
		
		//set the height of the handle dynamically on enter frame
		override public function moveHandle (e:Event):void {
		
			var yMin:Number = 0;
			var yMax:Number = track.height - handle.height;
			handle.y = (((target.y)*yMax)/target.height);
			if (handle.y <= 0) {
				handle.y = 0;
			} 
			if (handle.y >= yMax) {
				handle.y = yMax;
			}			
			
		}
		
		override public function startScroll (e:MouseEvent):void {
			target.addEventListener (Event.ENTER_FRAME, moveHandle);
		}
		
		override public function stopScroll (e:MouseEvent):void {
			target.removeEventListener (Event.ENTER_FRAME, moveHandle);
		}				
		
		override public function handlemove (e:MouseEvent):void { 
			var yMin:Number = 0;
			var yMax:Number = track.height - handle.height;
			//this scrolls the text
			//target.y = -(handle.y * (target.height - yMax)/yMax) - target.y;
			target.y = (((handle.y - yMin)/yMax)*(target.height-track.height+TAB_SIZE/4))*-1;
			//Here, when scrolling is activated, and handle move...we then set the handle Y to the mouse Y - the
			//Y offset we made earlier to prevent snapping.
			handle.y = mouseY - yOffset; 
			
			if (handle.y <= yMin) {
				handle.y = yMin;
			} 
			if (handle.y >= yMax) {
				handle.y = yMax;
			}
		}
	}
}