package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
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
	 * The Icon Button is a variable size and has a single icon in the middle
	 *
	 * @namespace  root.menu.button
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/29/2014)
	 */

	//////////////////////
	// IconButton Class //
	//////////////////////
	public class IconButton extends AbstractButton {
			
		public function IconButton(buttonName:String, TAB_SIZE:Number):void {
			super(buttonName, TAB_SIZE, TAB_SIZE);
			
			icon = new Icon(buttonName, TAB_SIZE);
			icon.x = TAB_SIZE/4;
			icon.y = TAB_SIZE/4;
			
			this.draw();
			init();
		}
		
		//Add items to stage
		private function init():void {
			addChild(icon);
			addEventListener(MouseEvent.ROLL_OVER, highlight);
		}
	}
}