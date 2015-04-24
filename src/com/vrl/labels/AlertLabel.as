package com.vrl.labels {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;	
	import flash.utils.Timer;
	import flash.text.*;
	
	import com.vrl.UIElement;
	import com.vrl.buttons.TextButton;

	//////////////////////
	// AlertLabel Class //
	//////////////////////
	public class AlertLabel extends AbstractLabel {
		
		public var subText:TextField;
		public var internalBorder:Sprite;
		
		/**
		* Alert Labels have a gradient to them and are expected to have a certain lifetime.
		* They have an alert message, and a subtext which gives specific information.
		* 
		*/
		public function AlertLabel(labelName:String, text:String, TAB_SIZE:Number):void {
			super(labelName, TAB_SIZE*5, TAB_SIZE);
			
			this.easing = .2;
			this.minAlpha = 0.0;
			this.maxAlpha = 0.8;
			this.currentAlpha = minAlpha;
			this.fade = currentAlpha;
						
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = TAB_SIZE/4;
			myFormat.font = "Arial";
			
			//Secondary text
			subText = new TextField(); 
			subText.text = text;
			subText.textColor = 0xDDDDDD;
			subText.x = TAB_SIZE/4;
			subText.y = TAB_SIZE/2;
			subText.embedFonts = true;
			subText.selectable = false;
			subText.setTextFormat(myFormat);
			
			//Format the text differently for this box
			myFormat.size = TAB_SIZE/3;
			this.text.setTextFormat(myFormat);
			this.text.y = TAB_SIZE/12;
			
			//Add a border to make the alert look nice
			this.internalBorder = new Sprite();
			this.internalBorder.graphics.lineStyle(2, 0xFFFFFF, .75);
			this.internalBorder.graphics.moveTo(this.myWidth, this.myHeight-TAB_SIZE/16);
			this.internalBorder.graphics.lineTo(TAB_SIZE/16, this.myHeight-TAB_SIZE/16);
			this.internalBorder.graphics.lineTo(TAB_SIZE/16, TAB_SIZE/16);
			this.internalBorder.graphics.lineTo(this.myWidth, TAB_SIZE/16);
			//this.internalBorder.graphics.lineTo(TAB_SIZE/16, TAB_SIZE/16);
			
			this.draw();
			initialize();
		}
		
		//Add items to stage
		private function initialize():void {
			this.addChild(internalBorder);
			this.addChild(subText);
		}
		
		public function intro(setX:int, setY:int):void {
			this.x = setX;
			this.openX = this.x-myWidth;
			this.x += this.myWidth/2;
			this.closeX = this.x;
			this.y = setY;
			fade = maxAlpha;
			moveX = openX;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, onEase);
		}
		
		//All buttons should be highlighted when moused over
		public function closeAndKill(e:TimerEvent):void {
			//trace("highlight " + buttonName);
			fade = minAlpha;			
			moveX = closeX;
			easing = .1;			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ENTER_FRAME, onEase);
		}	
		
		//handle alpha changes, positive or negative
		private function onEnterFrame(e:Event):void {
			//trace(frameCounter + "fade: "+fade+" -- da:" + (da)+ "currentAlpha: "+currentAlpha+ " abs " + (Math.abs(da *10)));
			//My distance = (where I want to go) - where I am
			da = ( fade - currentAlpha);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(da *10) < .01) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				frameCounter = 0;
			} else {
				currentAlpha += da * easing;
				this.draw();
			}
			frameCounter++;
		}
		
		public function onEase(e:Event):void {
			//My distance = (where I want to go) - where I am
			this.dx = ( this.moveX - this.x);
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(Math.abs(this.dx) < 1) {
				removeEventListener(Event.ENTER_FRAME, onEase);
				this.frameCounter = 0;
				if(Math.abs(this.openX - this.moveX) < 1) {
					var myLifeTimer:Timer = new Timer(3000, 1); // 3 seconds
					myLifeTimer.addEventListener(TimerEvent.TIMER, closeAndKill);
					myLifeTimer.start();
				} else {
					parent.removeChild(this);
				}
			} else {
				this.x += this.dx * this.easing;
			}
			this.frameCounter++;
		}
	}
}