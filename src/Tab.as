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
	 * @namespace  root.menu.tab[]
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
		public var easing:Number = .3;
		public var maxAlpha:Number = 1.0; 
		public var minAlpha:Number = 0.0; 
		public var fade:Number = 0.0;
		public var currentAlpha = 0.0;
		public var dx:Number;  
		public var frameCounter:int = 0;  
		
		public function Tab(tabName:String, width:int, TAB_HEIGHT:int):void {
			icon = new Icon(tabName, TAB_HEIGHT);
			icon.x = TAB_HEIGHT/8;
			icon.y = TAB_HEIGHT/4;
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_HEIGHT/2;
			myFormat.font = "Arial";
			
			text = new TextField();
						
			text.text = tabName;
			text.textColor = 0xFFFFFF;
			text.x = TAB_HEIGHT*.875;
			text.y = TAB_HEIGHT*.15625;
			text.width = width-text.x;
			text.embedFonts = true;  
			text.setTextFormat(myFormat);
			text.selectable = false;
			
			this.myWidth = width;
			this.myHeight = TAB_HEIGHT;
			this.tabName = tabName 
			init();
		}
		
		private function init():void {
			addChild(icon);
			addChild(text);
			addEventListener(MouseEvent.ROLL_OVER, highlight);
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
			//trace(frameCounter + "fade: "+fade+" -- dx:" + (dx)+ "currentAlpha: "+currentAlpha+ " abs " + (Math.abs(dx *100)));
			//My distance = (where I want to go) - where I am
			dx = ( fade - currentAlpha);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(dx *100) < .01) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				frameCounter = 0;
			} else {
				currentAlpha += dx * easing;
				draw();
			}
			frameCounter++;
		}
		
		public function draw():void {
			graphics.clear();
			graphics.beginFill(0x222222, currentAlpha);
			graphics.drawRect(0, 0, myWidth, myHeight); 
			graphics.endFill();
		}
	}
}