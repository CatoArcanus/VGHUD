package com.vrl.labels {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.TextButton;
	import com.vrl.utils.Icon;

	///////////////////////
	// ButtonLabel Class //
	///////////////////////
	public class ButtonLabel extends AbstractLabel {
		
		public var button:TextButton; 
		public var icon:Icon; 
		
		/**
		* Button Labels are simply a label and a button.
		*/
		public function ButtonLabel(labelName:String, buttonText:String, onClick:Function, width:int, TAB_SIZE:Number):void {
			super(labelName, width, TAB_SIZE);
			
			button = new TextButton(buttonText, labelName, TAB_SIZE/2); 
			button.x = this.myWidth - button.myWidth - TAB_SIZE/4;
			button.y = TAB_SIZE/4;
			button.addEventListener(MouseEvent.CLICK, onClick);
			
			this.draw();
			initialize();
		}
		
		//Add items to stage
		private function initialize():void {
			if(button.text.text != "") {
				this.addChild(button);
			}
		}
	}
}