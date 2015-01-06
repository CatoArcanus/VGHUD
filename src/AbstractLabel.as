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
	 * The AbstractLabel is one of many objects in a menu
	 *
	 * @namespace  root.menu.tab
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/29/2014)
	 */

	/////////////////////////
	// AbstractLabel Class //
	/////////////////////////
	public class AbstractLabel extends UIElement {
		
		public var text:TextField;
		public var labelName:String;
		
		public function AbstractLabel(labelName:String, width:int, TAB_SIZE:Number):void {
			this.myWidth = width;
			this.myHeight = TAB_SIZE;
			this.labelName = labelName;
			this.maxAlpha = 1.0;
			this.minAlpha = 0.5;
			this.currentAlpha = minAlpha;
			this.fade = currentAlpha;
			this.buttonMode = false;
			this.mouseChildren = true;
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/4;
			myFormat.font = "Arial";
			
			text = new TextField();
			text.text = labelName;
			text.textColor = 0xFFFFFF;
			text.x = TAB_SIZE*.15625;
			text.y = TAB_SIZE*.25;
			text.width = width-text.x;
			text.embedFonts = true;  
			text.setTextFormat(myFormat);
			text.selectable = false;
			init();
		}
		private function init()	{
			addChild(text);
		}	
	}
}