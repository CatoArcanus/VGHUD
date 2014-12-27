package  {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
		
	///////////////////
	//* Description *//
	///////////////////
	/**
	 * The PossessPanel is extended from the Panel class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/27/2014)
	 */

	////////////////////////
	//* PossessPanel Class *//
	////////////////////////	
	public class PossessPanel extends Panel {
		
		//var ghostButton:Button;
			
		public function PossessPanel(panelName:String, width:int, height:int):void {
			super(panelName, width, height);
			initialize();
		}
		
		private function initialize():void {
		
		}
	}
}