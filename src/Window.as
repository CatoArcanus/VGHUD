package {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
		
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Window is one of many objects in a menu
	 *
	 * @category   root.menu.panel[]
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.2 (12/29/2014)
	 */

	//////////////////
	// Window Class //
	//////////////////
	public class Window extends UIElement {
		
		var windowName:String;
		var dragHandle:Sprite;
		var closeButton:IconButton;
		var yOffset:Number;
		var xOffset:Number;
		var stageRef:Stage;
			
		public function Window(windowName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage):void {		
			this.myWidth = width;
			this.myHeight = height+TAB_SIZE/4;
			this.windowName = windowName;
			this.stageRef = stageRef;
			
			//Drag Handle
			dragHandle = new Sprite();
			dragHandle.graphics.beginFill(0x000000, .5); 
			dragHandle.graphics.drawRect(0, -.5*TAB_SIZE, width, TAB_SIZE/2);
			dragHandle.graphics.endFill();
			this.x=0;
			this.y=0; 
			dragHandle.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			dragHandle.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			//dragHandle.addEventListener (MouseEvent.MOUSE_DOWN, startMove);
			//stageRef.addEventListener (MouseEvent.MOUSE_UP, stopMove);
			//target.addEventListener (Event.ENTER_FRAME, moveHandle);
			
			init();
		}
		
		private function init():void {
			//addChild(dragHandle);
			draw();
		}
		
		function mouseDownHandler(e:MouseEvent):void
		{
			this.startDrag();
		}
		function mouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		/*
		public function startMove (e:MouseEvent):void {
			yOffset = mouseY - dragHandle.y;
			xOffset = mouseX - dragHandle.x;
			stageRef.addEventListener (Event.ENTER_FRAME, handlemove);
		}
		
		public function stopMove (e:MouseEvent):void {
			stageRef.removeEventListener (Event.ENTER_FRAME, handlemove);
		}
		
		public function handlemove (e:Event):void { 
			//var yMin:Number = 0;
			//var yMax:Number = track.height - handle.height;
			//this scrolls the text
			//target.scrollV = (((handle.y - yMin)/yMax)*target.maxScrollV);
			//Here, when scrolling is activated, and handle move...we then set the handle Y to the mouse Y - the
			//Y offset we made earlier to prevent snapping.
			//trace(mouseY-yOffset);
			this.y = mouseY// - yOffset; 
			this.x = mouseX// - xOffset;
			//if (handle.y <= yMin) {
			//	handle.y = yMin;
			//} 
			//if (handle.y >= yMax) {
			//	handle.y = yMax;
			//}
		}
		*/						
	}	
}