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
	 * The Tab is one of many objects in a menu
	 *
	 * @namespace  root.menu.tab
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/23/2014)
	 */

	///////////////
	// Tab Class //
	///////////////	
	public class Tab extends AbstractButton {
		
		public function Tab(buttonName:String, width:int, TAB_SIZE:Number, leftSide:Boolean):void {
			super(buttonName, width, TAB_SIZE);
			icon = new Icon(buttonName, TAB_SIZE);
			if(leftSide) {
				icon.x = myWidth - TAB_SIZE*.625;
			} else {
				icon.x = TAB_SIZE/8;
			}
			icon.y = TAB_SIZE/4;
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			
			text = new TextField();
			
			text.text = buttonName;
			text.textColor = 0xFFFFFF;
			if(leftSide) {
				text.x = TAB_SIZE*.15625;
			} else {
				text.x = TAB_SIZE*.875;
			}
			text.y = TAB_SIZE*.15625;
			text.width = width-text.x;
			text.embedFonts = true;  
			text.setTextFormat(myFormat);
			text.selectable = false;
			init();
		}
		
		private function init():void {
			addChild(icon);
			addChild(text);
			addEventListener(MouseEvent.ROLL_OVER, highlight);
		}
	}
}