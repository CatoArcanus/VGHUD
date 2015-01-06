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
	 * The AbstractButton is one of many objects in a menu
	 *
	 * @namespace  root.menu.tab
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/29/2014)
	 */

	//////////////////////////
	// AbstractButton Class //
	//////////////////////////
	public class AbstractButton extends UIElement {
		
		public var icon:Icon;
		public var text:TextField;
		public var buttonName:String;
		
		public function AbstractButton(buttonName:String, width:int, TAB_SIZE:Number):void {
			this.myWidth = width;
			this.myHeight = TAB_SIZE;
			this.buttonName = buttonName;
			this.easing = .3;
			this.maxAlpha = 1.0;
			this.minAlpha = 0.5;
			this.currentAlpha = minAlpha;
			this.fade = currentAlpha;
			this.buttonMode = true;
			this.mouseChildren = false;
		}
		
		public function highlight(e:MouseEvent = null):void {
			//trace("highlight");
			fade = maxAlpha;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.ROLL_OUT, unHighlight);
			removeEventListener(MouseEvent.ROLL_OVER, highlight);
		}
		
		public function unHighlight(e:MouseEvent = null):void {
			//trace("unhighlight");
			fade = minAlpha;
			removeEventListener(MouseEvent.ROLL_OUT, unHighlight);
			addEventListener(MouseEvent.ROLL_OVER, highlight);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			//trace(frameCounter + "fade: "+fade+" -- dx:" + (dx)+ "currentAlpha: "+currentAlpha+ " abs " + (Math.abs(dx *10)));
			//My distance = (where I want to go) - where I am
			dx = ( fade - currentAlpha);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(dx *10) < .01) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				frameCounter = 0;
			} else {
				currentAlpha += dx * easing;
				draw();
			}
			frameCounter++;
		}
	
	}
}