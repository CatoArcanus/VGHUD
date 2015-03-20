package com.vrl.utils {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	////////////////////////
	// RotatingIcon Class //
	////////////////////////
	
	/**
	* FIXME: This should have a rotating icon, but it doesn't for some reason.
	*/
	public class RotatingIcon extends Icon {
		
		public var maxRotation:Number = 0; 
		public var minRotation:Number = -90; 
		public var rotateTo:Number = 0; 
					
		public function RotatingIcon(name:String, TAB_SIZE:Number, scaleForm:Boolean = true):void {
			super(name, TAB_SIZE/2, scaleForm, true);
			
			init();
		}
		
		//Add items to stage
		private function init():void {
			
		}
	}
}