package com.vrl.buttons {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.vrl.UIElement;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Icon Button is a variable size and has a single icon in the middle
	 *
	 * @namespace  root.menu.button
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/29/2014)
	 */

	//////////////////////
	// TextButton Class //
	//////////////////////
	public class TextButton extends AbstractButton {
			
		public function TextButton(buttonName:String, context:String, TAB_SIZE:Number):void {
			super(buttonName, context, TAB_SIZE, TAB_SIZE);
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			text = new TextField();			
			text.border = false;
			text.multiline = false;
			text.wordWrap = false;
			text.selectable = false;
			//get it to be auto size
			text.autoSize = TextFieldAutoSize.CENTER;
							
			//apply the format
			text.defaultTextFormat = myFormat;
			//set the color
			text.textColor = 0xFFFFFF;
			//set the text
			text.text = (buttonName);
			this.myWidth = text.width+TAB_SIZE;
			this.myHeight = text.height+TAB_SIZE/4;
			text.x = TAB_SIZE/2;
			text.y = TAB_SIZE/8;
																	
			this.draw();
			init();
		}
		
		//Add items to stage
		private function init():void {
			this.addChild(text);
		}		
	}
}