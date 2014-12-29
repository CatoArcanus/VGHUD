package  {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import com.montenichols.utils.Scrollbar;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	///////////////////
	//* Description *//
	///////////////////
	/**
	 * This is an "abstract" class that holds similar variables for 
	 * sprites that are UI elements.
	 *
	 * @category   root
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.3 (12/23/2014)
	 */

	//////////////////
	//* Main Class *//
	//////////////////	
	public class UIElement extends Sprite {
		
		//Variables
		var easing:Number = 0.25;
		var openX:int;
		var closeX:int;
		var moveX:int;
		var dx:Number;
		var frameCounter:int = 0;
		public var myWidth:int; 
		public var myHeight:int;
		public var maxAlpha:Number = 1.0; 
		public var minAlpha:Number = 0.0; 
		public var fade:Number = 0.0; 
		public var currentAlpha:Number = 0.0;
		public var color:uint = 0x000000;
		
		public function draw():void {
			graphics.clear();
			graphics.beginFill(color, currentAlpha);
			graphics.drawRect(0, 0, myWidth, myHeight); 
			graphics.endFill();
		} 
		
	}
}