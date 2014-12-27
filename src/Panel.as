package  {
	
	import flash.display.Sprite;	
	import flash.display.MovieClip;
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
	 * The Panel is one of many objects in a menu
	 *
	 * @category   root.menu.panel[]
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.1 (12/27/2014)
	 */

	////////////////////////
	//* Panel Class *//
	////////////////////////	
	public class Panel extends UIElement {
		
		var panelName:String;
		public var text:TextField;
				
		public function Panel(panelName:String, width:int, height:int, TAB_SIZE:Number):void {		
			this.easing = .2;
			this.color = 0x222222;
			this.currentAlpha = .5;
			this.x = 0;
			this.y = 0;
			this.closeX = 0;
			this.openX = width*(-1);
			this.visible = false;
					
			var myFormat:TextFormat = new TextFormat();
			//TODO: make this number modular
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			
			text = new TextField();
						
			text.text = panelName;
			text.textColor = 0xFFFFFF;
			text.x = 15;
			text.y = 15;
			text.width = width-text.x;
			text.embedFonts = true;  
			text.setTextFormat(myFormat);
			text.selectable = false;
			
			this.myWidth = width;
			this.myHeight = height;
			this.panelName = panelName; 
			init();
		}
		
		private function init():void {
			addChild(text);
			draw();
		}	
					
	}	
}