package {
	
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.text.*;
	
	/////////////////
	// Description //
	/////////////////
	/**
	 * The ScrollTarget Class is a helper class that holds information about different
	 * types of tabs
	 *
	 * Note: This Class is not a Sprite. It just holds information.
	 *
	 * @category   root
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (01/07/2014)
	 */

	////////////////
	// ScrollTarget Class //
	////////////////	
	public class ScrollTarget extends Sprite {
		
		//vars
		private var textField:TextField;
		private var sprite:Sprite;
		private var isText:Boolean;
		
		/*
		public function ScrollTarget(s:Sprite) {
			this.isText = false;
			this.sprite = s;
		}
		*/
		public function ScrollTarget(t:TextField = null, s:Sprite = null):void {
			if( s == null) {
				isText = true;
			} else {
				isText = false;
			}
			this.textField = t;
		}
		
		public function getHeight():Number {
			if(isText) {
				return textField.maxScrollV;
			} else {
				return sprite.height;
			}
		}
		
		public function setY(y:Number):void {
			if(isText) {
				this.textField.scrollV = y;
			} else {
				this.sprite.y = y;
			}
		}
		
		public function getY():Number {
			if(isText) {
				return this.textField.scrollV;
			} else {
				return this.sprite.y;
			}
		}
	}
}