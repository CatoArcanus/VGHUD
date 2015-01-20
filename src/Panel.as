package {
	
	import flash.display.Sprite;	
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
	 * The Panel is one of many objects in a menu
	 *
	 * @category   root.menu.panel[]
	 * @package    src
	 * @author     Monte Nichols (Original Author) <monte.nichols.ii@gmail.com>
	 * @copyright  Virtual Reality Labs at the Center for Brainhealth
	 * @version    1.2 (12/29/2014)
	 */

	/////////////////
	// Panel Class //
	/////////////////
	public class Panel extends UIElement {
		
		var panelName:String;
		public var text:TextField;
		public var nextY:int = 0;
		public var tabNumber:Number = 0;
		public var labels:Array = new Array();
		public var TAB_SIZE:Number;
		var holderMC:Sprite;
		var scrollerMC:ScrollerMC;
		
		public function Panel(panelName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, stageRef:Stage, scrollerHeight:Number):void {		
			//Variables that are not the default
			this.easing = .2;
			this.color = 0x222222;
			this.currentAlpha = .5;
			this.visible = false;
			this.TAB_SIZE = TAB_SIZE;
			
			//This is needed for right/left side
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			//A title. This is fairly standard
			text = new TextField();
			text.text = panelName;
			text.textColor = 0xFFFFFF;
			text.x = 15;
			text.y = 15;
			text.width = myWidth-text.x;
			text.embedFonts = true;  
			text.setTextFormat(myFormat);
			text.selectable = false;
			nextY = TAB_SIZE/4;
			
			holderMC = new Sprite();
						
			//Scroller
			scrollerMC = new ScrollerMC(holderMC, TAB_SIZE, stageRef, scrollerHeight);
			scrollerMC.x = width-16;
			scrollerMC.y = holderMC.y;
						
			this.myWidth = myWidth;
			this.myHeight = TAB_SIZE/4;
			this.panelName = panelName;
						
			init();
		}
		
		private function init():void {
			addChild(text);
			addChild(holderMC);
			addChild(scrollerMC);
			draw();
		}
		
		public function addSureLabel(sureTitle:String, sureText:String, TAB_SIZE:Number) {
			var sureLabel:SureLabel = new SureLabel(sureTitle, sureText, TAB_SIZE);
			sureLabel.x = TAB_SIZE/2;
			sureLabel.y = nextY;
			nextY = sureLabel.y + sureLabel.myHeight + TAB_SIZE/4;
			holderMC.addChild(sureLabel);
			myHeight +=	TAB_SIZE*5/4;
			this.closeY -= TAB_SIZE*5/4;
			if(!visible){
				this.y -= TAB_SIZE*5/4;
			}
			labels[sureTitle] = sureLabel;
			if(this.mask.height < this.myHeight) {
				scrollerMC.visible = true;
			}
		}
		
		public function removeSureLabel(sureTitle:String) {
			holderMC.removeChild(labels[sureTitle]);
			nextY -= TAB_SIZE*5/4;
			var thisY:Number = labels[sureTitle].y;
			var belowStrings:Array = new Array();
			delete labels[sureTitle];
			for (var key:String in labels) {
				trace(key);
				if(labels[key].y > thisY) {
					trace(key);
					belowStrings.push(key);
				}
			}
			trace("BelowStrings.length = " + belowStrings.length);
			if(belowStrings.length > 0) {
				labels[belowStrings[0]].openY = thisY;//-TAB_SIZE * 5/4;
				labels[belowStrings[0]].moveY = labels[belowStrings[0]].openY;
				var returnPullUp:Function = pullUp(belowStrings);
				addEventListener(Event.ENTER_FRAME, returnPullUp);
			}
			this.closeY += TAB_SIZE*5/4;
			myHeight -=	TAB_SIZE*5/4;
			if(!visible){
				this.y += TAB_SIZE*5/4;
			}
		}
		public function pullUp(belowStrings:Array):Function {
			trace("inside function BelowStrings.length = " + belowStrings.length);
			return function (e:Event):void {
				//My distance = (where I want to go) - where I am
				trace("@@inside this function BelowStrings.length = " + belowStrings.length);
				if(!labels.hasOwnProperty(belowStrings[0])){
					removeEventListener(Event.ENTER_FRAME, arguments.callee);
					return;
				}
				labels[belowStrings[0]].dy = ( labels[belowStrings[0]].moveY - labels[belowStrings[0]].y);
				//If where I want to go is less than 1, I will stay there
				//Otherwise move a proportional distance to my target "easing" my way there
				if(Math.abs(labels[belowStrings[0]].dy) < 1) {
					removeEventListener(Event.ENTER_FRAME, arguments.callee);
				} else {
					//panels[currentPanel].y += panels[currentPanel].dy * panels[currentPanel].easing;
					for(var i:int = 0; i < belowStrings.length; i++) {
						trace("move label " + belowStrings[i])
						labels[belowStrings[i]].y += labels[belowStrings[0]].dy * labels[belowStrings[i]].easing;
					}
				}
			}
		}
	}
}