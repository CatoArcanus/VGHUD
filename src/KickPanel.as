package {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
		
	/////////////////
	// Description //
	/////////////////
	/**
	 * The KickPanel is extended from the Panel class and is very specific in its
	 * implementation
	 *
	 * @category   root.menu.panel
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/27/2014)
	 */

	/////////////////////
	// KickPanel Class //
	/////////////////////	
	public class KickPanel extends Panel {
		
		public function KickPanel(panelName:String, menuWidth:int, panelWidth:int, height:int, TAB_SIZE:Number, leftSide:Boolean):void {
			super(panelName, menuWidth, panelWidth, height, TAB_SIZE, leftSide);
			nextY = TAB_SIZE;
			initialize();
		}
		
		private function initialize():void {
		
		}				
	}
}