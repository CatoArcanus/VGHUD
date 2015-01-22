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
	// Scroller Class //
	/////////////////////
	public class Scroller extends UIElement {
	
		var target:TextField;	
		var track:Sprite;
		var handle:Sprite;
		var yOffset:Number;
		var TAB_SIZE:int; 	
		var stageRef:Stage;
		
		public function Scroller(target:TextField, TAB_SIZE:int, stageRef:Stage) {
			
			this.target = target;
			this.TAB_SIZE = TAB_SIZE;
			this.stageRef = stageRef;
			
			//Track
			track = new Sprite();
			track.graphics.beginFill(0xcccccc, 0.1); 
			track.graphics.drawRect(0, 0, TAB_SIZE/2, target.height); 
			track.graphics.endFill();
			
			//Handle
			handle = new Sprite();
			handle.graphics.beginFill(0x000000, 0.8); 
			handle.graphics.drawRect(0, 0, TAB_SIZE/2, TAB_SIZE/2); 
			handle.graphics.endFill();
			
			this.addEventListener (Event.ENTER_FRAME, sethandle);
			handle.addEventListener (MouseEvent.MOUSE_DOWN, startScroll);
			stageRef.addEventListener (MouseEvent.MOUSE_UP, stopScroll);
			target.addEventListener (Event.ENTER_FRAME, moveHandle);
			init();
		}		
		
		public function init() {
			addChild(track);
			addChild(handle);
		}
		
		//set the height of the handle dynamically on enter frame
		public function sethandle (e:Event):void {
			//trace("doing this every frame");
			//get the ratio of the track to the max scroll of the textbox.
			var ratio:Number = track.height / target.maxScrollV; 
			//assign the ratio to the height of the handle + 40 pixels, to give it a decent initial size. 
			handle.height = ratio + TAB_SIZE*2; 
		}
		
		//set the height of the handle dynamically on enter frame
		public function moveHandle (e:Event):void {
			var yMin:Number = 0;
			var yMax:Number = track.height - handle.height;
			var minPos = 0; 
			if(target.scrollV == 1) {
				minPos = -1;
			}
			handle.y = (((target.scrollV+minPos)*yMax)/target.maxScrollV+1);
			if (handle.y <= 0) {
				handle.y = 0;
			} 
			if (handle.y >= yMax) {
				handle.y = yMax;
			}
		}
		
		public function startScroll (e:MouseEvent):void {
			stageRef.addEventListener (MouseEvent.MOUSE_MOVE, handlemove);
			yOffset = mouseY - handle.y;
			target.removeEventListener (Event.ENTER_FRAME, moveHandle);
		}
		
		public function stopScroll (e:MouseEvent):void {
			stageRef.removeEventListener (MouseEvent.MOUSE_MOVE, handlemove);
			target.addEventListener (Event.ENTER_FRAME, moveHandle); 
		}
		
		public function handlemove (e:MouseEvent):void { 
			var yMin:Number = 0;
			var yMax:Number = track.height - handle.height;
			//this scrolls the text
			target.scrollV = (((handle.y - yMin)/yMax)*target.maxScrollV);
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