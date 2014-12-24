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
		
	///////////////////
	//* Description *//
	///////////////////
	/**
	 * The Tab is one of many objects in a menu
	 *
	 * @category   movieclip
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/23/2014)
	 */

	////////////////////////
	//* Tab Class *//
	////////////////////////	
	public class Tab extends Sprite {
		
		public var icon:Icon;
		public var text:TextField;
		public var tabName:String;
		public var myWidth:int; 
		public var myHeight:int; 
		public var myFont:Font; 
		
		public function Tab(tabName:String, TAB_HEIGHT:int):void {
			icon = new Icon(tabName, TAB_HEIGHT);
			icon.x = TAB_HEIGHT/8;
			icon.y = TAB_HEIGHT/4;
			
			var myFont = new Museo300();
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_HEIGHT/2;
			myFormat.font = "Arial";
			
			text = new TextField();
						
			text.text = tabName;
			text.textColor = 0xFFFFFF;
			text.x = TAB_HEIGHT*.875;
			text.y = TAB_HEIGHT*.15625;
			text.width = 300-text.x;
			text.embedFonts = true;  
			text.setTextFormat(myFormat);
			
			this.myWidth = 300;
			this.myHeight = TAB_HEIGHT;
			init();
		}
		
		private function init():void {
			addChild(icon);
			addChild(text);
			addEventListener(MouseEvent.MOUSE_OVER, highlight);
		}
		
		public function highlight(e:MouseEvent = null):void {
			trace("highlit");
			graphics.clear();
			graphics.beginFill(0x222222, 1.0);
			graphics.drawRect(0, 0, this.myWidth, this.myHeight); 
			graphics.endFill();
			
			removeEventListener(MouseEvent.MOUSE_OVER, highlight);
			addEventListener(MouseEvent.MOUSE_OUT, unHighlight);
			
		}
		
		public function unHighlight(e:MouseEvent = null):void {
			trace("unhighlit");
			graphics.clear();
			graphics.beginFill(0x000000, .0);
			graphics.drawRect(0, 0, this.myWidth, this.myHeight); 
			graphics.endFill();
			removeEventListener(MouseEvent.MOUSE_OUT, unHighlight);
			addEventListener(MouseEvent.MOUSE_OVER, highlight);
		}
		
		public function draw(width:int, height:int):void {
			graphics.beginFill(0x000000, .0);
			graphics.drawRect(0, 0, width, height); 
			graphics.endFill();
		}
	}
}