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
	 * @namespace  root.menu.tab
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.0 (12/23/2014)
	 */

	////////////////////////
	//* Tab Class *//
	////////////////////////	
	public class Tab extends UIElement {
		
		public var icon:Icon;
		public var text:TextField;
		public var tabName:String;	
		
		public function Tab(tabName:String, width:int, TAB_SIZE:Number, leftSide:Boolean):void {
			this.myWidth = width;
			this.myHeight = TAB_SIZE;
			this.tabName = tabName 
			this.easing = .3;
			this.maxAlpha = 1.0; 
			this.minAlpha = 0.0; 
			this.currentAlpha = minAlpha;
			this.fade = currentAlpha;
			this.buttonMode=true;
			this.mouseChildren=false;
			
			icon = new Icon(tabName, TAB_SIZE);
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
						
			text.text = tabName;
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
			
			this.draw();
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