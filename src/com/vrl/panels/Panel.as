package com.vrl.panels {
	
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
	import com.vrl.labels.ButtonLabel;
	import com.vrl.utils.ScrollerMC;
	
	/////////////////
	// Panel Class //
	/////////////////
	public class Panel extends UIElement {
		
		var panelName:String;
		public var nextY:int = 0;
		public var tabNumber:Number = 0;
		public var labels:Array = new Array();
		public var TAB_SIZE:Number;
		public var labelContainer:UIElement;// = new Sprite();
		public var verticalMover:Boolean;
		var scroller:ScrollerMC;
		
		/**
		* A panel is a container for buttons, labels, and icons.
		* Panels always have a mask that they may hide behind in order to leave view.
		*/				
		public function Panel(panelName:String, width:int, height:int, TAB_SIZE:Number, leftSide:Boolean, verticalMover:Boolean, stageRef:Stage, maxHeight:Number):void {		
			//Variables that are not the default
			this.easing = .2;
			this.color = 0x222222;
			this.currentAlpha = .5;
			this.visible = false;
			this.TAB_SIZE = TAB_SIZE;
			this.myWidth = width;
			this.myHeight = TAB_SIZE/4;
			this.currentAlpha = 0;
			this.panelName = panelName;
			this.verticalMover = verticalMover;
			
			//Text Format
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			myFormat.font = "Arial";
			nextY = TAB_SIZE/4;
			//labelContainer
			labelContainer = new UIElement;//Sprite();
			labelContainer.x = TAB_SIZE/2;
			labelContainer.y = 0;
			labelContainer.myHeight = 0;
			labelContainer.myWidth = 0;
									
			//Scroller
			scroller = new ScrollerMC(labelContainer, TAB_SIZE, stageRef, maxHeight);
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
		
		//This is a versatle function that adds a new buttonlabel based on the context.
		//We will have already made tabualr space for it if the panel is open
		public function addButtonLabel(id:String, labelName:String, buttonText:String, onClick:Function, TAB_SIZE:Number) {
			//var label:ButtonLabel;
			//if(sureWindow != null) {
			//	label = new SureLabel(labelName, buttonText, onClick, TAB_SIZE, sureWindow);
			//} else {
				//label = new ButtonLabel(labelName, buttonText, onClick, TAB_SIZE);
			//}
			var label:ButtonLabel = new ButtonLabel(labelName, buttonText, onClick, myWidth-TAB_SIZE, TAB_SIZE);
			label.x = 0;//TAB_SIZE/2;
			label.y = nextY;
			//label.visible = false;
			label.openY = label.y;
			nextY = label.y + label.myHeight + TAB_SIZE/4;
			labelContainer.myWidth = label.width;
			labelContainer.myHeight += TAB_SIZE*5/4;
			labelContainer.addChild(label);
			myHeight +=	TAB_SIZE*5/4;
			this.closeY -= TAB_SIZE*5/4;
			if(!visible){
				this.y -= TAB_SIZE*5/4;
			}
			labels[id] = label;
			if(labelContainer.height < scroller.height ) {
				this.mask.height = labelContainer.height-TAB_SIZE;
			}
			if(this.scroller.height < this.myHeight) {
				this.mask.height = this.scroller.height;//labelContainer.height-TAB_SIZE;
				scroller.visible = true;
			}
		}	
		
		//This will remove a buttonlabel, and then pull up if the menu is open
		public function removeButtonLabel(id:String) {
			labelContainer.removeChild(labels[id]);
			nextY -= TAB_SIZE*5/4;
			var thisY:Number = labels[id].y;
			var belowStrings:Array = new Array();
			delete labels[id];
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
				if(visible){
					//FIXME: Problem when this is called multiple times as things are affectign the same thin
					//need to make a state buffer for this similar to the timer buffer in Menu
					var returnPullUp:Function = pullUp(belowStrings);
					addEventListener(Event.ENTER_FRAME, returnPullUp);
				} else {
					for(var i:int = 0; i < belowStrings.length; i++) {
						trace("move label " + belowStrings[i])
						labels[belowStrings[i]].y -= TAB_SIZE*5/4;
					}
				}
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
				//FIXME: Change the way this works. HasOwnProperty does not work in ScaleForm
				//Test This
				//if(belowStrings.length == 1) {
					//removeEventListener(Event.ENTER_FRAME, arguments.callee);
					//I'm returning
					//return;
				//}
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