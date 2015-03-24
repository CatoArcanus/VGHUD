package com.vrl {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	/////////////////////
	// UIElement Class //
	/////////////////////
	/*
	* This is our custom souped up sprite. Notice it uses the default constructor.
	* Almost all elements are derived from this instead of sprite, brecause almost 
	* all elements are easable. It might have been better to make an easable interface
	* but this works pretty well and is more readable in my opinion. Keep your layers 
	* thick.
	*/	
	public class UIElement extends Sprite {
		
		// Default Variables //
		public var frameCounter:int = 0;
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
		public var da:Number;
				
		//A draw function for all UI elements
		public function draw():void {
			graphics.clear();
			//trace("I'm drawing, the currentAlpha is :" + currentAlpha);
			graphics.beginFill(color, currentAlpha);
			graphics.drawRect(0, 0, myWidth, myHeight); 
			graphics.endFill();
			if (debug) {
				graphics.lineStyle(1, 0x990000, .75);
				graphics.moveTo(0, 0); 
				graphics.lineTo(0, myHeight); 
				graphics.lineTo(myWidth, myHeight); 
				graphics.lineTo(myWidth, 0); 
				graphics.lineTo(0, 0); 
			}			
		}
	}
}