package com.vrl.utils {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.TextButton;

	/////////////////////
	// SureLabel Class //
	/////////////////////
	public class SureLabel extends AbstractLabel {
		
		public var sureButton:TextButton; 
		public var icon:Icon; 
		
		/**
		* Sure Labels can create "are you sure" boxes
		* FIXME: make "are you sure" boxes	
		*/		
		public function SureLabel(labelName:String, buttonText:String, onClick:Function, TAB_SIZE:Number):void {
			super(labelName, TAB_SIZE*4, TAB_SIZE);
			
			sureButton = new TextButton(buttonText, labelName, TAB_SIZE/2); 
			sureButton.x = this.myWidth - sureButton.myWidth - TAB_SIZE/4;
			sureButton.y = TAB_SIZE/4;
			sureButton.addEventListener(MouseEvent.CLICK, onClick);
																									
			this.draw();
			initialize();
		}
		
		//Add items to stage
		private function initialize():void {
			this.addChild(sureButton);
		}		
	}
}