package com.vrl.utils {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	//////////////////
	// Cursor Class //
	//////////////////
	public class Cursor extends Icon {
							
		/**
		* A Specific icon: the cursor
		* FIXME: Add in the movement enterframe to this class.
		*/
		public function Cursor(name:String, TAB_SIZE:Number, scaleForm:Boolean = true):void {
			super(name, TAB_SIZE/2, scaleForm);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
						
			init();
		}
		
		//Add items to stage
		private function init():void {
			
		}
	}
}