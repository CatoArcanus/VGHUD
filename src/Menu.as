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
	 * The Menu is the main window that is loaded for the HuD
	 *
	 * @category   movieclip
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/20/2014)
	 */

	////////////////////////
	//* Menu Class *//
	////////////////////////	
	public class Menu extends Sprite {
		//Properties
		var easing:Number = 0.25;
		var openX:int;
		var closeX:int;
		var dx:int;
		var frameCounter:int = 0;
		
		//Objects
		var tabs:Array = new Array();
		
		//Menu initializes objects and gives them values
		public function Menu(width:int, height:int):void {		
			var tab = new Tab("avatars");
			tab.x = 0;
			tab.y = 0;
			tab.draw(width, 64);
			//tab.height = 64;			
			tabs.push(tab);
			
			init();
			draw(width, height);			
		}
			
		//Init Adds resources to stage and sets up initial event listeners
		private function init():void {
			for each(var tab:Tab in tabs){
				addChild(tab);
			}			
		}
		
		public function draw(width, height):void {
			graphics.beginFill(0x000000, .5);
			graphics.drawRect(0, 0, width, height); 
			graphics.endFill(); 
		}
		
		public function onEnterFrameOpen(e:Event):void {
			//trace(frameCounter + " -- " + (openX - x) * easing);
			dx = ( openX - x);
			if(Math.abs(dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrameOpen);
				frameCounter = 0;
			} else {
				x += dx * easing;				
			}
			frameCounter++;			
		}
		
		public function onEnterFrameClose(e:Event):void {
			//trace(frameCounter + " -- " + (closeX - x) * easing);
			dx = ( closeX - x);
			if(Math.abs(dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrameClose);
				frameCounter = 0;
			} else {
				x += dx * easing;				
			}
			frameCounter++;
		}				
	}	
}