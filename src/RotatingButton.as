package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The Rotating Button is a variable size and has a single icon in the middle
	 * It eases through a rotation animation when clicked and toggles its state
	 * this is usually used for arrows that rotate in and out as they are clicked
	 *
	 * @namespace  root.menu.button
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/31/2014)
	 */

	//////////////////////////
	// RotatingButton Class //
	//////////////////////////
	public class RotatingButton extends IconButton {
			
		public function RotatingButton(buttonName:String, TAB_SIZE:Number):void {
			super(buttonName, TAB_SIZE, TAB_SIZE);
			
			this.easing = .3;
			this.maxAlpha = 0.0;
			this.minAlpha = 0.0;
			this.currentAlpha = minAlpha;
			this.fade = currentAlpha;
			
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