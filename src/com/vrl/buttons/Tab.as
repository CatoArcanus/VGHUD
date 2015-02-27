package com.vrl.buttons {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import com.vrl.UIElement;
	import com.vrl.utils.RotatingIcon;
	import com.vrl.utils.Icon;
	
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
		
		public var rotatingIcon:RotatingIcon;
		public var dr:Number;
		public var maxOpenY:Number = 3000;
		public var minCloseY:Number = -100;
		public var shadow;
		public var accordian:Boolean = false; 
		public var myFormat:TextFormat;
		
		public function Tab(buttonName:String, width:int, TAB_SIZE:Number, leftSide:Boolean, scaleForm:Boolean = true, accordian:Boolean = false):void {
			super(buttonName, buttonName, width, TAB_SIZE);
			this.color = 0x000000;
			this.maxAlpha = 1.0;
			this.minAlpha = 0.0;
			this.currentAlpha = minAlpha;
			this.fade = currentAlpha;
			this.accordian = accordian;
			
			icon = new Icon(buttonName, TAB_SIZE, scaleForm);
			if(leftSide) {
				icon.x = myWidth - TAB_SIZE*.625;
			} else {
				icon.x = TAB_SIZE/8;
			}
			icon.y = TAB_SIZE/4;
			
			var myFont = new Arial();
			
			myFormat = new TextFormat();
			myFormat.size = TAB_SIZE/2;
			//myFormat.font = "Arial";
			myFormat.font = myFont.fontName;
									
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
			//text.embedFonts = true;
			text.embedFonts = true;
			//text.antiAliasType = AntiAliasType.ADVANCED;  
			text.setTextFormat(myFormat);
			text.selectable = false;
						
			rotatingIcon = new RotatingIcon("ArrowLeft", TAB_SIZE, scaleForm);
			if(accordian){
				if(leftSide) {
					rotatingIcon.x = TAB_SIZE/8;
				} else {
					rotatingIcon.x = myWidth - TAB_SIZE*.625;
				}
				rotatingIcon.y = TAB_SIZE/2;
				addChild(rotatingIcon);
			}
			
			init();
		}
				
		private function init():void {
			addChild(icon);
			addChild(text);
			addEventListener(MouseEvent.ROLL_OVER, highlight);
		}
		
		public function setOpenY(number:int):void {
			if( number > maxOpenY) {
				this.openY = maxOpenY;	
			} else {
				this.openY = number; 
			}
		}
		
		public function rotateIconDown(e:MouseEvent = null):void {
			//trace("highlight");
			rotatingIcon.rotateTo = rotatingIcon.minRotation;
			addEventListener(Event.ENTER_FRAME, onRotate);
		}
		
		public function rotateIconUp(e:MouseEvent = null):void {
			//trace("highlight");
			rotatingIcon.rotateTo = rotatingIcon.maxRotation;
			addEventListener(Event.ENTER_FRAME, onRotate);
		}
				
		private function onRotate(e:Event):void {
			//If where I want to go is less than 1, I will stay there
			//Otherwise move a proportional distance to my target "easing" my way there
			if(rotatingIcon.rotation == rotatingIcon.rotateTo) {
				removeEventListener(Event.ENTER_FRAME, onRotate);
				frameCounter = 0;
			} else {
				if(rotatingIcon.rotateTo == rotatingIcon.minRotation) {
					rotatingIcon.rotation -= 10;
				} else {
					rotatingIcon.rotation += 10;
				}
				this.draw();
			}
			frameCounter++;
		}
		
		public override function draw():void {
			super.draw();
			//trace("i'm being called");
			graphics.lineStyle(1, 0xFFFFFF, .75);
			graphics.moveTo(0, 0); 
			graphics.lineTo(myWidth, 0);
			//graphics.moveTo(0, myHeight); 
			//graphics.lineTo(myWidth, myHeight);
		}
	}
}