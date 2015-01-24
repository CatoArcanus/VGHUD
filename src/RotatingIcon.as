package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Rotating Button is a variable size and has a single icon in the middle
	 * It eases through a rotation animation when clicked and toggles its state
	 * this is usually used for arrows that rotate in and out as they are clicked
	 *
	 * @namespace  root.menu.button
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/31/2014)
	 */

	//////////////////////////
	// RotatingIcon Class //
	//////////////////////////
	public class RotatingIcon extends Icon {
		
		public var maxRotation:Number = 0; 
		public var minRotation:Number = -90; 
		public var rotateTo:Number = 0; 
					
		public function RotatingIcon(name:String, TAB_SIZE:Number):void {
			super(name, TAB_SIZE/2, true);
			
			this.draw();
			init();
		}
		
		//Add items to stage
		private function init():void {
			
		}
	}
}