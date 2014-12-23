package  {
	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;	
	///////////////////
	//* Description *//
	///////////////////
	/**
	 * The Panel is one of many objects in a menu
	 *
	 * @category   movieclip
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/23/2014)
	 */

	////////////////////////
	//* Panel Class *//
	////////////////////////	
	public class Panel extends Sprite {
				
		public function Panel(width:int, height:int):void {		
			draw(width, height);
		}	
		
		public function draw(width, height):void {
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, width, height); 
			graphics.endFill(); 
		}		
		
	}	
}