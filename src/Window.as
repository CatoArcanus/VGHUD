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

	/////////////////
	// Window Class //
	/////////////////
	public class Window extends UIElement {
		
		var windowName:String;
			
		public function Window(windowName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean):void {		
			this.myWidth = myWidth;
			this.myHeight = height+TAB_SIZE/4;
			this.windowName = windowName;
			init();
		}
		
		private function init():void {
			draw();
		}						
	}	
}