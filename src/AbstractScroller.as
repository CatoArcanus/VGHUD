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
	// AbstractScroller Class //
	/////////////////////
	public class AbstractScroller extends UIElement {
	
		var track:Sprite;
		var handle:Sprite;
		var yOffset:Number;
		var TAB_SIZE:int;
		var stageRef:Stage;
		
		public function AbstractScroller(TAB_SIZE:int, stageRef:Stage, trackHeight:Number) {
						
			this.TAB_SIZE = TAB_SIZE;
			this.stageRef = stageRef;
			
			//Track
			track = new Sprite();
			track.graphics.beginFill(0xcccccc, 0.1); 
			track.graphics.drawRect(0, 0, TAB_SIZE/2, trackHeight); 
			track.graphics.endFill();
			
			//Handle
			handle = new Sprite();
			handle.graphics.beginFill(0x000000, 0.8); 
			handle.graphics.drawRect(0, 0, TAB_SIZE/2, TAB_SIZE/2); 
			handle.graphics.endFill();
			
			this.addEventListener (Event.ENTER_FRAME, sethandle);
			handle.addEventListener (MouseEvent.MOUSE_DOWN, startScroll);
			stageRef.addEventListener (MouseEvent.MOUSE_UP, stopScroll);
			init();
		}		
		
		public function init() {
			addChild(track);
			addChild(handle);
		}
		
		//set the height of the handle dynamically on enter frame
		public function sethandle (e:Event):void {
			
		}
		
		//set the height of the handle dynamically on enter frame
		public function moveHandle (e:Event):void {
			
		}
		
		public function startScroll (e:MouseEvent):void {
		
		}
		
		public function stopScroll (e:MouseEvent):void {
					
		}
		
		public function handlemove (e:MouseEvent):void { 
			
		}
	}
}