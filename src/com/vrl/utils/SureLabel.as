//FIXME: DELETE ME

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

	///////////////////////
	// SureLabel Class //
	///////////////////////
	public class SureLabel extends ButtonLabel {
		
		var sureWindow:SureWindow;
						
		/**
		* Sure Labels can create "are you sure" boxes	
		*/
		public function SureLabel(labelName:String, buttonText:String, onClick:Function, TAB_SIZE:Number, sureWindow:SureWindow):void {
			
			//var takeOverSureWindow:Function = injectFunction(onClick, sureWindow);
			
			super(labelName, buttonText, onClick, TAB_SIZE);			
		}
		
		//The function to create a new sureWindow.
		/*
		private function injectFunction(onClick:Function, sureWindow:SureWindow):Function {
			return function(e:MouseEvent):void {
				var button:TextButton = TextButton(e.currentTarget);
				var label:String = button.context;//label;
				sureWindow.yesButton.addEventListener(MouseEvent.CLICK, onClick);
				sureWindow.show();
			}
		}
		*/
	}
}