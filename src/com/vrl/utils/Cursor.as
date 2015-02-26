package com.vrl.utils {
	
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
	// Cursor Class //
	//////////////////////////
	public class Cursor extends Icon {
							
		public function Cursor(name:String, TAB_SIZE:Number, scaleForm:Boolean = true):void {
			super(name, TAB_SIZE/2, scaleForm);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
						
			this.draw();
			init();
		}
		
		//Add items to stage
		private function init():void {
			
		}
	}
}