package com.vrl.controls {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.IconButton;

	//////////////////
	// Window Class //
	//////////////////
	public class Window extends UIElement {
		
		var windowName:String;
		var dragHandle:Sprite;
		var closeButton:IconButton;
		var yOffset:Number;
		var xOffset:Number;
		var stageRef:Stage;
		
		/*
		* A Generic window for holding objects, it can be opened, closed, and moved around
		* with a handle.
		*
		*/
			
		public function Window(windowName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage):void {		
			this.myWidth = width;
			this.myHeight = height+TAB_SIZE/4;
			this.windowName = windowName;
			this.stageRef = stageRef;
			
			//Drag Handle
			dragHandle = new Sprite();
			dragHandle.graphics.beginFill(0x000000, .5); 
			dragHandle.graphics.drawRect(0, -.5*TAB_SIZE, width, TAB_SIZE/2);
			dragHandle.graphics.endFill();
			this.x = 0;
			this.y = 0; 
			dragHandle.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			dragHandle.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
						
			init();
		}
		
		private function init():void {
			//addChild(dragHandle);
			draw();
		}
		
		//This lets you drag the window around by its handle
		function mouseDownHandler(e:MouseEvent):void
		{
			this.startDrag();
		}
		function mouseUpHandler(e:MouseEvent):void
		{
			this.stopDrag();
		}				
	}	
}