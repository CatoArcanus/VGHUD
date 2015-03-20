package com.vrl.controls {
	
	import flash.display.Sprite;	
	import flash.display.Shape;	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.external.ExternalInterface;
	
	import com.vrl.UIElement;
	import com.vrl.utils.SureLabel;
	
	/////////////////
	// Panel Class //
	/////////////////
	public class Panel extends UIElement {
		
		var panelName:String;
		public var nextY:int = 0;
		public var tabNumber:Number = 0;
		public var labels:Array = new Array();
		public var TAB_SIZE:Number;
		public var labelContainer:Sprite = new Sprite();
		public var verticalMover:Boolean;
		var scroller:ScrollerMC;
		
		/**
		* A panel is a container for buttons, labels, and icons.
		* Panels always have a mask that they may hide behind in order to leave view.
		*/				
		public function Panel(panelName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, verticalMover:Boolean, stageRef:Stage, scrollerHeight:Number):void {		
			//Variables that are not the default
			this.easing = .2;
			this.color = 0x222222;
			this.currentAlpha = .5;
			this.visible = false;
			this.TAB_SIZE = TAB_SIZE;
			this.myWidth = myWidth;
			this.myHeight = TAB_SIZE/4;
			this.panelName = panelName;
			this.verticalMover = verticalMover;
			
			//Text Format
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			nextY = TAB_SIZE/4;
									
			//Scroller
			scroller = new ScrollerMC(labelContainer, TAB_SIZE, stageRef, scrollerHeight);
			scroller.x = width-16;
			scroller.y = labelContainer.y;
									
			init();
		}
		
		//add event listeners and children
		private function init():void {
			addChild(labelContainer);
			addChild(scroller);
			addEventListener(MouseEvent.MOUSE_OVER, captureScroll);
			draw();
		}
		
		//This is a versatle function that adds a new surelabel based on the context.
		//We will have already made tabualr space for it if the panel is open
		public function addSureLabel(sureTitle:String, sureText:String, onClick:Function, TAB_SIZE:Number) {
			var sureLabel:SureLabel = new SureLabel(sureTitle, sureText, onClick, TAB_SIZE);
			sureLabel.x = TAB_SIZE/2;
			sureLabel.y = nextY;
			sureLabel.openY = sureLabel.y;
			nextY = sureLabel.y + sureLabel.myHeight + TAB_SIZE/4;
			labelContainer.addChild(sureLabel);
			myHeight +=	TAB_SIZE*5/4;
			this.closeY -= TAB_SIZE*5/4;
			if(!visible){
				this.y -= TAB_SIZE*5/4;
			}
			labels[sureTitle] = sureLabel;
			if(this.mask.height < this.myHeight) {
				scroller.visible = true;
			}
		}
		
		//This will remove a surelabel, and then pull up if the menu is open
		public function removeSureLabel(sureTitle:String) {
			labelContainer.removeChild(labels[sureTitle]);
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
				labels[belowStrings[0]].openY -= TAB_SIZE*5/4;//-TAB_SIZE * 5/4;
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
		
		//This pulls all of the labels below it up, a more responsive way to order objects 
		//in a list without holes.
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
		
		//FIXME: not DRY, this method is also in chatwindow. Need to fix this.
		//Captures scrolling input
		private function captureScroll( event:Event ):void {
			removeEventListener(MouseEvent.MOUSE_OVER, captureScroll);
			addEventListener(MouseEvent.MOUSE_OUT, removeCaptureScroll);
			ExternalInterface.call("asReceiveRemoveScroll");
		}
 		
 		//Captures scrolling input
 		private function removeCaptureScroll( event:Event ):void {
			addEventListener(MouseEvent.MOUSE_OVER, captureScroll);
			removeEventListener(MouseEvent.MOUSE_OUT, removeCaptureScroll);
			ExternalInterface.call("asReceiveAddScroll");
		}		
	}
}