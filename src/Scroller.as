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
				var minPos = -1;				
			}
			handle.y = (((target.scrollV+minPos)*yMax)/target.maxScrollV+1);
			if (handle.y <= 0) {
				handle.y = 0;
			} 
			if (handle.y >= yMax) {
				handle.y = yMax;
			}
			//target.scrollV = (((handle.y - yMin)/yMax)*target.maxScrollV);
			//Here, when scrolling is activated, and handle move...we then set the handle Y to the mouse Y - the
			//Y offset we made earlier to prevent snapping.
			//handle.y = mouseY - yOffset; //trace("doing this every frame");
			//get the ratio of the track to the max scroll of the textbox.
			//var ratio:Number = track.height / target.maxScrollV; 
			//assign the ratio to the height of the handle + 40 pixels, to give it a decent initial size. 
			//handle.height = ratio + TAB_SIZE*2; 
		}		
			
		public function startScroll (e:MouseEvent):void {
			stageRef.addEventListener (MouseEvent.MOUSE_MOVE, handlemove);
			yOffset = mouseY - handle.y;
			target.removeEventListener (Event.ENTER_FRAME, moveHandle);
			//e.updateAfterEvent(); 	
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
			//e.updateAfterEvent();	
		}
	}
}


//SCROLLBAR CODE 
//function to start scroll on mouse_down for the handle
//we want to add the mouse up stop scroll to the stage, so you can move the mouse off the handle
//while scrolling and when your release somewhere else, have it stop scrolling.
 
//as we are using the mouse position to move the handle, we need to compensate for the offset
//amount of the handle to the mouse so the handle doesn't snap to the mouse when we click down.
//this var gets assigned in a later function
 
//we make the startScroll function here and within it, we put the even listener for the MOUSE_MOVE
//now an event listener within the event listener for starting the startscroll. Within this, we define the 
//function that actually moves the handle along with the mouse.
//here we calculate the offset variable we made earlier. It is the Y of the mouse - the Y of the handle so the
//handle doesn't snap to the position of where you click with the mouse.
//this is very important! we don't want to rely on the frame rate of the document to refresh our scrolling
//using updateAfterEvent makes it refresh every instance it is moved, making it run very smooth.
//close startScroll function
 
//this is simple, to stop scrolling, we simply remove the handlemove listener within the startScroll function
 
//this function moves the handle and the text...along with setting the constraints.
//once again, very important. This makes the scrolling run smooth, and the text scrolling.
// end handlemove