package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
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
	 * @version    1.0 (01/06/2015)
	 */

	/////////////////////
	// SureLabel Class //
	/////////////////////
	public class SureLabel extends AbstractLabel {
		
		var sureButton:TextButton; 
			
		public function SureLabel(labelName:String, buttonText:String, TAB_SIZE:Number):void {
			super(labelName, TAB_SIZE*5, TAB_SIZE);
			
			sureButton = new TextButton(buttonText, TAB_SIZE/2); 
			sureButton.x = this.myWidth - sureButton.myWidth - TAB_SIZE/4;
			sureButton.y = TAB_SIZE/4;
																						
			this.draw();
			initialize();
		}
		
		//Add items to stage
		private function initialize():void {
			this.addChild(sureButton);
		}		
	}
}