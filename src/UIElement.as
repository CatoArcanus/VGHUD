package {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * This is an "abstract" class that holds similar variables for 
	 * sprites that are UI elements.
	 *
	 * @category   root
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.5 (01/06/2015)
	 */

	////////////////
	// Main Class //
	////////////////	
	public class UIElement extends Sprite {
		
		// Default Variables //
		var frameCounter:int = 0;
		var debug:Boolean = false;		
		
		//Stuff for easing
		public var easing:Number = 0.25;
		public var openX:int = 0;
		public var openY:int = 0;
		public var closeX:int = 0;
		public var closeY:int = 0;
		public var moveX:int = 0;
		public var moveY:int = 0;
		public var dx:Number = 0;
		public var dy:Number = 0;
		
		//For drawing
		public var myWidth:int; 
		public var myHeight:int;
		
		//Alpha stuff
		public var maxAlpha:Number = 1.0; 
		public var minAlpha:Number = 0.0; 
		public var fade:Number = 0.0; 
		public var currentAlpha:Number = 0.0;
		public var color:uint = 0x000000;
		var da:Number;
		
		//A draw function for all UI elements
		public function draw():void {
			graphics.clear();
			//trace("I'm drawing, the currentAlpha is :" + currentAlpha);
			graphics.beginFill(color, currentAlpha);
			graphics.drawRect(0, 0, myWidth, myHeight); 
			if (debug) {
				graphics.lineStyle(1, 0x990000, .75);
				graphics.moveTo(0, 0); 
				graphics.lineTo(0, myHeight); 
				graphics.lineTo(myWidth, myHeight); 
				graphics.lineTo(myWidth, 0); 
				graphics.lineTo(0, 0); 
			}			
			graphics.endFill();
		}
	}
}